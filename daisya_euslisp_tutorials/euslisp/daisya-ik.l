;;;
;;; ��ư��֥�ǥ��εձ�ư�ؤ�򤤤ơ�arm����֤���Ĥ��륵��ץ�
;;;    
;;;
(load "daisya.l")    ;;��֥�ǥ����������ե������load
(load "irteusext.l")

#|******************************
  �������ν����ư����
********************************|#
(if (not (boundp '*irtviewer*))
    (setq *irtviewer* (make-irtviewer)))
(defun init-daisya nil
  (setq *daisya* (instance daisyaclass :init)) 
  (send *daisya* :reset-pose)
  (objects (list *daisya*)))
(init-daisya)

#|*********************************************
  �����ܡ������Ϥˤ�äơ���ɸ��ɸ�򾯤�����ư��������ץ�
***********************************************|#
(warn "(ik-demo0)~%")
(defun ik-demo0
  (&key (step 10)        ;;step�ϰ��Υ롼�פ���ɸ��ư������Υ
        (use-base nil)  ;;���ؤ�Ȥä�IK��򤯤��ɤ���
        (robot *daisya*)
        )
  ;;�ձ�ư�ؤ��򤭤䤹������������ѹ�
  (send robot :reset-pose)
  (when (boundp '*ri*)
    (send *ri* :angle-vector (send robot :angle-vector) 5000)
    (send *ri* :wait-interpolation))
  (objects (list robot))

  ;;
  ;;'e'�򲡤��ޤ�³����
  (warn ";; if stop, then enter e~%")
  (warn ";;  h:left, j:down, k:up, l:right, f:forward, b:back~%")
  (let (w goal-endcoords ll)
    ;;�⤷�Ӥ����Ȥ�ʤ�����linklist�򤢤餫�����Ѱդ��Ƥ���
    ;;��ɸ��ɸ���������(�ǥե���Ȥϡ���֤μ�����֤�Ʊ���ˤ���)
    (setq goal-endcoords
          (make-cascoords :pos (send (send robot :arm :end-coords :copy-worldcoords) :worldpos)))
    ;;�롼�פ��
    (while t
      (setq w (read-line)) ;;ʸ�������
      ;;ʸ���ˤ�ä������Ѥ���
      (cond
       ((equal w "e")
        (return-from nil)) ;;loop����ȴ���ƽ�λ
       ((equal w "h")  ;;����ư����
        (send goal-endcoords :locate (float-vector 0 step 0)))
       ((equal w "j")  ;;����ư����
        (send goal-endcoords :locate (float-vector 0 0 (* -1 step))))
       ((equal w "k")  ;;���ư����
        (send goal-endcoords :locate (float-vector 0 0 step)))
       ((equal w "l")  ;;����ư����
        (send goal-endcoords :locate (float-vector 0 (* -1 step) 0)))
       ((equal w "f")  ;;����ư����
        (send goal-endcoords :locate (float-vector step 0 0)))
       ((equal w "b")  ;;���ư����
        (send goal-endcoords :locate (float-vector (* -1 step) 0 0)))
       ((not w)) ;;����������ʤ���в��⤷�ʤ�
       (t
        (warn ";; no such command~%")
        (warn ";; if stop, then enter e~%")
        (warn ";;  h:left, j:down, k:up, l:right, f:forward, b:back~%")
        ))
      ;;��ɸ��end-coords�˸����äƵձ�ư�ؤ�򤤤ơ�ư����
      ;;  inverse-kinematics�Ȥ����ձ�ư�ؤ�Ȥ�method��ƤӽФ���
      (cond
       (use-base ;;���ؤ�Ȥ����
        (send robot :inverse-kinematics goal-endcoords :rotation-axis nil :debug-view nil :use-base use-base))
       (t
        (send robot :inverse-kinematics goal-endcoords :rotation-axis nil :debug-view nil :link-list ll))
       )
      (send *irtviewer* :objects (list robot goal-endcoords))
      (send *irtviewer* :draw-objects)
      (when (boundp '*ri*)
        (send *ri* :angle-vector (send robot :angle-vector) 500)
        (send *ri* :wait-interpolation)
        )
      ))
  (warn ";; finished~%")
  t)