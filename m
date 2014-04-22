From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH v2 2/2] ext4: disable COLLAPSE_RANGE for bigalloc
Date: Tue, 22 Apr 2014 14:55:21 +0900
Message-ID: <001e01cf5def$72489500$56d9bf00$@samsung.com>
References: <000d01cf5b8b$5b149110$113db330$@samsung.com>
 <20140419221221.GD13492@thunk.org>
 <001101cf5d1d$7f6bce00$7e436a00$@samsung.com>
 <20140421133119.GD14869@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:35936 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaDVFzX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2014 01:55:23 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4F00BMZ4G946A0@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 22 Apr 2014 14:55:21 +0900 (KST)
In-reply-to: <20140421133119.GD14869@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, Apr 21, 2014 at 01:52:28PM +0900, Namjae Jeon wrote:
> > >
> > > What's the status of the "[2/3] ext4: fix ZERO_RANGE test failure in
> > > data journalling mode" patch.  Is it no longer needed?
> > It is needed. Currently, I am considering your suggestion of introducing
> > EXT4_I(inode)->i_write_mutex which can also include ext4_aio_mutex.
> 
> OK; I've already pushed a set of patches to Linus because it's getting
> fairly late in the development cycle, and we really want to get as
> much of the bug fixes into -rc3 (having missed -rc2 by a few hours,
> sigh).
Okay, I will try to fix remaning issues in -rc3.
> 
> By the way, in doing some final testing, it appears that we are still
> failing generic/127 with a 1k blocksize.  If I block COLLAPSE_RANGE
> using the patch that everyone but me seems to hate :-), the problem
> goes away.  So we have at least one other issue that needs to be
> looked at.
> 
> You can reproduce by grabbing the dev branch from the ext4.git tree,
> and then cherry-picking the top commit from the unstable branch.
> 
> Then run "kvm-xfstests -c 1k generic/127", with and without the
> following in config.custom:
> 
> EXTRA_ARG="ext4.fallocate_mode_block=0x08"
Okay, I will look at this issue now.

Thanks Ted!!
> 
> Cheers,
> 
> 						- Ted

