From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 09:57:10 -0500
Message-ID: <4F8ED646.1040100@redhat.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com> <4F8DAAFE.40500@redhat.com> <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab2DRO5R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Apr 2012 10:57:17 -0400
In-Reply-To: <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/17/12 11:59 PM, Andreas Dilger wrote:

...

> Secondly, your test program is not doing random writes to disk, but
> rather doing writes at 64kB intervals. There is logic in the
> uninitialized extent handling that will write zeros to an entire
> extent, rather than create many fragmented uninitialized extents.  It
> may be possible that you are zeroing out the entire file, and writing
> 16x as much data as you expect.
> 
> Cheers, Andreas

I don't think the testcase as written is triggering that behavior, though
other similar testcases might.  In this case the left-over uninit extents
are large enough that they don't get zeroed:

File size of /mnt/scratch/test is 268435456 (65536 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0    34816               1 
   1       1    34817              15 unwritten
   2      16    34832               1 
   3      17    34833              15 unwritten
   4      32    34848               1 
   5      33    34849              15 unwritten
...

Good guess though :)

-Eric
