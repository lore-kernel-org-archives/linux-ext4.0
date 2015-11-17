From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] lib/kobject: fix memory leak in error path of
 kset_create_and_add()
Date: Mon, 16 Nov 2015 20:12:13 -0800
Message-ID: <20151117041213.GA10860@kroah.com>
References: <871tbpebjw.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Nicolai Stange <nicstange@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871tbpebjw.fsf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 17, 2015 at 01:04:19AM +0100, Nicolai Stange wrote:
> In kset_create_and_add(), the name duped into the kset's kobject by
> kset_create() gets leaked if the call to kset_register() fails.
> 
> Indeed, triggering failure by invoking kset_create_and_add() with a
> duplicate name makes kmemleak reporting
> 
>   unreferenced object 0xffff8800b4a1f428 (size 16):
>     comm "insmod", pid 682, jiffies 4294745489 (age 50.477s)
>     hex dump (first 16 bytes):
>       64 75 70 6c 69 63 61 74 65 00 6b 6b 6b 6b 6b a5  duplicate.kkkkk.
>     backtrace:
>       [<ffffffff814380ee>] kmemleak_alloc+0x4e/0xb0
>       [<ffffffff811aab01>] __kmalloc_track_caller+0x2b1/0x390
>       [<ffffffff811797f1>] kstrdup+0x31/0x60
>       [<ffffffff81179843>] kstrdup_const+0x23/0x30
>       [<ffffffff81290254>] kvasprintf_const+0x54/0x90
>       [<ffffffff81284d21>] kobject_set_name_vargs+0x21/0xa0
>       [<ffffffff81284dee>] kobject_set_name+0x4e/0x70
>       [<ffffffff812854f5>] kset_create_and_add+0x45/0xa0
>       [...]
> 
> Similar problems exist at all call sites of kset_register(), that is
> in drivers/base, fs/ext4 and in fs/ocfs2.

Yes, but those calls all succeed, so this isn't a problem in the "real"
world :)

