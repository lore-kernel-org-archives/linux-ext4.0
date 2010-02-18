From: Andreas Dilger <adilger@sun.com>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has been
 remounted readonly
Date: Thu, 18 Feb 2010 14:41:45 -0700
Message-ID: <9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-fsdevel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>
To: PiX <pix@devlife.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64908 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab0BRVmC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Feb 2010 16:42:02 -0500
In-reply-to: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-18, at 09:45, PiX wrote:
> I'm experiencing a strange behavior. After having remounted / to
> readonly, I'm doing a sha1sum on /dev/sda1 (which is mounted on /)
> Then, I reboot, GRUB starts the kernel with the ro option, when I do a
> hash of /dev/sda1 the sum has changed.

Are you sure this isn't because e2fsck has been run at boot time and  
changed e.g. the "last checked" timestamp in the superblock?

> This only happen when the rootfs hash been mounted ro, then remounted
> rw to make some changes and remounted ro.
> On the next reboot the hash will change, but only one time. Next
> reboots will not alter the control sum, until of course I remount it
> RW.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

