From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Subject: Re: [OOPs] ext4: fixpoint divide exception at ext4_fill_super+0x141c/0x2908
Date: Wed, 04 Nov 2009 18:10:24 +0530
Message-ID: <4AF17638.7010105@linux.vnet.ibm.com>
References: <4A93792C.2000705@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040307080208070708080009"
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	sachin p sant <sachinp@linux.vnet.ibm.com>,
	Ramon <rcvalle@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42162 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbZKDMk2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Nov 2009 07:40:28 -0500
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id nA4CeWTo025994
	for <linux-ext4@vger.kernel.org>; Wed, 4 Nov 2009 23:40:32 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nA4CbQGX1429754
	for <linux-ext4@vger.kernel.org>; Wed, 4 Nov 2009 23:37:27 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nA4CeULJ027271
	for <linux-ext4@vger.kernel.org>; Wed, 4 Nov 2009 23:40:30 +1100
In-Reply-To: <4A93792C.2000705@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040307080208070708080009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

The following bug exists in 2.6.32-rc* also.

 > ------------[ cut here ]------------
 > Kernel BUG at 000003e00429d934 [verbose debug info unavailable]
 > fixpoint divide exception: 0009 [#1] SMP

Please find the patch which solves the following 'fixpoint divide 
exception'. I tested the same and not seeing any KERNEL BUG/exception.

I created the patch from 2.6.32-rc6 code.


Thanks and Regards
R.Nageswara Sastry

Though the 'sbi->s_log_groups_per_flex' contains valid data after the 
shift operation 'groups_per_flex' is becoming zero, which later used as 
a divisor.
groups_per_flex = 1 << sbi->s_log_groups_per_flex

Signed-off-by: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>




--------------040307080208070708080009
Content-Type: text/plain;
 name="ext4_fix_point_division_error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ext4_fix_point_division_error.patch"

diff -Naurp a/linux-2.6.32-rc6/fs/ext4/super.c b/linux-2.6.32-rc6/fs/ext4/super.c
--- a/linux-2.6.32-rc6/fs/ext4/super.c	2009-11-03 20:37:49.000000000 +0100
+++ b/linux-2.6.32-rc6/fs/ext4/super.c	2009-11-04 13:21:48.000000000 +0100
@@ -1681,6 +1681,12 @@ static int ext4_fill_flex_info(struct su
 	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
 	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
 
+	/* There are some situations, after shift the value of 'groups_per_flex'
+	   can become zero and division with 0 will result in fixpoint divide exception
+	 */
+	if (groups_per_flex == 0)
+		return 1;
+
 	/* We allocate both existing and potentially added groups */
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
 			((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<

--------------040307080208070708080009--

