From: Theodore Tso <tytso@mit.edu>
Subject: Re: [OOPs] ext4: fixpoint divide exception at
	ext4_fill_super+0x141c/0x2908
Date: Fri, 6 Nov 2009 14:48:50 -0500
Message-ID: <20091106194850.GE26342@mit.edu>
References: <4A93792C.2000705@linux.vnet.ibm.com> <4AF17638.7010105@linux.vnet.ibm.com> <4AF1877C.7010606@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	sachin p sant <sachinp@linux.vnet.ibm.com>,
	Ramon <rcvalle@linux.vnet.ibm.com>, aneesh.kumar@in.ibm.com
To: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52086 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759682AbZKFTsr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 14:48:47 -0500
Content-Disposition: inline
In-Reply-To: <4AF1877C.7010606@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 04, 2009 at 07:24:04PM +0530, Nageswara R Sastry wrote:
> Seems to be I have a little format related issue with the patch. So  
> resending it. Please accept my apologies.
> Sachin thanks for letting me know.
>
>>  > ------------[ cut here ]------------
>>  > Kernel BUG at 000003e00429d934 [verbose debug info unavailable]
>>  > fixpoint divide exception: 0009 [#1] SMP
>>
>> Please find the patch which solves the following 'fixpoint divide  
>> exception'. I tested the same and not seeing any KERNEL BUG/exception.

Nageswara,

Thanks for sending this patch.  The problem with it is that it leaves
sbi->s_log_groups_per_flex non-zero, but it leaves sbi->s_flex_groups
unallocated.  This should lead to number of kernel oops caused by a
null pointer dereference if there is any attempt to allocate blocks or
inodes, or to resize the filesystem.

A better fix is would be:

ext4: Avoid divide by zero when trying to mount a corrupted file system

If s_log_groups_per_flex is greater than 31, then groups_per_flex will
will overflow and cause a divide by zero error.  This can cause kernel
BUG if such a file system is mounted.

Thanks to Nageswara R Sastry for analyzing the failure and providing
an initial patch.

http://bugzilla.kernel.org/show_bug.cgi?id=14287

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d4ca92a..8662b2e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1673,14 +1673,14 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	size_t size;
 	int i;
 
-	if (!sbi->s_es->s_log_groups_per_flex) {
+	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
+	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
+
+	if (groups_per_flex < 2) {
 		sbi->s_log_groups_per_flex = 0;
 		return 1;
 	}
 
-	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
-	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
