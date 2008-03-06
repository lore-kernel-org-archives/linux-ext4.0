From: Matthias Koenig <mkoenig@suse.de>
Subject: Re: [PATCH] [RFC] New fsck option to ignore device-mapper crypto devices
Date: Thu, 06 Mar 2008 18:04:36 +0100
Message-ID: <n7xzltbwzq3.fsf@sor.suse.de>
References: <n7xejaoynp9.fsf@sor.suse.de>
	<1204813967.8679.28.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, ludwig.nussel@suse.de,
	linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763518AbYCFREo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2008 12:04:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:

> On Thu, 2008-03-06 at 14:41 +0100, Matthias Koenig wrote:
>> Hi,
>> 
>> Current practice in defining crypto devices in common distributions
>> has:
>> 1. A definition of the device-mapper name with the corresponding device
>>    in /etc/crypttab
>> 2. A definition in /etc/fstab for the mountpoint of the dm device.
>> 
>> Steps involved into setting up the crypto devices are
>> a. fsck local filesystems
>> b. mount local filesystems
>> c. device-mapper set up of crypto devices
>> d. fsck crypto filesystems
>
> How is fsck invoked here?  Does it use the -A flag?

fsck is invoked with -A option only in step a.
Later on in step d. fsck is just called for the crypto filesystems in 
question.

>> e. mount crypto filesystems
>> 
>> Steps a.+b. have to be done before the crypto device setup, because
>> the crypto device could be in a file container on a local filesystem.
>> 
>> Now, the problem appears if /etc/fstab contains a mount point of a
>> crypto device which is supposed to be fsck'd in step d.  fsck will
>> fail in step a., since this device does not exist at this point in
>> the boot process (it will be set up in step c.)
>
> Should field 8 of /etc/fstab (fs_passno) be zero for these mount points?
> Is there any reason for it to be anything different?

Why? zero would mean that they should never get checked.
I think it is reasonable to have the choice to get your crypto
filesystems checked. Current practise for SuSE has been to allow
only 0, but checked this filesystem anyway, which has lead to complaints.
So we want to do this more consistent. 

> Alternately, would it make sense to define a special value for this
> field that tells fsck to silently ignore it if the device does not
> exist?

Yes, this would be an alternative. The mount option nofail which has
recently been added in util-linux-ng would be suitable for this. 
However, we prefer a solution to have fsck automatically do the right
thing.

>> In order to address this, I propose a new option for fsck, lets say '-X'.
>> Enabling this will skip a device-mapper device which is currently
>> nonexistent, but is defined in /etc/crypttab.
>
> Could it be simplified to simply skip non-existent devices?  Should it
> really be crypttab-specific?

Well, I would not disagree.
Currently fsck does not check and calls the default filesystem specific
checker fsck.ext2 if a device does not exist, which then fails with
exit code 8.
An option to simply skip non-existent devices is Ok for me.
I just haven't had the heart to change this to skip any device, since the
problem only relates to the crypto devices and I haven't been sure
if the current behaviour is intentional.

Matthias
