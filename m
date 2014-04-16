From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 0/3] ext4: fix several failure issues in xfstests.
Date: Thu, 17 Apr 2014 07:27:32 +0900
Message-ID: <002801cf59c3$0f0515c0$2d0f4140$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:33763 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPW1g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 18:27:36 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4500LJSADWYI20@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Apr 2014 07:27:32 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are several failures while running xfstests-bld(generic/075 and 091).
(reported by Ted)
COLLAPSE RANGE issue are mixed with ZERO RANGE issue as per format and mount
options.

First, list up issues like the following.
1. format with 1KB or 2KB block size.(075, 091 are failed, COLLAPSE RANGE issue).
2. mount -o dioread_nolock. (091 is failed, ZERO RANGE issue.)
   - As I know, Lukas is checking this issue.
3. mount -o data=journal. (091 is failed, ZERO RANGE issue.)
4. format with bigalloc. (075 and 091 are failed, COLLAPSE RANGE issue).
   - Once I would like to be disable COLLAPSE RANGE on ext4 with bigalloc feature
     till finding the root-cause. first, I need the time to understand bigalloc feature..
5. testing more.

Namjae Jeon(3)
 ext4: fix COLLAPSE_RANGE failure issue on ext4 with 1KB block size.
 ext4: fix ZERO_RANGE test failure in data journalling mode.
 ext4: disable COLLAPSE_RANGE for bigalloc.

-- 
1.7.9.5

