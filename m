From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/3] e2fsck: fix incorrect interior node logical start
 values
Date: Fri, 21 Dec 2012 14:47:58 -0600
Message-ID: <50D4CAFE.5010606@redhat.com>
References: <20121220234229.GA22476@thunk.org> <1356047023-28367-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	forrestl@synology.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab2LUUsG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Dec 2012 15:48:06 -0500
In-Reply-To: <1356047023-28367-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/20/12 5:43 PM, Theodore Ts'o wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> An index node's logical start (ei_block) should
> match the logical start of the first node (index
> or leaf) below it.  If we find a node whose start
> does not match its parent, fix all of its parents
> accordingly.
> 
> If it finds such a problem, we'll see:
> 
> Pass 1: Checking inodes, blocks, and sizes
> Interior extent node level 0 of inode 274258:
> Logical start 3666 does not match logical start 4093 at next level.  Fix<y>?

Hm, this situation might still need more work in some cases.

Looking at a "bad" extent tree reported to me:

 1/ 2  25/ 29 57524 - 59011 15538183              1488
 2/ 2   1/  2 57524 - 59011 15556788 - 15558275   1488
 2/ 2   2/  2 59012 - 65535 15558276 - 15564799   6524 Uninit <- what's this extent?

 1/ 2  26/ 29 59012 - 60671 15538184              1660
 2/ 2   1/  2 59012 - 60671    25638 -    27297   1660
 2/ 2   2/  2 60672 - 60689    27298 -    27315     18 Uninit

 1/ 2  27/ 29 60672 - 61023 15538185               352 <- bad logical start
 2/ 2   1/ 19 60690 - 60690    27316 -    27316      1 Uninit


e2fsck with my patch finds & fixes the parent issues:

Pass 1: Checking inodes, blocks, and sizes
Interior extent node level 1 of inode 8126473:
Logical start 60672 does not match logical start 60690 at next level.  Fix? yes

Interior extent node level 1 of inode 8126473:
Logical start 63157 does not match logical start 63159 at next level.  Fix? yes

and after that the extents look like:

 1/ 2  25/ 29 57524 - 59011 15538183              1488
 2/ 2   1/  2 57524 - 59011 15556788 - 15558275   1488
 2/ 2   2/  2 59012 - 65535 15558276 - 15564799   6524 Uninit <--- ???

 1/ 2  26/ 29 59012 - 60689 15538184              1678
 2/ 2   1/  2 59012 - 60671    25638 -    27297   1660
 2/ 2   2/  2 60672 - 60689    27298 -    27315     18 Uninit

 1/ 2  27/ 29 60690 - 61023 15538185               334 <-- only this got fixed
 2/ 2   1/ 19 60690 - 60690    27316 -    27316      1 Uninit

but in this case, it seems that the length of the range covered by the previous interior nodes is still incorrect.  :(

-Eric
