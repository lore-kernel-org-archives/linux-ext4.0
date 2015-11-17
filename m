From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH] lib/kobject: fix memory leak in error path of kset_create_and_add()
Date: Tue, 17 Nov 2015 01:04:19 +0100
Message-ID: <871tbpebjw.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
CC: Andreas Dilger <adilger.kernel@dilger.ca>
CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Joe Perches <joe@perches.com>
CC: Nicolai Stange <nicstange@gmail.com>
CC: linux-kernel@vger.kernel.org
CC: linux-ext4@vger.kernel.org
CC: ocfs2-devel@oss.oracle.com
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In kset_create_and_add(), the name duped into the kset's kobject by
kset_create() gets leaked if the call to kset_register() fails.

Indeed, triggering failure by invoking kset_create_and_add() with a
duplicate name makes kmemleak reporting

  unreferenced object 0xffff8800b4a1f428 (size 16):
    comm "insmod", pid 682, jiffies 4294745489 (age 50.477s)
    hex dump (first 16 bytes):
      64 75 70 6c 69 63 61 74 65 00 6b 6b 6b 6b 6b a5  duplicate.kkkkk.
    backtrace:
      [<ffffffff814380ee>] kmemleak_alloc+0x4e/0xb0
      [<ffffffff811aab01>] __kmalloc_track_caller+0x2b1/0x390
      [<ffffffff811797f1>] kstrdup+0x31/0x60
      [<ffffffff81179843>] kstrdup_const+0x23/0x30
      [<ffffffff81290254>] kvasprintf_const+0x54/0x90
      [<ffffffff81284d21>] kobject_set_name_vargs+0x21/0xa0
      [<ffffffff81284dee>] kobject_set_name+0x4e/0x70
      [<ffffffff812854f5>] kset_create_and_add+0x45/0xa0
      [...]

Similar problems exist at all call sites of kset_register(), that is
in drivers/base, fs/ext4 and in fs/ocfs2.

The deeper cause behind this are the current semantics of the kset
initialization, creation and registration functions which differ from the
ones of their corresponding kobject counterparts.
Namely,
- there is no _exported_ kset initialization function,
- the (not exported) kset_create() creates a halfway initialized kset
  object,
- and the kset_register() finishes a kset object's initialization but
  expects its name to already have been set at its entry.

To fix this:
- Export kset_init() and let it mimic the semantics of kobject_init().
  Especially it takes and sets a kobj_type which makes the kset object
  kset_put()able upon return.
- Let the internal kset_create() do the complete initialization by means
  of kset_init().
- Remove any kset initialization from kset_register(): it expects a
  readily initialized kset object now. Furthermore, let kset_register()
  take and set the kset object's name. This resembles the behaviour of
  kobject_add(). In analogy to the latter, require the caller to call
  kset_put() or kset_unregister() unconditionally, even on failure.

At the call sites of kset_register():
- Replace the open coded kset object initialization by a call to
  kset_init().
- Remove the explicit name setting and let the kset_register() call do
  that work.
- Replace any kfree()s by kset_put()s where appropriate.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
To the maintainers of ext4 and ocfs2: although several subsystems are
touched, the changes come in one single patch in order to keep them bisectable.


 drivers/base/bus.c         | 14 ++-----
 drivers/base/class.c       | 39 ++++++++++++++-----
 fs/ext4/sysfs.c            | 13 +++----
 fs/ocfs2/cluster/masklog.c | 13 ++++---
 include/linux/kobject.h    |  6 ++-
 lib/kobject.c              | 94 ++++++++++++++++++++++++++++------------------
 6 files changed, 110 insertions(+), 69 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 5005924..a81227c 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -900,15 +900,11 @@ int bus_register(struct bus_type *bus)
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&priv->bus_notifier);
 
-	retval = kobject_set_name(&priv->subsys.kobj, "%s", bus->name);
-	if (retval)
-		goto out;
-
-	priv->subsys.kobj.kset = bus_kset;
-	priv->subsys.kobj.ktype = &bus_ktype;
 	priv->drivers_autoprobe = 1;
 
