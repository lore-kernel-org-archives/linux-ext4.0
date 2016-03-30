From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114701] ubsan: "shift exponent -1 is negative" in
 fs/ext4/mballoc.c:2612:15
Date: Wed, 30 Mar 2016 09:12:29 +0000
Message-ID: <bug-114701-13602-vrpyELHlhR@https.bugzilla.kernel.org/>
References: <bug-114701-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60197 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758824AbcC3JMc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Mar 2016 05:12:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DF24720380
	for <linux-ext4@vger.kernel.org>; Wed, 30 Mar 2016 09:12:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 556042037F
	for <linux-ext4@vger.kernel.org>; Wed, 30 Mar 2016 09:12:29 +0000 (UTC)
In-Reply-To: <bug-114701-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114701

Navin Parakkal <navinp1912@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |navinp1912@gmail.com

--- Comment #1 from Navin Parakkal <navinp1912@gmail.com> ---
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 50e05df..8ccfcf7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1278,6 +1278,8 @@ static int mb_find_order_for_block(struct ext4_buddy
*e4b, int block)
                        /* this block is part of buddy of order 'order' */
                        return order;
                }
+               if (order > e4b->bd_blkbits)
+                       break;
                bb += 1 << (e4b->bd_blkbits - order);
                order++;
        }
@@ -2616,6 +2618,8 @@ int ext4_mb_init(struct super_block *sb)
        do {
                sbi->s_mb_offsets[i] = offset;
                sbi->s_mb_maxs[i] = max;
+               if (i > sb->s_blocksize_bits)
+                       break;
                offset += 1 << (sb->s_blocksize_bits - i);
                max = max >> 1;
                i++;


The only case if when i>b you compute off and max but those are not assigned .
So those values can be ignored. It keeps the old behaviour intact and fixes the
undefined behaviour.


offset += 1 << (sb->s_blocksize_bits - i);


/* Remove the if to see trap error at runtime */
/* gcc -fsanitize=undefined x.c */
int main()
{
    int i=1;
    int b=12;
    unsigned ub=12;
    unsigned off=0,uoff=0;
    do{
        if(i> b) break;
        off+=1<<(b-i);
        uoff+=1<<(ub-i);
        i++;
    } while(i<=b+1);
}

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
