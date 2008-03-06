From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] [RFC] New fsck option to ignore device-mapper crypto
	devices
Date: Thu, 06 Mar 2008 08:32:47 -0600
Message-ID: <1204813967.8679.28.camel@norville.austin.ibm.com>
References: <n7xejaoynp9.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, ludwig.nussel@suse.de,
	linux-ext4@vger.kernel.org
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41860 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbYCFOcx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2008 09:32:53 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m26EWobh015848
	for <linux-ext4@vger.kernel.org>; Thu, 6 Mar 2008 09:32:50 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m26EWnrh228698
	for <linux-ext4@vger.kernel.org>; Thu, 6 Mar 2008 09:32:49 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m26EWmjZ032712
	for <linux-ext4@vger.kernel.org>; Thu, 6 Mar 2008 09:32:48 -0500
In-Reply-To: <n7xejaoynp9.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-03-06 at 14:41 +0100, Matthias Koenig wrote:
> Hi,
> 
> Current practice in defining crypto devices in common distributions
> has:
> 1. A definition of the device-mapper name with the corresponding device
>    in /etc/crypttab
> 2. A definition in /etc/fstab for the mountpoint of the dm device.
> 
> Steps involved into setting up the crypto devices are
> a. fsck local filesystems
> b. mount local filesystems
> c. device-mapper set up of crypto devices
> d. fsck crypto filesystems

How is fsck invoked here?  Does it use the -A flag?

> e. mount crypto filesystems
> 
> Steps a.+b. have to be done before the crypto device setup, because
> the crypto device could be in a file container on a local filesystem.
> 
> Now, the problem appears if /etc/fstab contains a mount point of a
> crypto device which is supposed to be fsck'd in step d.  fsck will
> fail in step a., since this device does not exist at this point in
> the boot process (it will be set up in step c.)

Should field 8 of /etc/fstab (fs_passno) be zero for these mount points?
Is there any reason for it to be anything different?

Alternately, would it make sense to define a special value for this
field that tells fsck to silently ignore it if the device does not
exist?

> In order to address this, I propose a new option for fsck, lets say '-X'.
> Enabling this will skip a device-mapper device which is currently
> nonexistent, but is defined in /etc/crypttab.

Could it be simplified to simply skip non-existent devices?  Should it
really be crypttab-specific?

> In this way crypto devices could be skipped without fsck failure when
> running fsck -A.
> Proposed patch to implement this below.
> 
> Regards,
> Matthias
-- 
David Kleikamp
IBM Linux Technology Center

