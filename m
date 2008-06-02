From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix use of uninitialized data
Date: Sun, 1 Jun 2008 20:08:42 -0400
Message-ID: <20080602000842.GA24339@mit.edu>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	alex@clusterfs.com, adilger@sun.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:53473 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752566AbYFBAKA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2008 20:10:00 -0400
Content-Disposition: inline
In-Reply-To: <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 15, 2008 at 12:17:11AM +0530, Aneesh Kumar K.V wrote:
> @@ -3134,8 +3135,7 @@ static void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
>  static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
>  				struct ext4_prealloc_space *pa)
>  {
> -	unsigned len = ac->ac_o_ex.fe_len;
> -
> +	unsigned int len = ac->ac_o_ex.fe_len;
>  	ext4_get_group_no_and_offset(ac->ac_sb, pa->pa_pstart,
>  					&ac->ac_b_ex.fe_group,
>  					&ac->ac_b_ex.fe_start);
> -- 

This change had nothing to do with fixing the use of unitialized data,
but when I started looking more closely, it raised a potential signed
vs. unsigned issue: ac_o_ex is a struct ext4_free_extent, and fe_len
is an int.

So here we are assigning an int to an unsigned int.  Later, len is
assigned to ac_b_ex.len, which means assigning an unsigned int to an
int.  In other places, fe_len (an int) is compared against pa_free
(which is an unsigned short), and fe_len gets assined to pa_free, once
again mixing signed and unsigned.

Can someone who is really familiar with this code check this out?  I
think the following pseudo-patch to mballoc.h might be in order:

 struct ext4_free_extent {
 	ext4_lblk_t fe_logical;
 	ext4_grpblk_t fe_start;
 	ext4_group_t fe_group;
-	int fe_len;
+	unsigned int fe_len;
 };


						- Ted
