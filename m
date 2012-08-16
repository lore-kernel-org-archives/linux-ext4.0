From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Thu, 16 Aug 2012 15:44:32 -0700
Message-ID: <CANP3RGfwQCJu7TLF4KXAJ-qPrHQDbuPzRCd72O41CUi2G1azJg@mail.gmail.com>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
	<20120816024654.GB3781@thunk.org>
	<20120816111051.GA16036@localhost>
	<20120816152513.GA31346@thunk.org>
	<CANP3RGdMfM0tZbaJS9dFetRhXoGtyS0Nx4hZER_Qv0a061X_dQ@mail.gmail.com>
	<20120816211948.GF31346@thunk.org>
	<CANP3RGd62=voh5T6NACyFE-NqX=Huk1hkewSakPs67vC+uuTuw@mail.gmail.com>
	<20120816222629.GG31346@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	=?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44698 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2HPWoe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 18:44:34 -0400
Received: by ggdk6 with SMTP id k6so3506689ggd.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2012 15:44:33 -0700 (PDT)
In-Reply-To: <20120816222629.GG31346@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Thanks, that's really helpful.   I can say that using a 4MB journal and
> running fsstress is _not_ enough to trigger the problem.
>
> Looking more closely at what might be needed to trigger the bug, 'i'
> gets left uninitialized when err is set to -EAGAIN, and that happens
> when ext4_ext_truncate_extend_restart() is unable to extend the
> journal transaction.  But that also means we need to be deleting a
> sufficiently large enough file that the blocks span multiple block
> groups (which is why we need to extend the transaction, so we can
> modify more bitmap blocks) at the point when there is no more room in
> the journal, so we have to close the current transaction, and then
> retry it again with a new journal handle in a new transaction.
>
> So that implies that untaring a bunch of kernels probably won't be
> sufficient, since the files will be too small.  What we probably will
> need to do is to fill a large file system with lots of large files,
> use a small journal, and then try to do an rm -rf.
>
>                                              - Ted

My suggestion of untarring kernels was to cause the big multi gigabyte
files created later on to be massively fragmented, and thus have tons
of extents and a relatively deep extent tree.
But maybe that's not needed to trigger this bug, if as you say, it is
caused by the absolute number of disks blocks being freed and not by
the size/depth/complexity of the extent tree.
My knowledge of the internals of ext4 is pretty much non-existent. ;-)
 In this case I'm just an end user.
