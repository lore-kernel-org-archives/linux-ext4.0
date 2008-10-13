From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Use an rb tree for tracking blocks freed during
	transaction.
Date: Mon, 13 Oct 2008 15:16:29 +0530
Message-ID: <20081013094629.GA7819@skywalker>
References: <1223566329-29434-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081012203147.GF12662@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:36590 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762111AbYJMJqf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 05:46:35 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m9D9kWvd012129
	for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 15:16:32 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9D9kWXd987264
	for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 15:16:32 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m9D9kVlC014504
	for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 15:16:32 +0530
Content-Disposition: inline
In-Reply-To: <20081012203147.GF12662@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 12, 2008 at 04:31:47PM -0400, Theodore Tso wrote:
> On Thu, Oct 09, 2008 at 09:02:07PM +0530, Aneesh Kumar K.V wrote:
> > With this patch we track the block freed during a transaction using
> > rb tree. We also make sure contiguos blocks freed are collected
> > in one rb node.
> 
> There seems to be a memory leak.  Over time, the number of active
> objects in ext4_free_block_extents goes up.  You can check via:
> 
> 	grep ext4_free_block_extents /proc/slabinfo 
> 
> I think the problem is here:
> 
> > +	/* Now try to see the extent can be merged to left and right */
> > +	node = rb_prev(new_node);
> > +	if (node) {
> > +		entry = rb_entry(node, struct ext4_free_data, node);
> > +		if (can_merge(entry, new_entry)) {
> > +			new_entry->start_blk = entry->start_blk;
> > +			new_entry->count += entry->count;
> > +			rb_erase(node, &(db->bb_free_root));
> > +			list_del(&entry->list);
> >  		}
> > +	}
> 
> We aren't freeing new_entry in ext4_mb_free_metadata() in the case
> where the extent can be merged with an existing node in the rbtree.
> 

Updated with the below patch

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9c151f2..2f38754 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4492,7 +4492,10 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 			new_entry->start_blk = entry->start_blk;
 			new_entry->count += entry->count;
 			rb_erase(node, &(db->bb_free_root));
+			spin_lock(&sbi->s_md_lock);
 			list_del(&entry->list);
+			spin_unlock(&sbi->s_md_lock);
+			kmem_cache_free(ext4_free_ext_cachep, entry);
 		}
 	}
 
@@ -4502,7 +4505,10 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		if (can_merge(new_entry, entry)) {
 			new_entry->count += entry->count;
 			rb_erase(node, &(db->bb_free_root));
+			spin_lock(&sbi->s_md_lock);
 			list_del(&entry->list);
+			spin_unlock(&sbi->s_md_lock);
+			kmem_cache_free(ext4_free_ext_cachep, entry);
 		}
 	}
 	/* Add the extent to active_transaction list */
