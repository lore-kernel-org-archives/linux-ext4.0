From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 3/5] ext4: No need to truncate pagecache twice in collapse
 range
Date: Thu, 17 Apr 2014 09:41:45 +0900
Message-ID: <003101cf59d5$cf1798d0$6d46ca70$@samsung.com>
References: <002d01cf59d4$c9a07a30$5ce16e90$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:37997 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbaDQAl4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 20:41:56 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N45000ZSGLQA670@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Apr 2014 09:41:50 +0900 (KST)
In-reply-to: <002d01cf59d4$c9a07a30$5ce16e90$@samsung.com>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> We're already calling truncate_pagecache_range() before we attempt to
> do any actual job so there is not need to truncate pagecache once more
> using truncate_setsize() after we're finished.
> 
> Remove truncate_setsize() and replace it just with i_size_write() note
> that we're holding appropriate locks.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Hi Lukas.

I added this code by getting rewiew from Hugh.
Plz see the disscusion beween Hugh and Dave.

Hugh: But your case is different: collapse is much closer to truncation,
 and if you do not unmap the private COW'ed pages, then pages left
 behind beyond the EOF will break the spec that requires SIGBUS when
 touching there, and pages within EOF will be confusingly derived
 from file data now belonging to another offset or none (move these
 pages within the user address space? no, I don't think anon_vmas
 would allow that, and there may be no right place to move them).
 
Dave: See above - we never leave pages beyond the new EOF because setting
 the new EOF is a truncate operation that calls
 truncate_setsize(inode, newsize).
 
Hugh: Right, thanks, I now see the truncate_setsize() in the xfs case -
 though not in the ext4 case, which looks as if it's just doing an
 i_size_write() afterwards.

Dave: So that's a bug in the ext4 code ;)

truncate_setsize is not needed in case Hugh pointed out ?

Thanks!

