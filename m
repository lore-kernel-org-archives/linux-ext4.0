From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH] ext4: fix COLLAPSE RANGE test failure when bigalloc is
 enable
Date: Thu, 19 Jun 2014 13:51:58 +0900
Message-ID: <003a01cf8b7a$33bd03d0$9b370b70$@samsung.com>
References: <001001cf7fcc$34f3c2c0$9edb4840$@samsung.com>
 <20140617220900.GJ24890@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34363 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaFSEwE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jun 2014 00:52:04 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N7E000S1G6OXX10@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 19 Jun 2014 13:52:00 +0900 (KST)
In-reply-to: <20140617220900.GJ24890@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 On Wed, Jun 04, 2014 at 05:08:45PM +0900, Namjae Jeon wrote:
> > Blocks in collapse range should be collapsed per cluster unit when bigalloc
> > is enable. If bigalloc is not enable, EXT4_CLUSTER_SIZE will be same with
> > EXT4_BLOCK_SIZE.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> 
> Correct me if I'm wrong, but this patch enables COLLAPSE_RANGE when
> bigalloc is enabled.  The commit description (and the one-line
> summary) should emphasize this.
Yes, You're right. I will update description.
> 
> And I assume you've run a full xfstests auto run with bigalloc and
> everything passed?
Yes, kvm-test is passed with no issues.(kvm-xfstests -c bigalloc -g auto,
kvm-xfstests -c bigalloc_1k -g auto)
In order to run collapse range xfstests with bigalloc, I had to make some changes.
1) In case of collapse, fsx and fsstress use block aligned paramteres, but for
bigalloc it has to be cluster size aligned. I am not aware of any method by which
ext4 can tell cluster size to user space so I changed fsx and fsstress code to use
hard coded 64KB cluster size alignment.

2) xfstests which tests corner cases for collapse could not be executed with
bigalloc as they are written keeping in mind that blocksize >= 4096.
So, for testing purpose. I changed the multiple factor in function
_test_generic_punch to 64 from 4. Also, the corresponding .out files has to
be changed.

I am looking for a proper way to integrate these changes in xfstests.

Thanks!
> 
> Thanks,
> 
> 						- Ted

