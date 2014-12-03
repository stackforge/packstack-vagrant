--- a/usr/lib/python2.7/site-packages/packstack/puppet/templates/nova_compute_libvirt.pp 2014-12-02 16:17:54.839430681 +0000
+++ b/usr/lib/python2.7/site-packages/packstack/puppet/templates/nova_compute_libvirt.pp 2014-12-02 16:18:03.554430782 +0000
@@ -3,7 +3,7 @@
 # Ensure Firewall changes happen before libvirt service start
 # preventing a clash with rules being set by libvirt
 
-if $::is_virtual_packstack == 'true' {
+if $::is_virtual == 'true' {
   $libvirt_virt_type = 'qemu'
   $libvirt_cpu_mode = 'none'
 } else {