-	retval = kset_register(&priv->subsys);
+	kset_init(&priv->subsys, &bus_ktype, NULL);
+	priv->subsys.kobj.kset = bus_kset;
+	retval = kset_register(&priv->subsys, bus->name, NULL);
 	if (retval)
 		goto out;
 
@@ -955,10 +951,8 @@ bus_drivers_fail:
 bus_devices_fail:
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
-	kset_unregister(&bus->p->subsys);
 out:
-	kfree(bus->p);
-	bus->p = NULL;
+	kset_unregister(&bus->p->subsys);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(bus_register);
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 71059e3..94a5b040 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/genhd.h>
 #include <linux/mutex.h>
+#include <linux/printk.h>
 #include "base.h"
 
 #define to_class_attr(_attr) container_of(_attr, struct class_attribute, attr)
@@ -82,6 +83,24 @@ static struct kobj_type class_ktype = {
 	.child_ns_type	= class_child_ns_type,
 };
 
+static void glue_dirs_release_dummy(struct kobject *kobj)
+{
+	/*
+	 * The glue_dirs kset member of struct subsys_private is never
+	 * registered and thus, never unregistered.
+	 * This release function is a dummy to make kset_init() happy.
+	 */
+	pr_err(
+	"class (%p): unexpected kset_put() on glue_dirs, something is broken.",
+		container_of(kobj, struct subsys_private,
+				glue_dirs.kobj)->class);
+	dump_stack();
+}
+
+static struct kobj_type glue_dirs_ktype = {
+	.release = glue_dirs_release_dummy,
+};
+
 /* Hotplug events for classes go to the class subsys */
 static struct kset *class_kset;
 
@@ -175,18 +194,14 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 		return -ENOMEM;
 	klist_init(&cp->klist_devices, klist_class_dev_get, klist_class_dev_put);
 	INIT_LIST_HEAD(&cp->interfaces);
-	kset_init(&cp->glue_dirs);
+	kset_init(&cp->glue_dirs, &glue_dirs_ktype, NULL);
 	__mutex_init(&cp->mutex, "subsys mutex", key);
-	error = kobject_set_name(&cp->subsys.kobj, "%s", cls->name);
-	if (error) {
-		kfree(cp);
-		return error;
-	}
 
 	/* set the default /sys/dev directory for devices of this class */
 	if (!cls->dev_kobj)
 		cls->dev_kobj = sysfs_dev_char_kobj;
 
+	kset_init(&cp->subsys, &class_ktype, NULL);
 #if defined(CONFIG_BLOCK)
 	/* let the block class directory show up in the root of sysfs */
 	if (!sysfs_deprecated || cls != &block_class)
@@ -194,13 +209,19 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 #else
 	cp->subsys.kobj.kset = class_kset;
 #endif
-	cp->subsys.kobj.ktype = &class_ktype;
 	cp->class = cls;
 	cls->p = cp;
 
-	error = kset_register(&cp->subsys);
+	error = kset_register(&cp->subsys, cls->name, NULL);
 	if (error) {
-		kfree(cp);
+		/*
+		 * class->release() would be called by cp->subsys'
+		 * release function. Prevent this from happening in
+		 * the error case by zeroing cp->class out.
+		 */
+		cp->class = NULL;
+		cls->p = NULL;
+		kset_put(&cp->subsys);
 		return error;
 	}
 	error = add_class_attrs(class_get(cls));
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 1b57c72..03703eb 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -339,9 +339,7 @@ static struct kobj_type ext4_ktype = {
 	.sysfs_ops	= &ext4_attr_ops,
 };
 
