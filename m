From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Using latest e2fsprogs on various offline VM ext filesystems
Date: Sat, 18 Apr 2015 09:12:16 -0600
Message-ID: <A8589FB6-80B3-418C-9540-F9AA75FFCF72@dilger.ca>
References: <CANpYoaWEYTQBE_Lb7dKGa2P=AT8F77=0E-6HWEDAeRaWUTzueg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Daniel Johnson <dan.u.johns@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35366 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbbDRPMS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Apr 2015 11:12:18 -0400
Received: by pabtp1 with SMTP id tp1so157157081pab.2
        for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2015 08:12:18 -0700 (PDT)
In-Reply-To: <CANpYoaWEYTQBE_Lb7dKGa2P=AT8F77=0E-6HWEDAeRaWUTzueg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

You can safely use newer e2fsprogs on older file systems. This should not
affect compatibility with older kernels in any way, unless you explicitly
enable features.

Note that if you are using LVM/DM you could create a snapshot of the
running device and run e2fsck on that. If no errors are found then you
don't need to stop the VM at all. You can reset the last checked counter
and mount count via tune2fs. Only if you find an error in the snapshot do
you need to unmount the filesystem to fix it.

Cheers, Andreas

> On Apr 18, 2015, at 06:46, Daniel Johnson <dan.u.johns@gmail.com> wrote:
> 
> Apologies if this "user" question has been asked before.
> 
> Tomorrow I will be stopping a couple of dozen kvm virtual machines
> running various Linux distros and running a forced e2fsck on all of
> their ext filesystems. The distros are a mix of various flavours of
> Ubuntu, Debian and Centos, so will include some fs created with older
> kernels and E2fsprogs.
> 
> The host is 64-bit Centos 6 running vanilla kernel 3.14.39. I figured
> I'll build the latest E2fsprogs 1.42.12 for this rather than using the
> Centos 6 e2fsprogs-1.41.12-21.el6.x86_64.
> 
> My question is; should it be safe in theory to use the latest
> E2fsprogs on a mix of ext filesystems in this way? I would have
> thought so but don't want to rely on any assumptions :-)
> 
> I'll be setting up device maps on the host server to get to the
> filesystems on each VMs virtual disk, and doing read only checks. But
> if anything needs a repair then I could potentially have a fs modified
> on newer kernel & userspace that then has to boot inside a VM with a
> distro with much older kernel and userspace such as Centos 5, which is
> what I'm concerned about.
> 
> Thanks,
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
