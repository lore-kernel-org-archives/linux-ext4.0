From: Daniel Johnson <dan.u.johns@gmail.com>
Subject: Using latest e2fsprogs on various offline VM ext filesystems
Date: Sat, 18 Apr 2015 13:46:20 +0100
Message-ID: <CANpYoaWEYTQBE_Lb7dKGa2P=AT8F77=0E-6HWEDAeRaWUTzueg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36809 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbDRMqV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Apr 2015 08:46:21 -0400
Received: by obbeb7 with SMTP id eb7so88983574obb.3
        for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2015 05:46:20 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Apologies if this "user" question has been asked before.

Tomorrow I will be stopping a couple of dozen kvm virtual machines
running various Linux distros and running a forced e2fsck on all of
their ext filesystems. The distros are a mix of various flavours of
Ubuntu, Debian and Centos, so will include some fs created with older
kernels and E2fsprogs.

The host is 64-bit Centos 6 running vanilla kernel 3.14.39. I figured
I'll build the latest E2fsprogs 1.42.12 for this rather than using the
Centos 6 e2fsprogs-1.41.12-21.el6.x86_64.

My question is; should it be safe in theory to use the latest
E2fsprogs on a mix of ext filesystems in this way? I would have
thought so but don't want to rely on any assumptions :-)

I'll be setting up device maps on the host server to get to the
filesystems on each VMs virtual disk, and doing read only checks. But
if anything needs a repair then I could potentially have a fs modified
on newer kernel & userspace that then has to boot inside a VM with a
distro with much older kernel and userspace such as Centos 5, which is
what I'm concerned about.

Thanks,
Dan
