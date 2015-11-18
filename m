From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v2 3/3] drivers/base/class: __class_register(): invoke class' releaser on failure
Date: Wed, 18 Nov 2015 17:50:55 +0100
Message-ID: <874mgjckuo.fsf_-_@gmail.com>
References: <871tbpebjw.fsf@gmail.com> <20151117041213.GA10860@kroah.com>
	<87k2pfcl73.fsf_-_@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Nicolai Stange <nicstange@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87k2pfcl73.fsf_-_@gmail.com> (Nicolai Stange's message of "Wed,
	18 Nov 2015 17:43:28 +0100")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently, upon failure, __class_register() does not call the class_release
member of the struct class object handed over to it. This leads to
potentially duplicated cleanup code at the call sites: once for the error
path handling a failed __class_register() and once for an orderly class
deregistration.

Note however, that the impact is _very_ low: currently there are only five
clients of __class_register() passing class objects with a non-trivial
class_release member.
This patch is more about consolidating the __class_register() interface as
well as slightly cleaning up the latter's implementation, i.e. cosmetic in
nature.

The call sites of __class_register handing in a non-NULL class_release
member are:
- drivers/base/class.c
- drivers/block/osdblk.c
- drivers/block/pktcdvd.c
- drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
- drivers/pcmcia/cs.c
- drivers/isdn/mISDN/core.c

The first four just invoke a kfree() on the struct class object on failure
of __class_register() as well as in their class_release functions.

The next to last one from the PCMCIA subsystem is special as it completes
a condition variable in its class releaser pcmcia_release_socket_class().
This condition variable is waited on exclusively right after a call to
class_unregister() in the module_exit handler. Despite the fact that
the module_exit handler gets never executed if the __class_register()
invocation from the module init handler fails, there would be no harm if
it would.

Finally, the last candidate, the mISDN core, passes an empty class_release
implementation to __class_register().

Make __class_register() invoke the class_release member of the given
struct class object upon failure.
Adapt the callers to not do any cleanup as part of their error handling
if already handled by their respective class releaser.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 drivers/base/class.c                      | 14 ++++----------
 drivers/block/osdblk.c                    |  1 -
 drivers/block/pktcdvd.c                   |  1 -
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c |  1 -
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index fc663d0..6f89ee5 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -189,8 +189,11 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	pr_debug("device class '%s': registering\n", cls->name);
 
 	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
-	if (!cp)
+	if (!cp) {
+		if (cls->class_release)
+			cls->class_release(cls);
 		return -ENOMEM;
+	}
 	klist_init(&cp->klist_devices, klist_class_dev_get, klist_class_dev_put);
 	INIT_LIST_HEAD(&cp->interfaces);
 	kset_init(&cp->glue_dirs, &glue_dirs_ktype, NULL);
@@ -213,12 +216,6 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 
 	error = kset_register(&cp->subsys, cls->name, NULL);
 	if (error) {
-		/*
-		 * class->release() would be called by cp->subsys'
-		 * release function. Prevent this from happening in
-		 * the error case by zeroing cp->class out.
-		 */
-		cp->class = NULL;
 		cls->p = NULL;
 		kset_put(&cp->subsys);
 		return error;
@@ -226,8 +223,6 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	error = add_class_attrs(class_get(cls));
 	class_put(cls);
 	if (error) {
-		/* as above, clear cp->class on error */
-		cp->class = NULL;
 		cls->p = NULL;
 		kset_put(&cp->subsys);
 	}
@@ -285,7 +280,6 @@ struct class *__class_create(struct module *owner, const char *name,
 	return cls;
 
 error:
-	kfree(cls);
 	return ERR_PTR(retval);
 }
 EXPORT_SYMBOL_GPL(__class_create);
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 1b709a4..59d3fa3 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -662,7 +662,6 @@ static int osdblk_sysfs_init(void)
 
 	ret = class_register(class_osdblk);
 	if (ret) {
-		kfree(class_osdblk);
 		class_osdblk = NULL;
 		printk(PFX "failed to create class osdblk\n");
 		return ret;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index d06c62e..34693ac 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -429,7 +429,6 @@ static int pkt_sysfs_init(void)
 	class_pktcdvd->class_attrs = class_pktcdvd_attrs;
 	ret = class_register(class_pktcdvd);
 	if (ret) {
-		kfree(class_pktcdvd);
 		class_pktcdvd = NULL;
 		pr_err("failed to create class pktcdvd\n");
 		return ret;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
index 06fe63c..de7aca2 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
@@ -797,7 +797,6 @@ struct pvr2_sysfs_class *pvr2_sysfs_class_create(void)
 	if (class_register(&clp->class)) {
 		pvr2_sysfs_trace(
 			"Registration failed for pvr2_sysfs_class id=%p",clp);
-		kfree(clp);
 		clp = NULL;
 	}
 	return clp;
-- 
2.6.3
