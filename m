From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC v3] [PATCH 0/18] DAX page fault locking
Date: Wed, 11 May 2016 11:19:30 +0200
Message-ID: <20160511091930.GE14744@quack2.suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <20160506203308.GA12506@linux.intel.com>
 <20160509093828.GF11897@quack2.suse.cz>
 <20160510152814.GQ11897@quack2.suse.cz>
 <20160510203003.GA5314@linux.intel.com>
 <20160510223937.GA10222@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org,
	Matthew Wilcox <willy@linux.intel.com>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160510223937.GA10222@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 10-05-16 16:39:37, Ross Zwisler wrote:
> On Tue, May 10, 2016 at 02:30:03PM -0600, Ross Zwisler wrote:
> > On Tue, May 10, 2016 at 05:28:14PM +0200, Jan Kara wrote:
> > > On Mon 09-05-16 11:38:28, Jan Kara wrote:
> > > Somehow, I'm not able to reproduce the warnings... Anyway, I think I see
> > > what's going on. Can you check whether the warning goes away when you
> > > change the condition at the end of page_cache_tree_delete() to:
> > > 
> > >         if (!dax_mapping(mapping) && !workingset_node_pages(node) &&
> > >             list_empty(&node->private_list)) {
> > 
> > Yep, this took care of both of the issues that I reported.  I'll restart my
> > testing with this in my baseline, but as of this fix I don't have any more
> > open testing issues. :)
> 
> Well, looks like I spoke too soon.  The two tests that were failing for me are
> now passing, but I can still create what looks like a related failure using
> XFS, DAX, and the two xfstests generic/231 and generic/232 run back-to-back.

Hum, full xfstests run completes for me just fine. Can you reproduce the
issue with the attached debug patch? Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--LQksG6bCIzRHxTLp
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Debugging-workingset.patch"

>From 8f01c60e8be5d5671b09b07a5fb647177e33293d Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 11 May 2016 11:14:11 +0200
Subject: [PATCH] Debugging workingset

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/workingset.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 8a75f8d2916a..b692fc756fda 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -12,6 +12,7 @@
 #include <linux/swap.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/dax.h>
 
 /*
  *		Double CLOCK lists
@@ -402,6 +403,7 @@ static enum lru_status shadow_lru_isolate(struct list_head *item,
 
 	node = container_of(item, struct radix_tree_node, private_list);
 	mapping = node->private_data;
+	WARN_ON(dax_mapping(mapping));
 
 	/* Coming from the list, invert the lock order */
 	if (!spin_trylock(&mapping->tree_lock)) {
@@ -418,7 +420,18 @@ static enum lru_status shadow_lru_isolate(struct list_head *item,
 	 * no pages, so we expect to be able to remove them all and
 	 * delete and free the empty node afterwards.
 	 */
-
+	if (!node->count || (node->count & RADIX_TREE_COUNT_MASK)) {
+		printk(KERN_ERR "Wrong node->count %u.\n", node->count);
+		if (!mapping->host) {
+			printk(KERN_ERR "Node mapping has no host!\n");
+		} else {
+			printk(KERN_ERR "Host sb %s ino %lu\n", mapping->host->i_sb->s_id, mapping->host->i_ino);
+		}
+		printk(KERN_ERR "Node dump:");
+		for (i = 0; i < RADIX_TREE_MAP_SIZE; i++)
+			printk(KERN_CONT " %lx", (unsigned long)node->slots[i]);
+		printk(KERN_CONT "\n");
+	}
 	BUG_ON(!node->count);
 	BUG_ON(node->count & RADIX_TREE_COUNT_MASK);
 
-- 
2.6.6


--LQksG6bCIzRHxTLp--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
