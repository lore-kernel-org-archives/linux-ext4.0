From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Support "check=none" "nocheck" mount options
Date: Wed, 11 Jan 2012 14:07:26 -0700
Message-ID: <6791F004-7305-43C8-A144-834A8FCF9495@dilger.ca>
References: <20120110174118.GB3015@zod.bos.redhat.com> <4F0C78CD.6070809@redhat.com> <7A0721E1-689F-4B9B-BD8C-86A03DDF20CE@dilger.ca> <20120111145004.GA13986@zod.bos.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, kernel-team@fedoraproject.org
To: Josh Boyer <jwboyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:51583 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2AKVH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jan 2012 16:07:27 -0500
In-Reply-To: <20120111145004.GA13986@zod.bos.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-11, at 7:50 AM, Josh Boyer wrote:
> On Wed, Jan 11, 2012 at 03:07:33AM -0700, Andreas Dilger wrote:
>> At a minimum the use of obsolete options like this should print a warning
>> at mount time so that there is some chance the user will notice and remove
>> the old option from their config.  Otherwise it is impossible to even get
>> rid of old useless cruft like this if we need to maintain functionally-useless
>> compatibility forever.
> 
> I can add a printk(KERN_WARN in the case statement instead of just
> having it break.  That's not a big deal, but I doubt it's going to get
> seen much.

It not being seen much/ever is fine (expected even), but at least anyone
using this option has some advance warning that it will disappear.

As stated separately, a printk() should also be added to ext2/ext3 so
that it is deprecated there as well.

> I'm very hesitant to add a WARN_ON or anything else that is
> going to generate a backtrace because it's just going to be scary
> looking and cause more work for distributions that have automated bug
> reporting tools.

Right, WARN_ON() is too strong, and having a stack trace isn't useful.

>> Dredging through my memories, I recall that this option used to disable
>> the checks done at mount(?) time that compared the bits set in the block
>> and inode bitmaps against the summary values in the group descriptors
>> (AFAIR).  Or maybe it was comparing the group descriptor summary values
>> against the superblock values?
> 
> Yeah, something like that.  It's been the default behavior of ext2/ext3
> for a long time now.  So long that the "check=normal" and "check=strict"
> options (non-default) aren't even supported there anymore.

Not surprising.

>> In any case, I can't imagine why a user would have this set for a kernel
>> option that might have last been valid 10 years ago, and why the 5 users
>> in the world that might have this set cannot simply remove it from their
>> fstab, since it does absolutely nothing?
> 
> This was prompted by a bug report against util-linux, as the man page
> still had the option as valid for ext2 (which it is).

Is there a patch being submitted to util-linux that removes this option
from the man page as well?

>  Since ext4 is
> claiming to be directly usable for ext2 filesystems, I don't think it is
> unreasonable to mount an fs that has that option set.  If it makes
> things easier I could wrap all of this in CONFIG_EXT4_USE_FOR_EXT23
> ifdefs, but that seemed to make the code unnecessarily uglier.

No, I don't think a CONFIG option is needed.  What I'd actually prefer is
to add a LINUX_VERSION_CODE check for some time in the future (say 3 years
with 4 kernel versions per year) that adds a #warning to remove this code:

#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 15, 50) /* approx 2014 */
	case Opt_nocheck:
		/* ext2/ext3 used to "support" this option. */
		ext4_msg(sb, KERN_INFO, "the '%s' option is deprecated, "
			 "please remove it from /etc/fstab\n", p);
		break;
#else
#warning "remove obsolete 'nocheck' and 'check=none' mount options"
#endif

This at least ensures that the obsolete code is noticed (which is what we
do for Lustre), but it puts the burden of removing the obsolete code onto
the person who updates the version (which is Linus, and I don't think he
would be happy about it).  IMHO existing Linux "deprecated" mechanism does
not work very well, because there is still tons of deprecated code that is
never removed because it isn't "in your face" enough (i.e. stuff that is
marked to be deprecated in 2007 or 2008.

Another option would be to just have the version check without the #warning
and then at least the code will be automatically disabled at that time, and
can be deleted by one of the ext4 maintainers at any convenient later time.

Cheers, Andreas





