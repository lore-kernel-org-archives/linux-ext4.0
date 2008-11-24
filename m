From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap
	and mark_diskspace_used
Date: Mon, 24 Nov 2008 17:03:23 +0530
Message-ID: <20081124113323.GC8462@skywalker>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081123140038.GC26473@mit.edu> <492A5453.9030801@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:40221 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYKXLhi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 06:37:38 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAOBakM0025338
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 22:36:46 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAOBY4MC1573000
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 22:34:06 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAOBXjE8009013
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 22:33:46 +1100
Content-Disposition: inline
In-Reply-To: <492A5453.9030801@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 24, 2008 at 10:14:27AM +0300, Alex Zhuravlev wrote:
> Theodore Tso wrote:
>> My bigger concern is given that we are playing games like *this*:
>>
>> 		if ((cur & 31) == 0 && (len - cur) >= 32) {
>> 			/* fast path: set whole word at once */
>> 			addr = bm + (cur >> 3);
>> 			*addr = 0xffffffff;
>> 			cur += 32;
>> 			continue;
>> 		}
>
> this is to avoid expensive LOCK prefix in some cases.
>
>> without taking a lock, I'm a little surprised we haven't been
>> seriously burned by other race conditions.  What's the point of
>> calling mb_set_bit_atomic() and passing in a spinlock if we are doing
>> this kind of check without the protection of the same spinlock?!?
>
> why would we need a lock for a whole word bitop ?

Ok the changes was not done for this purpose. I need to make sure we
update bitmap and clear group_desc uninit flag after taking sb_bgl_lock
That means when we claim blocks we can't use mb_set_bits with
sb_bgl_lock because we would already be holding it. How about the below
change

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 444ad99..53180b1 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1031,7 +1031,10 @@ static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		mb_clear_bit_atomic(lock, cur, bm);
+		if (lock)
+			mb_clear_bit_atomic(lock, cur, bm);
+		else
+			mb_clear_bit(cur, bm);
 		cur++;
 	}
 }
@@ -1049,7 +1052,10 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		mb_set_bit_atomic(lock, cur, bm);
+		if (lock)
+			mb_set_bit_atomic(lock, cur, bm);
+		else
+			mb_set_bit(cur, bm);
 		cur++;
 	}
 }