-static struct kset ext4_kset = {
-	.kobj   = {.ktype = &ext4_ktype},
-};
+static struct kset ext4_kset;
 
 static struct kobj_type ext4_feat_ktype = {
 	.default_attrs	= ext4_feat_attrs,
@@ -423,11 +421,12 @@ int __init ext4_init_sysfs(void)
 {
 	int ret;
 
-	kobject_set_name(&ext4_kset.kobj, "ext4");
-	ext4_kset.kobj.parent = fs_kobj;
-	ret = kset_register(&ext4_kset);
-	if (ret)
+	kset_init(&ext4_kset, &ext4_ktype, NULL);
+	ret = kset_register(&ext4_kset, "ext4", fs_kobj);
+	if (ret) {
+		kset_unregister(&ext4_kset);
 		return ret;
+	}
 
 	ret = kobject_init_and_add(&ext4_feat, &ext4_feat_ktype,
 				   NULL, "features");
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index dfe162f..70c34ec 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -164,13 +164,12 @@ static struct kobj_type mlog_ktype = {
 	.sysfs_ops     = &mlog_attr_ops,
 };
 
-static struct kset mlog_kset = {
-	.kobj   = {.ktype = &mlog_ktype},
-};
+static struct kset mlog_kset;
 
 int mlog_sys_init(struct kset *o2cb_kset)
 {
 	int i = 0;
+	int ret;
 
 	while (mlog_attrs[i].attr.mode) {
 		mlog_attr_ptrs[i] = &mlog_attrs[i].attr;
@@ -178,9 +177,13 @@ int mlog_sys_init(struct kset *o2cb_kset)
 	}
 	mlog_attr_ptrs[i] = NULL;
 
-	kobject_set_name(&mlog_kset.kobj, "logmask");
+	kset_init(&mlog_kset, &mlog_ktype, NULL);
 	mlog_kset.kobj.kset = o2cb_kset;
-	return kset_register(&mlog_kset);
+	ret = kset_register(&mlog_kset, "logmask", NULL);
+	if (ret)
+		kset_unregister(&mlog_kset);
+
+	return ret;
 }
 
 void mlog_sys_shutdown(void)
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index e628459..d081817 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -172,8 +172,10 @@ struct kset {
 	const struct kset_uevent_ops *uevent_ops;
 };
 
-extern void kset_init(struct kset *kset);
-extern int __must_check kset_register(struct kset *kset);
+extern void kset_init(struct kset *kset, struct kobj_type *ktype,
+		const struct kset_uevent_ops *uevent_ops);
+extern int __must_check kset_register(struct kset *kset, const char *name,
+				struct kobject *parent_kobj);
 extern void kset_unregister(struct kset *kset);
 extern struct kset * __must_check kset_create_and_add(const char *name,
 						const struct kset_uevent_ops *u,
diff --git a/lib/kobject.c b/lib/kobject.c
index 7cbccd2..0327157 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -761,15 +761,35 @@ struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
 EXPORT_SYMBOL_GPL(kobject_create_and_add);
 
 /**
- * kset_init - initialize a kset for use
- * @k: kset
+ * kset_init - initialize a kset structure
+ * @kset: pointer to the kset to initialize
+ * @ktype: pointer to the ktype for this kset's contained kobject.
+ * @uevent_ops: an optional struct kset_uevent_ops for the kset.
+ *
+ * This function will properly initialize a kset such that it can then
+ * be passed to the kset_register() call.
+ *
+ * Note that there are only very few circumstances where you would
+ * initialize a kset by yourself, i.e. by calling kset_init()! The
+ * normal way to get a working kset object is through
+ * kset_create_and_add().
+ *
+ * Repeating the warning from kobject_init():
+ * after this function has been called, the kset MUST be cleaned up by
+ * a call to either kset_put() or, if it has been registered through
+ * kset_register(), to kset_unregister(). You shall not free it by a
+ * call to kfree() directly in order to ensure that all of the memory
+ * is cleaned up properly.
  */
-void kset_init(struct kset *k)
+void kset_init(struct kset *kset, struct kobj_type *ktype,
+	const struct kset_uevent_ops *uevent_ops)
 {
-	kobject_init_internal(&k->kobj);
-	INIT_LIST_HEAD(&k->list);
-	spin_lock_init(&k->list_lock);
+	kobject_init(&kset->kobj, ktype);
+	INIT_LIST_HEAD(&kset->list);
+	spin_lock_init(&kset->list_lock);
+	kset->uevent_ops = uevent_ops;
 }
+EXPORT_SYMBOL_GPL(kset_init);
 
 /* default kobject attribute operations */
 static ssize_t kobj_attr_show(struct kobject *kobj, struct attribute *attr,
@@ -803,17 +823,37 @@ const struct sysfs_ops kobj_sysfs_ops = {
 EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
 
 /**
- * kset_register - initialize and add a kset.
- * @k: kset.
+ * kset_register - add a struct kset to sysfs.
+ * @k: the kset to add
+ * @name: the name for the kset
+ * @parent_kobj: the parent kobject of this kset, if any.
+ *
+ * The kset @name is set and added to the kobject hierarchy in this
+ * function. This function is for ksets what kobject_add() is for kobjects.
+ *
+ * The rules to determine the parent kobject are the same as for
+ * kobject_add().
+ *
+ * If this function returns an error, either kset_put() (preferred) or
+ * kset_unregister() must be called to properly clean up the memory
+ * associated with the object. Under no instance should the kset
+ * that is passed to this function be directly freed with a call to
+ * kfree(), that will leak memory.
+ *
+ * Note, that an "add" uevent will be created with this call.
  */
-int kset_register(struct kset *k)
+int kset_register(struct kset *k, const char *name, struct kobject *parent_kobj)
 {
 	int err;
 
 	if (!k)
 		return -EINVAL;
 
-	kset_init(k);
+	err = kobject_set_name(&k->kobj, "%s", name);
+	if (err)
+		return err;
+
+	k->kobj.parent = parent_kobj;
 	err = kobject_add_internal(&k->kobj);
 	if (err)
 		return err;
@@ -823,7 +863,7 @@ int kset_register(struct kset *k)
 EXPORT_SYMBOL(kset_register);
 
 /**
- * kset_unregister - remove a kset.
+ * kset_unregister - unlink a kset from hierarchy and decrement its refcount.
  * @k: kset.
  */
 void kset_unregister(struct kset *k)
@@ -878,9 +918,7 @@ static struct kobj_type kset_ktype = {
 /**
  * kset_create - create a struct kset dynamically
  *
- * @name: the name for the kset
- * @uevent_ops: a struct kset_uevent_ops for the kset
- * @parent_kobj: the parent kobject of this kset, if any.
+ * @uevent_ops: an optional struct kset_uevent_ops for the kset
  *
  * This function creates a kset structure dynamically.  This structure can
  * then be registered with the system and show up in sysfs with a call to
@@ -890,32 +928,15 @@ static struct kobj_type kset_ktype = {
  *
  * If the kset was not able to be created, NULL will be returned.
  */
-static struct kset *kset_create(const char *name,
-				const struct kset_uevent_ops *uevent_ops,
-				struct kobject *parent_kobj)
+static struct kset *kset_create(const struct kset_uevent_ops *uevent_ops)
 {
 	struct kset *kset;
-	int retval;
 
 	kset = kzalloc(sizeof(*kset), GFP_KERNEL);
 	if (!kset)
 		return NULL;
-	retval = kobject_set_name(&kset->kobj, "%s", name);
-	if (retval) {
-		kfree(kset);
-		return NULL;
-	}
-	kset->uevent_ops = uevent_ops;
-	kset->kobj.parent = parent_kobj;
-
-	/*
-	 * The kobject of this kset will have a type of kset_ktype and belong to
-	 * no kset itself.  That way we can properly free it when it is
-	 * finished being used.
-	 */
-	kset->kobj.ktype = &kset_ktype;
-	kset->kobj.kset = NULL;
 
+	kset_init(kset, &kset_ktype, uevent_ops);
 	return kset;
 }
 
@@ -940,12 +961,13 @@ struct kset *kset_create_and_add(const char *name,
 	struct kset *kset;
 	int error;
 
-	kset = kset_create(name, uevent_ops, parent_kobj);
+	kset = kset_create(uevent_ops);
 	if (!kset)
 		return NULL;
-	error = kset_register(kset);
+
+	error = kset_register(kset, name, parent_kobj);
 	if (error) {
-		kfree(kset);
+		kset_put(kset);
 		return NULL;
 	}
 	return kset;
-- 
2.6.3
