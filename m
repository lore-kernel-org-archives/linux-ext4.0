From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix oops in mballoc caused by a variable overflow
Date: Thu, 17 Jan 2008 21:59:28 +0530
Message-ID: <20080117162928.GC6667@skywalker>
References: <1200510717.4561.11.camel@ext1.frec.bull.fr> <1200509307.3985.8.camel@localhost.localdomain> <20080117064736.GA6749@skywalker> <478F234C.90807@bull.net> <20080117120752.GB24979@skywalker> <478F5395.9040203@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Cc: Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:52056 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbYAQQ3i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 11:29:38 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m0HGUP1I028938
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2008 03:30:25 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0HGXD1l262382
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2008 03:33:13 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0HGTaM9001312
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2008 03:29:36 +1100
Content-Disposition: inline
In-Reply-To: <478F5395.9040203@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 17, 2008 at 02:09:41PM +0100, Valerie Clement wrote:
> Aneesh Kumar K.V wrote:
>> On Thu, Jan 17, 2008 at 10:43:40AM +0100, Valerie Clement wrote:
>>> Aneesh Kumar K.V wrote:
>>>> What about this  ? I guess we will overflow start = start << bsbits;
>>>>
>>> Hi Aneesh,
>>> your patch below doesn't fix the issue, because as start_off is also  
>>> loff_t, start_off = ac->ac_o_ex.fe_logical << bsbits  also overflows.
>>>
>>
>> loff_t is 64 bits.
>>
>> typedef __kernel_loff_t         loff_t;
>> typedef long long       __kernel_loff_t;
>> typedef __u32 ext4_lblk_t;
>> typedef unsigned long long ext4_fsblk_t
>>
>> start_off = ac->ac_o_ex.fe_logical << bsbits;
>>
>> In the above line what we are storing in start_off is the offset in bytes.So it makes
>> sense to use the type loff_t. It is neither logical block nor physical block.
>
> Oh yes, sorry, you're right. I read too quickly.
>
> In fact, it's missing a cast :
>   start_off = (loff_t) ac->ac_o_ex.fe_logical << bsbits;
>
> With that change, the test is ok.

Updated patch below.

-aneesh

--4Ckj6UjgE2iN1+kY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="overflow-fix.patch"

ext4: Fix overflow in ext4_mb_normalize_request

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

kernel BUG at fs/ext4/mballoc.c:3148!

The BUG_ON is:
BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));

where the value of "size" is 4293920768.

This is due to the overflow of the variable "start" in the
ext4_mb_normalize_request() function.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/mballoc.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)


diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d8cd81e..d16083c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2998,7 +2998,7 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	int bsbits, max;
 	ext4_lblk_t end;
 	struct list_head *cur;
-	loff_t size, orig_size;
+	loff_t size, orig_size, start_off;
 	ext4_lblk_t start, orig_start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 
@@ -3039,7 +3039,7 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 
 	/* first, try to predict filesize */
 	/* XXX: should this table be tunable? */
-	start = 0;
+	start_off = 0;
 	if (size <= 16 * 1024) {
 		size = 16 * 1024;
 	} else if (size <= 32 * 1024) {
@@ -3055,26 +3055,24 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	} else if (size <= 1024 * 1024) {
 		size = 1024 * 1024;
 	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, bsbits)) {
-		start = ac->ac_o_ex.fe_logical << bsbits;
-		start = (start / (1024 * 1024)) * (1024 * 1024);
+		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
+						(20 - bsbits)) << 20;
 		size = 1024 * 1024;
 	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, bsbits)) {
-		start = ac->ac_o_ex.fe_logical << bsbits;
-		start = (start / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
+		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
+							(22 - bsbits)) << 22;
 		size = 4 * 1024 * 1024;
 	} else if (NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,
 					(8<<20)>>bsbits, max, bsbits)) {
-		start = ac->ac_o_ex.fe_logical;
-		start = start << bsbits;
-		start = (start / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
+		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
+							(23 - bsbits)) << 23;
 		size = 8 * 1024 * 1024;
 	} else {
-		start = ac->ac_o_ex.fe_logical;
-		start = start << bsbits;
-		size = ac->ac_o_ex.fe_len << bsbits;
+		start_off = (loff_t)ac->ac_o_ex.fe_logical << bsbits;
+		size	  = ac->ac_o_ex.fe_len << bsbits;
 	}
 	orig_size = size = size >> bsbits;
-	orig_start = start = start >> bsbits;
+	orig_start = start = start_off >> bsbits;
 
 	/* don't cover already allocated blocks in selected range */
 	if (ar->pleft && start <= ar->lleft) {

--4Ckj6UjgE2iN1+kY--
