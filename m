From: Matthias Koenig <mkoenig@suse.de>
Subject: Re: [PATCH] [RFC] New fsck option to ignore device-mapper crypto devices
Date: Wed, 12 Mar 2008 16:59:03 +0100
Message-ID: <n7xr6egkk6w.fsf@sor.suse.de>
References: <n7xejaoynp9.fsf@sor.suse.de>
	<1204813967.8679.28.camel@norville.austin.ibm.com>
	<n7xzltbwzq3.fsf@sor.suse.de>
	<1204824227.7964.4.camel@norville.austin.ibm.com>
	<n7xiqzywr7u.fsf@sor.suse.de>
	<1204903187.7975.10.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, ludwig.nussel@suse.de,
	linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbYCLP7I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2008 11:59:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:

> I don't understand the question.  If the fs_passno field is zero, fsck
> isn't even going to try to check the filesystem, so having no device is
> no problem.

Agreed, in case of zero there is no problem.

>> How should we specify that we want these filesystems to be checked or not 
>> at a later time in the boot process after the crypto devices have been
>> set up?
>
> This is why I asked if fsck was being run with the -A flag in step d.
> If it's not, then I'm not clear on why fs_passno has anything to do with
> it.  Is there some script that looks at this field in /etc/fstab for
> step d?

Right, fsck -A is *not* called in step d and the fs_passno is in
principle unrelated to this.
There is a boot script for setting up, fscking and mounting the 
crypto devices. As the crypto fileystems are supposed to be defined in
/etc/fstab looking at fs_passno by the script to find out if the
filesystem should be checked or not seems reasonable to me.

> If that's the case, then I suggest a more general solution.  Either some
> special value for fs_passno that defers the fsck for a later pass, or a
> simplified version of your proposed patch without the crypto-specific
> part.

1. Do we agree that fstab fs_passno could be used besides fsck -A by a 
   separate script to decide if a filesystem (that could not be checked 
   in the fsck -A phase) should be checked?

2. If yes, what would be a proper way?

   a) special value for fs_passno?
      I don't know if this is reasonable, we already have a "nofail"
      mount option. We can already call fsck with something like
      (assuming crypto devices being tagged with the nofail option)
      fsck -A -t noopts=nofail 
      So giving either a special fs_passno value or an additional option 
      seems to be the same: one has to put an additional value into fstab.

   b) a general "ignore if device does not exist" option?
      Still I am not sure if we really *generally* want to ignore
      devices which are not available at fsck -A phase. The behaviour
      of fsck to fail in this case is probably on purpose?

Note, the whole discussion applies to crypto filesystems living in a
container file. Encrypted block devices can be set up earlier so they
could be checked in the normal fsck -A stage (Suse currently does not
do this, but I am planning to change this).
So, since the issue will remain only for file containers, it might be not
worth adding a new option for fsck. But it would be nice have the
fsck behaviour on non-existent device failure clarified.

Thanks,
Matthias
