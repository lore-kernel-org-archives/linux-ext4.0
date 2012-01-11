From: Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] ext4: Support "check=none" "nocheck" mount options
Date: Wed, 11 Jan 2012 09:50:07 -0500
Message-ID: <20120111145004.GA13986@zod.bos.redhat.com>
References: <20120110174118.GB3015@zod.bos.redhat.com>
 <4F0C78CD.6070809@redhat.com>
 <7A0721E1-689F-4B9B-BD8C-86A03DDF20CE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, kernel-team@fedoraproject.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950Ab2AKOuN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jan 2012 09:50:13 -0500
Content-Disposition: inline
In-Reply-To: <7A0721E1-689F-4B9B-BD8C-86A03DDF20CE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 11, 2012 at 03:07:33AM -0700, Andreas Dilger wrote:
> On 2012-01-10, at 10:43 AM, Eric Sandeen wrote:
> > On 1/10/12 11:41 AM, Josh Boyer wrote:
> >> The ext2/ext3 filesystems supported "check=none" and "nocheck" as mount options
> >> even though that was already the default behavior and it essentially did
> >> nothing.  When using ext4 to mount ext2/ext3 filesystems, that mount option
> >> causes the mount to fail.  That isn't as backward compatible as it could be,
> >> so add support to ext4 to accept the option.
> > 
> > The only thing ext2 does with those options today is to clear the flag,
> > and I can't find anything in userspace or kernelspace which would have set
> > it in any case.  It seem dead, but we do need the compatibility in ext4
> > if it's to handle ext2&3 seamlessly, I guess.
> 
> At a minimum the use of obsolete options like this should print a warning
> at mount time so that there is some chance the user will notice and remove
> the old option from their config.  Otherwise it is impossible to even get
> rid of old useless cruft like this if we need to maintain functionally-useless
> compatibility forever.

I can add a printk(KERN_WARN in the case statement instead of just
having it break.  That's not a big deal, but I doubt it's going to get
seen much.  I'm very hesitant to add a WARN_ON or anything else that is
going to generate a backtrace because it's just going to be scary
looking and cause more work for distributions that have automated bug
reporting tools.

> Dredging through my memories, I recall that this option used to disable
> the checks done at mount(?) time that compared the bits set in the block
> and inode bitmaps against the summary values in the group descriptors
> (AFAIR).  Or maybe it was comparing the group descriptor summary values
> against the superblock values?

Yeah, something like that.  It's been the default behavior of ext2/ext3
for a long time now.  So long that the "check=normal" and "check=strict"
options (non-default) aren't even supported there anymore.

> In any case, I can't imagine why a user would have this set for a kernel
> option that might have last been valid 10 years ago, and why the 5 users
> in the world that might have this set cannot simply remove it from their
> fstab, since it does absolutely nothing?

This was prompted by a bug report against util-linux, as the man page
still had the option as valid for ext2 (which it is).  Since ext4 is
claiming to be directly usable for ext2 filesystems, I don't think it is
unreasonable to mount an fs that has that option set.  If it makes
things easier I could wrap all of this in CONFIG_EXT4_USE_FOR_EXT23
ifdefs, but that seemed to make the code unnecessarily uglier.

josh
