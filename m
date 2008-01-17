From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix oops in mballoc caused by a variable overflow
Date: Thu, 17 Jan 2008 12:17:36 +0530
Message-ID: <20080117064736.GA6749@skywalker>
References: <1200510717.4561.11.camel@ext1.frec.bull.fr> <1200509307.3985.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:47951 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbYAQGrh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 01:47:37 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m0H6lXVV027339
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 12:17:33 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0H6lXrv860406
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 12:17:33 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m0H6lWFr024449
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 06:47:33 GMT
Content-Disposition: inline
In-Reply-To: <1200509307.3985.8.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 16, 2008 at 10:48:27AM -0800, Mingming Cao wrote:
> On Wed, 2008-01-16 at 20:11 +0100, Valerie Clement wrote:
> > A simple dd oopses the kernel (2.6.24-rc7 with the latest patch queue):
> >   dd if=/dev/zero of=/mnt/test/foo bs=1M count=8096
> > 
> > EXT4-fs: mballoc enabled
> > ------------[ cut here ]------------
> > kernel BUG at fs/ext4/mballoc.c:3148!
> > 
> > The BUG_ON is:
> > 	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
> > 
> > where the value of "size" is 4293920768.
> > 
> > This is due to the overflow of the variable "start" in the 
> > ext4_mb_normalize_request() function.
> > The patch below fixes it.
> > 
> Thanks!
> 
> > Signed-off-by: Valerie Clement <valerie.clement@bull.net>
> > ---
> > 
> >  mballoc.c |   23 ++++++++++++-----------
> >  1 file changed, 12 insertions(+), 11 deletions(-)
> > 
> > 
> > Index: linux-2.6.24-rc7/fs/ext4/mballoc.c
> > ===================================================================
> > --- linux-2.6.24-rc7.orig/fs/ext4/mballoc.c	2008-01-16 19:22:45.000000000 +0100
> > +++ linux-2.6.24-rc7/fs/ext4/mballoc.c	2008-01-16 19:25:04.000000000 +0100
> > @@ -2990,6 +2990,7 @@ static void ext4_mb_normalize_request(st
> >  	struct list_head *cur;
> >  	loff_t size, orig_size;
> >  	ext4_lblk_t start, orig_start;
> > +	ext4_fsblk_t pstart;
> 
> ext4_fsblk_t is used for fs physical block number, here I think pstart
> is pointing to some logical block location..
> 
> >  	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
> > 
> >  	/* do normalize only data requests, metadata requests
> > @@ -3029,7 +3030,7 @@ static void ext4_mb_normalize_request(st
> > 
> >  	/* first, try to predict filesize */
> >  	/* XXX: should this table be tunable? */
> > -	start = 0;
> > +	pstart = 0;
> >  	if (size <= 16 * 1024) {
> >  		size = 16 * 1024;
> >  	} else if (size <= 32 * 1024) {
> > @@ -3045,25 +3046,25 @@ static void ext4_mb_normalize_request(st
> >  	} else if (size <= 1024 * 1024) {
> >  		size = 1024 * 1024;
> >  	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, bsbits)) {
> > -		start = ac->ac_o_ex.fe_logical << bsbits;
> > -		start = (start / (1024 * 1024)) * (1024 * 1024);
> > +		pstart = ac->ac_o_ex.fe_logical << bsbits;
> > +		pstart = (pstart / (1024 * 1024)) * (1024 * 1024);
> 
> How about using shift...
> 
> -		start = ac->ac_o_ex.fe_logical << bsbits;
> -		start = (start / (1024 * 1024)) * (1024 * 1024);
> +		start = (ac->ac_o_ex.fe_logical >> (20-bsbits)) << 20;
> 
> That would be more efficient and should fix the overflow issue
> 
> >  		size = 1024 * 1024;
> >  	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, bsbits)) {
> > -		start = ac->ac_o_ex.fe_logical << bsbits;
> > -		start = (start / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
> > +		pstart = ac->ac_o_ex.fe_logical << bsbits;
> > +		pstart = (pstart / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
> 
> +		start = (ac->ac_o_ex.fe_logical >> (22-bsbits)) << 22;
> 
> >  		size = 4 * 1024 * 1024;
> >  	} else if(NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,(8<<20)>>bsbits,max,bsbits)){
> > -		start = ac->ac_o_ex.fe_logical;
> > -		start = start << bsbits;
> > -		start = (start / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
> > +		pstart = ac->ac_o_ex.fe_logical;
> > +		pstart = pstart << bsbits;
> > +		pstart = (pstart / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
> 
> +		start = (ac->ac_o_ex.fe_logical >> (23-bsbits)) << 23;
> 
> >  		size = 8 * 1024 * 1024;
> >  	} else {
> > -		start = ac->ac_o_ex.fe_logical;
> > -		start = start << bsbits;
> > +		pstart = ac->ac_o_ex.fe_logical;
> > +		pstart = pstart << bsbits;
> >  		size = ac->ac_o_ex.fe_len << bsbits;


What about this  ? I guess we will overflow 
start = start << bsbits;

I guess start should be of type loff_t. Patch below

-aneesh

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

 fs/ext4/mballoc.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)


diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d8cd81e..d8a2db8 100644
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
@@ -3055,26 +3055,21 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	} else if (size <= 1024 * 1024) {
 		size = 1024 * 1024;
 	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, bsbits)) {
-		start = ac->ac_o_ex.fe_logical << bsbits;
-		start = (start / (1024 * 1024)) * (1024 * 1024);
+		start_off = (ac->ac_o_ex.fe_logical >> (20 - bsbits)) << 20;
 		size = 1024 * 1024;
 	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, bsbits)) {
-		start = ac->ac_o_ex.fe_logical << bsbits;
-		start = (start / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
+		start_off = (ac->ac_o_ex.fe_logical >> (22 - bsbits)) << 22;
 		size = 4 * 1024 * 1024;
 	} else if (NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,
 					(8<<20)>>bsbits, max, bsbits)) {
-		start = ac->ac_o_ex.fe_logical;
-		start = start << bsbits;
-		start = (start / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
+		start_off = (ac->ac_o_ex.fe_logical >> (23 - bsbits)) << 23;
 		size = 8 * 1024 * 1024;
 	} else {
-		start = ac->ac_o_ex.fe_logical;
-		start = start << bsbits;
-		size = ac->ac_o_ex.fe_len << bsbits;
+		start_off = ac->ac_o_ex.fe_logical << bsbits;
+		size	  = ac->ac_o_ex.fe_len << bsbits;
 	}
 	orig_size = size = size >> bsbits;
-	orig_start = start = start >> bsbits;
+	orig_start = start = start_off >> bsbits;
 
 	/* don't cover already allocated blocks in selected range */
 	if (ar->pleft && start <= ar->lleft) {
