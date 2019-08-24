;;Usage: guix system container system.scm and exec the resulting script with sudo.
     (use-modules (gnu) (gnu packages linux))
     (use-service-modules networking)
     (use-package-modules screen admin)
 
     (operating-system
       (host-name "Guix-Container")
       (timezone "Europe/Berlin")
       (locale "en_US.utf8")
		
       (kernel linux-libre) 
       (kernel-arguments '("quiet" "elevator=noop"))

       ;; bootloader and filesystem necessary even though they are ignored in container mode
       (bootloader (bootloader-configuration
                     (bootloader grub-bootloader)
                     (target "/dev/sdX")))
       (file-systems (cons (file-system
                             (device (file-system-label "my-root"))
                             (mount-point "/")
                             (type "ext4"))
                           %base-file-systems))
        (packages (append (list htop neofetch) %base-packages ))
        (services
         (list
           (udev-service) ;;required for tty console
           (guix-service)
           (login-service);;required for obvious reasons. root pswd is empty btw.
           (agetty-service
             (agetty-configuration
               (term "linux")  ;;makes terminal colors work.
               (tty "console") ;;because no access to /dev/tty
             )
           )
		;;   (service virtual-terminal-service-type )
		;;   (mingetty-service
		;;     (mingetty-configuration
		;;		(tty "console")(auto-login "root")))

		;; kmscon is for framebuffer based consoles on real hardware
		;; requires (use-modules (gnu services dbus)), (dbus-service), (udev-service) and
		;; (service virtual-terminal-service-type)
		;;   (service kmscon-service-type
		;;      (kmscon-configuration (virtual-terminal "console")))
        ) ;; <= end list
          ) ;; <= end services
 
) ;; <= end operating-system
