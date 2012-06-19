From: Zachary Mark <zmark@cleversafe.com>
Subject: Re: [PATCH 0/2] Re: Discrepancy in 'df' output between kernel 3.0
 and 3.2 for ext4?
Date: Tue, 19 Jun 2012 14:54:44 -0500
Message-ID: <4FE0D904.7050401@cleversafe.com>
References: <4FD8D731.9070008@cleversafe.com> <1340055909-7683-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail209.messagelabs.com ([216.82.255.3]:17538 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2FSTzG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2012 15:55:06 -0400
In-Reply-To: <1340055909-7683-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/18/2012 04:45 PM, Theodore Ts'o wrote:
> Zachary,
>
> Hopefully this should fix the problem which you noted.
>
>
> Theodore Ts'o (2): ext4: pass a char * to ext4_count_free() instead
> of a buffer_head ptr ext4: fix overhead calculation used by
> ext4_statfs()
>
> fs/ext4/balloc.c |   3 +- fs/ext4/bitmap.c |  12 +--- fs/ext4/ext4.h
> |   6 +- fs/ext4/ialloc.c |   3 +- fs/ext4/resize.c |   7 ++-
> fs/ext4/super.c  | 174
> +++++++++++++++++++++++++++++++++++++++---------------- 6 files
> changed, 140 insertions(+), 65 deletions(-)
>

Ted, thanks for the patches!  I've tested your patches against 3.5~rc3. 
  I had to return the machine on which I first spotted the problem, but 
here are results from a box with identical hardware:

df from 3.0:
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda1              5080796    891164   3927376  19% /
tmpfs                 12368192        32  12368160   1% /dev/shm
/dev/sdh1            2907178636    205816 2906972820   1%
/media/012a0d3e-8210-4eb1-94a9-a2a1fdeb62f3
/dev/sdi1            2907178636   1056768 2906121868   1%
/media/20a46e68-8203-459e-8364-0626510c2ff9


df from 3.2.20 (identical to 3.5~rc3 without your patches):
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda1              5080796    928376   3890164  20% /
tmpfs                 12368792        32  12368760   1% /dev/shm
/dev/sdh1            2928733612  21760792 2906972820   1%
/media/012a0d3e-8210-4eb1-94a9-a2a1fdeb62f3
/dev/sdi1            2928733612  22611744 2906121868   1%
/media/20a46e68-8203-459e-8364-0626510c2ff9


df from 3.5~rc3 with your patches applied (as they didn't apply to 3.2):
[root@lab-s2210-0331 20a46e68-8203-459e-8364-0626510c2ff9]# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda1              5080796    909656   3908884  19% /
tmpfs                 12368708        32  12368676   1% /dev/shm
/dev/sdh1            2907178636    205816 2906972820   1%
/media/012a0d3e-8210-4eb1-94a9-a2a1fdeb62f3
/dev/sdi1            2907178636   1060936 2906117700   1%
/media/20a46e68-8203-459e-8364-0626510c2ff9

(duplicate parts of output removed)

sdh1 is mostly empty.  sdi1 has about 6700 128k files written to it plus
everything on sdh1.  There seems to be slightly more overhead accounted
for after your patches.  Not sure if this is to be expected or not.  In
any case, they seem to be a step in the right direction if not an
outright solution.  Let me know if you need anything additional from me.

-- Zachary Mark
