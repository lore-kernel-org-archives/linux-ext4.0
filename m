From: Nicolai Stange <nicstange@gmail.com>
Subject: Re: [PATCH] lib/kobject: fix memory leak in error path of kset_create_and_add()
Date: Tue, 17 Nov 2015 12:29:40 +0100
Message-ID: <87r3jodftn.fsf@gmail.com>
References: <871tbpebjw.fsf@gmail.com> <20151117041213.GA10860@kroah.com>
	<87wpthcaj0.fsf@gmail.com>
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
In-Reply-To: <87wpthcaj0.fsf@gmail.com> (Nicolai Stange's message of "Tue, 17
	Nov 2015 09:09:23 +0100")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Nicolai Stange <nicstange@gmail.com> writes:

> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>
>> On Tue, Nov 17, 2015 at 01:04:19AM +0100, Nicolai Stange wrote:
>>> +}
>>> +
>>> +static struct kobj_type glue_dirs_ktype = {
>>> +	.release = glue_dirs_release_dummy,
>>> +};
>>> +
>>>  /* Hotplug events for classes go to the class subsys */
>>>  static struct kset *class_kset;
>>>  
>>> @@ -175,18 +194,14 @@ int __class_register(struct class *cls, struct lock_class_key *key)
>>>  		return -ENOMEM;
>>>  	klist_init(&cp->klist_devices, klist_class_dev_get, klist_class_dev_put);
>>>  	INIT_LIST_HEAD(&cp->interfaces);
>>> -	kset_init(&cp->glue_dirs);
>>> +	kset_init(&cp->glue_dirs, &glue_dirs_ktype, NULL);
>>>  	__mutex_init(&cp->mutex, "subsys mutex", key);
>>> -	error = kobject_set_name(&cp->subsys.kobj, "%s", cls->name);
>>> -	if (error) {
>>> -		kfree(cp);
>>> -		return error;
>>> -	}
>>>  
>>>  	/* set the default /sys/dev directory for devices of this class */
>>>  	if (!cls->dev_kobj)
>>>  		cls->dev_kobj = sysfs_dev_char_kobj;
>>>  
>>> +	kset_init(&cp->subsys, &class_ktype, NULL);
>>>  #if defined(CONFIG_BLOCK)
>>>  	/* let the block class directory show up in the root of sysfs */
>>>  	if (!sysfs_deprecated || cls != &block_class)
>>> @@ -194,13 +209,19 @@ int __class_register(struct class *cls, struct lock_class_key *key)
>>>  #else
>>>  	cp->subsys.kobj.kset = class_kset;
>>>  #endif
>>> -	cp->subsys.kobj.ktype = &class_ktype;
>>>  	cp->class = cls;
>>>  	cls->p = cp;
>>>  
>>> -	error = kset_register(&cp->subsys);
>>> +	error = kset_register(&cp->subsys, cls->name, NULL);
>>>  	if (error) {
>>> -		kfree(cp);
>>> +		/*
>>> +		 * class->release() would be called by cp->subsys'
>>> +		 * release function. Prevent this from happening in
>>> +		 * the error case by zeroing cp->class out.
>>> +		 */
>>> +		cp->class = NULL;
>>> +		cls->p = NULL;
>>> +		kset_put(&cp->subsys);
>>
>> That seems pretty messy, why can't we allow the release to be called?  I
>> don't think this is really correct :(
>
> I don't know whether it is actually correct, but before the introduction
> of this patch, the class->release() would not have been called on error
> either. I did not want to change that behaviour and thus, I have put
> this "messy" and admittedly ugly clear-the-class-pointer code into the
> error handling above.
>
> I will check whether calling class->release() on error would be a
> problem for the callers of class_register() (there are 64 of them). If
> it turns out not to be one, I could simply remove the above class
> pointer purging.

The very first candidate I've looked at, __class_create() from
drivers/base/class.c, relies on class_register() not to call
class->release() on error: upon a non-zero return from
__class_register() it explicitly kfree()s the struct class
instance. Together with the kfree() in class_create_release(), this
would result in a double free. Thus, as it stands,
class_create_release() must not get called upon encountering an error in
__class_register() and the messy clearance of cp->class before the call
to kset_put() is necessary.


The current semantics of __class_register() seem to be:
- if the call succeeds, the registered class' release function will
  eventually get called by the kobject system.
- if it doesn't succeed, the registered class' release function won't
  ever be called: clean up after yourself.

One could change this behaviour and indeed it might make sense. But in
my opinion, this should be done in a different patch. After all, there
are ~64 call sites involved which would have to get changed accordingly.


As a sidenote, note that __class_register()'s error behaviour is a
little bit inconsistent: if the final add_class_attrs() call fails, the
cp->subsys won't get deregistered by __class_register() itsef. Upon
encountering a non-zero return value from __class_register(), a caller
would not be able to decide whether kset_register() or add_class_attrs()
failed and thus, it can't tell whether a class_unregister() is
necessary/allowed or not. I think the place to fix this should be a
separate patch, too. It would be a straight forward one though:
add_class_attrs() has got all-or-nothing semantics already and thus,
furnishing __class_register() with similiar behaviour is easy.
