From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH] ext4: fix COLLAPSE RANGE test failure when bigalloc is
 enable
Date: Wed, 30 Jul 2014 13:36:23 +0900
Message-ID: <002501cfabaf$d15e04e0$741a0ea0$@samsung.com>
References: <001001cf7fcc$34f3c2c0$9edb4840$@samsung.com>
 <20140617220900.GJ24890@thunk.org>
 <003a01cf8b7a$33bd03d0$9b370b70$@samsung.com> <20140729144716.GC2256@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:47203 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaG3Eg0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2014 00:36:26 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N9I000F5CSOWTD0@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 30 Jul 2014 13:36:24 +0900 (KST)
In-reply-to: <20140729144716.GC2256@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> On Thu, Jun 19, 2014 at 01:51:58PM +0900, Namjae Jeon wrote:
> >  On Wed, Jun 04, 2014 at 05:08:45PM +0900, Namjae Jeon wrote:
> > > > Blocks in collapse range should be collapsed per cluster unit when bigalloc
> > > > is enable. If bigalloc is not enable, EXT4_CLUSTER_SIZE will be same with
> > > > EXT4_BLOCK_SIZE.
> > > >
> > > > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > > > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > >
> > > Correct me if I'm wrong, but this patch enables COLLAPSE_RANGE when
> > > bigalloc is enabled.  The commit description (and the one-line
> > > summary) should emphasize this.
> > Yes, You're right. I will update description.
> 
> I don't think I saw an updated description, so I've taken care of
> updating the description and applied the patch:
Sorry, I forgot to update it..
Thanks Ted!

> 
> commit 3c17714e61314b101fb9bb671e7191ef1e9e63f3
> Author: Namjae Jeon <namjae.jeon@samsung.com>
> Date:   Tue Jul 29 10:45:31 2014 -0400
> 
>     ext4: fix COLLAPSE RANGE test for bigalloc file systems
> 
>     Blocks in collapse range should be collapsed per cluster unit when
>     bigalloc is enable. If bigalloc is not enable, EXT4_CLUSTER_SIZE will
>     be same with EXT4_BLOCK_SIZE.
> 
>     With this bug fixed, patch enables COLLAPSE_RANGE for bigalloc, which
>     fixes a large number of xfstest failures which use fsx.
> 
>     Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>     Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> 							- Ted