> The deeper cause behind this are the current semantics of the kset
> initialization, creation and registration functions which differ from the
> ones of their corresponding kobject counterparts.
> Namely,
> - there is no _exported_ kset initialization function,
> - the (not exported) kset_create() creates a halfway initialized kset
>   object,
> - and the kset_register() finishes a kset object's initialization but
>   expects its name to already have been set at its entry.
> 
> To fix this:
> - Export kset_init() and let it mimic the semantics of kobject_init().
>   Especially it takes and sets a kobj_type which makes the kset object
>   kset_put()able upon return.
> - Let the internal kset_create() do the complete initialization by means
>   of kset_init().
> - Remove any kset initialization from kset_register(): it expects a
>   readily initialized kset object now. Furthermore, let kset_register()
>   take and set the kset object's name. This resembles the behaviour of
>   kobject_add(). In analogy to the latter, require the caller to call
>   kset_put() or kset_unregister() unconditionally, even on failure.
> 
> At the call sites of kset_register():
> - Replace the open coded kset object initialization by a call to
>   kset_init().
> - Remove the explicit name setting and let the kset_register() call do
>   that work.
> - Replace any kfree()s by kset_put()s where appropriate.
> 
> Signed-off-by: Nicolai Stange <nicstange@gmail.com>
> ---
> To the maintainers of ext4 and ocfs2: although several subsystems are
> touched, the changes come in one single patch in order to keep them bisectable.
> 
> 
>  drivers/base/bus.c         | 14 ++-----
>  drivers/base/class.c       | 39 ++++++++++++++-----
>  fs/ext4/sysfs.c            | 13 +++----
>  fs/ocfs2/cluster/masklog.c | 13 ++++---
>  include/linux/kobject.h    |  6 ++-
>  lib/kobject.c              | 94 ++++++++++++++++++++++++++++------------------
>  6 files changed, 110 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 5005924..a81227c 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -900,15 +900,11 @@ int bus_register(struct bus_type *bus)
>  
>  	BLOCKING_INIT_NOTIFIER_HEAD(&priv->bus_notifier);
>  
> -	retval = kobject_set_name(&priv->subsys.kobj, "%s", bus->name);
> -	if (retval)
> -		goto out;
> -
> -	priv->subsys.kobj.kset = bus_kset;
> -	priv->subsys.kobj.ktype = &bus_ktype;
>  	priv->drivers_autoprobe = 1;
>  
> -	retval = kset_register(&priv->subsys);
> +	kset_init(&priv->subsys, &bus_ktype, NULL);
> +	priv->subsys.kobj.kset = bus_kset;
> +	retval = kset_register(&priv->subsys, bus->name, NULL);
>  	if (retval)
>  		goto out;
>  
> @@ -955,10 +951,8 @@ bus_drivers_fail:
>  bus_devices_fail:
>  	bus_remove_file(bus, &bus_attr_uevent);
>  bus_uevent_fail:
> -	kset_unregister(&bus->p->subsys);
>  out:
> -	kfree(bus->p);
> -	bus->p = NULL;
> +	kset_unregister(&bus->p->subsys);
>  	return retval;
>  }
>  EXPORT_SYMBOL_GPL(bus_register);
> diff --git a/drivers/base/class.c b/drivers/base/class.c
> index 71059e3..94a5b040 100644
> --- a/drivers/base/class.c
> +++ b/drivers/base/class.c
> @@ -19,6 +19,7 @@
>  #include <linux/slab.h>
>  #include <linux/genhd.h>
>  #include <linux/mutex.h>
> +#include <linux/printk.h>
>  #include "base.h"
>  
>  #define to_class_attr(_attr) container_of(_attr, struct class_attribute, attr)
> @@ -82,6 +83,24 @@ static struct kobj_type class_ktype = {
>  	.child_ns_type	= class_child_ns_type,
>  };
>  
> +static void glue_dirs_release_dummy(struct kobject *kobj)
> +{
> +	/*
> +	 * The glue_dirs kset member of struct subsys_private is never
> +	 * registered and thus, never unregistered.
> +	 * This release function is a dummy to make kset_init() happy.
> +	 */
> +	pr_err(
> +	"class (%p): unexpected kset_put() on glue_dirs, something is broken.",
> +		container_of(kobj, struct subsys_private,
> +				glue_dirs.kobj)->class);
> +	dump_stack();

How can this ever happen?

> +}
> +
> +static struct kobj_type glue_dirs_ktype = {
> +	.release = glue_dirs_release_dummy,
> +};
> +
>  /* Hotplug events for classes go to the class subsys */
>  static struct kset *class_kset;
>  
> @@ -175,18 +194,14 @@ int __class_register(struct class *cls, struct lock_class_key *key)
>  		return -ENOMEM;
>  	klist_init(&cp->klist_devices, klist_class_dev_get, klist_class_dev_put);
>  	INIT_LIST_HEAD(&cp->interfaces);
> -	kset_init(&cp->glue_dirs);
> +	kset_init(&cp->glue_dirs, &glue_dirs_ktype, NULL);
>  	__mutex_init(&cp->mutex, "subsys mutex", key);
> -	error = kobject_set_name(&cp->subsys.kobj, "%s", cls->name);
> -	if (error) {
> -		kfree(cp);
> -		return error;
> -	}
>  
>  	/* set the default /sys/dev directory for devices of this class */
>  	if (!cls->dev_kobj)
>  		cls->dev_kobj = sysfs_dev_char_kobj;
>  
> +	kset_init(&cp->subsys, &class_ktype, NULL);
>  #if defined(CONFIG_BLOCK)
>  	/* let the block class directory show up in the root of sysfs */
>  	if (!sysfs_deprecated || cls != &block_class)
> @@ -194,13 +209,19 @@ int __class_register(struct class *cls, struct lock_class_key *key)
>  #else
>  	cp->subsys.kobj.kset = class_kset;
>  #endif
> -	cp->subsys.kobj.ktype = &class_ktype;
>  	cp->class = cls;
>  	cls->p = cp;
>  
> -	error = kset_register(&cp->subsys);
> +	error = kset_register(&cp->subsys, cls->name, NULL);
>  	if (error) {
> -		kfree(cp);
> +		/*
> +		 * class->release() would be called by cp->subsys'
> +		 * release function. Prevent this from happening in
> +		 * the error case by zeroing cp->class out.
> +		 */
> +		cp->class = NULL;
> +		cls->p = NULL;
> +		kset_put(&cp->subsys);

That seems pretty messy, why can't we allow the release to be called?  I
don't think this is really correct :(

But overall I like the patch, nice job.  Any way to fix this last bit
up?

thanks,

greg k-h
