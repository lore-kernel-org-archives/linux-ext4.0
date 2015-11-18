From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v2] kset- and class-registration cleanups
Date: Wed, 18 Nov 2015 17:43:28 +0100
Message-ID: <87k2pfcl73.fsf_-_@gmail.com>
References: <871tbpebjw.fsf@gmail.com> <20151117041213.GA10860@kroah.com>
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
In-Reply-To: <20151117041213.GA10860@kroah.com> (Greg Kroah-Hartman's message
	of "Mon, 16 Nov 2015 20:12:13 -0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In order to have something to base further discussion on, here comes the
second version.

In addition to some changes to the inital patch (now [1/3]), two
additional ones have been introduced.

The three patches depend on one another in sequence.

For a detailed changelist, see the end of this mail.

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> On Tue, Nov 17, 2015 at 01:04:19AM +0100, Nicolai Stange wrote:
> Yes, but those calls all succeed, so this isn't a problem in the "real"
> world :)

I added a word about non-impact in the commit message of [1/3].

>> +static void glue_dirs_release_dummy(struct kobject *kobj)
>> +{
>> +	/*
>> +	 * The glue_dirs kset member of struct subsys_private is never
>> +	 * registered and thus, never unregistered.
>> +	 * This release function is a dummy to make kset_init() happy.
>> +	 */
>> +	pr_err(
>> +	"class (%p): unexpected kset_put() on glue_dirs, something is broken.",
>> +		container_of(kobj, struct subsys_private,
>> +				glue_dirs.kobj)->class);
>> +	dump_stack();
>
> How can this ever happen?

Not at all. I'm not sure I understand you correctly here.
Do you strictly want to abandon the dummy releaser, or more specifically,
the dummy kobj_type?
For the moment, I turned the pr_err()/dump_stack() into a WARN() for the
sake of better style.

>>  	if (error) {
>> -		kfree(cp);
>> +		/*
>> +		 * class->release() would be called by cp->subsys'
>> +		 * release function. Prevent this from happening in
>> +		 * the error case by zeroing cp->class out.
>> +		 */
>> +		cp->class = NULL;
>> +		cls->p = NULL;
>> +		kset_put(&cp->subsys);
>
> That seems pretty messy, why can't we allow the release to be called?  I
> don't think this is really correct :(

At the moment, it is necessary. I've added [3/3] for the case that you
want cls->class_release() to get called from __class_register() on error.
In [3/3] you will also find the (few) callers expecting the behaviour as
it currently is.


Detailed changes from initial version to v2:
[1/3] lib/kobject: fix memory leak in error path of kset_create_and_add()
This one is the original patch with a few changes:
- added a word of non-impact to commit message
- use WARN() instead of open coded pr_error()/dump_stack() pair in
  struct class' glue_dirs' dummy class releaser.
- follow my own advice in the docstring of kset_register() and
  use kset_put() instead of kset_unregister() on error of
  kset_register() in ext4's ext4_init_sysfs() and ocfs2's mlog_sys_init().

[2/3] drivers/base/class: __class_register(): make error behaviour consistent
This one is new and quite unrelated to the original patch.
Following the sidenote made in my last mail, it makes __class_register()
properly clean up after itself on error.

[3/3] drivers/base/class: __class_register(): invoke class' releaser on failure
This one is new.
It addresses Greg K-H's comment on the initial version about the messiness
of avoiding to call class->class_release() from __class_register() on
error. Given the fact that I had to introduce an explicit
cls->class_release() in the early part when there is no kset object
available yet, I'm by no means sure that it is much less messy now and
that this patch is worth the trouble.
-> It is up to you to judge.
As there are enough people bothered already, I did not CC the people
suggested for this one by get_maintainer.pl: all of them are maintainers
of external subsystems and probably not particularly interested in
__class_register() and friends. I will do this as soon as
a decision for this patch has been made, perhaps in a separate thread.
