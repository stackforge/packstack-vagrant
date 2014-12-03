--- a/usr/lib/python2.7/site-packages/packstack/puppet/templates/mongodb.pp 2014-12-02 16:19:58.274432117 +0000
+++ b/usr/lib/python2.7/site-packages/packstack/puppet/templates/mongodb.pp 2014-12-02 16:20:15.620432319 +0000
@@ -3,5 +3,5 @@
 class { 'mongodb::server':
   smallfiles => true,
   bind_ip    => [$mongodb_host],
+  pidfilepath => '/var/run/mongodb/mongod.pid',
 }
-
