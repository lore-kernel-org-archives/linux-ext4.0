From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix small file fragmentation
Date: Fri, 15 Aug 2008 22:03:01 +0530
Message-ID: <20080815163301.GB6511@skywalker>
References: <1218735880-10915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080814231816.GA13048@mit.edu> <20080815133803.GL13048@mit.edu> <20080815163112.GA6511@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:43711 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbYHOQdK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 12:33:10 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7FGW3n0028481
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 02:32:03 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FGX8BI3608750
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 02:33:08 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FGX71a017072
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 02:33:08 +1000
Content-Disposition: inline
In-Reply-To: <20080815163112.GA6511@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2008 at 10:01:12PM +0530, Aneesh Kumar K.V wrote:
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 25adfc3..a658690 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -163,7 +163,9 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  		 */
>  		if (!was_dirty) {
>  			inode->dirtied_when = jiffies;
> -			list_move(&inode->i_list, &sb->s_dirty);
> +			//list_move(&inode->i_list, &sb->s_dirty);
> +			__list_del(&inode->i_list->prev, &inode->i_list->next);
> +			list_add_tail(&inode->i_list, &sb->s_dirty);
>  		}
>  	}
>  out:

better one

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 25adfc3..91f3c54 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -163,7 +163,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 */
 		if (!was_dirty) {
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
+			list_move_tail(&inode->i_list, &sb->s_dirty);
 		}
 	}
 out:
