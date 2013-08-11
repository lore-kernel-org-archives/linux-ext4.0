From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: the list debug reports about corruptions
Date: Sun, 11 Aug 2013 02:03:38 -0400
Message-ID: <20130811060338.GA19297@thunk.org>
References: <CANaxB-yikOkwFLtMDJjUyOm6MQPyCr6P+awhp9eZdFL_9vw4ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-next@vger.kernel.org, Glauber Costa <glommer@openvz.org>
To: Andrey Vagin <avagin@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42170 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab3HKGDm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Aug 2013 02:03:42 -0400
Content-Disposition: inline
In-Reply-To: <CANaxB-yikOkwFLtMDJjUyOm6MQPyCr6P+awhp9eZdFL_9vw4ag@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 08, 2013 at 01:45:52PM +0400, Andrey Vagin wrote:
> Hello,
> 
> I use akpm branch of linux-next
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/?h=akpm&id=05abc43724793827835728f4f25ba827e1c54902
> .
> This bug is reproduced, when I do the following sequence of commands:
> 
> mkdir /sys/fs/cgroup/memory/xxx
> echo 1024000000 >  /sys/fs/cgroup/memory/xxx/memory.kmem.limit_in_bytes
> echo $$ > /sys/fs/cgroup/memory/xxx/tasks
> find /proc -name abra-kadabra
> echo $$ > /sys/fs/cgroup/memory/tasks
> rmdir /sys/fs/cgroup/memory/xxx/
> echo 3 > /proc/sys/vm/drop_caches

Thanks for reporting this.  I believe I have this fixed in the updated
dev branch for the ext4 tree.  The relevant fix is additition of the
INIT_LIST_HEAD(&skipped) below.  The rest is just a spelling fix up I
made along the way.

    	       	   	       	   	    	- Ted

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 00e6589..0e88a36 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -946,7 +946,7 @@ static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 {
 	struct ext4_inode_info *ei;
 	struct list_head *cur, *tmp;
-	LIST_HEAD(skiped);
+	LIST_HEAD(skipped);
 	int ret, nr_shrunk = 0;
 	int retried = 0, skip_precached = 1, nr_skipped = 0;
 
@@ -972,7 +972,7 @@ retry:
 		    (skip_precached && ext4_test_inode_state(&ei->vfs_inode,
 						EXT4_STATE_EXT_PRECACHED))) {
 			nr_skipped++;
-			list_move_tail(cur, &skiped);
+			list_move_tail(cur, &skipped);
 			continue;
 		}
 
@@ -992,7 +992,8 @@ retry:
 	}
 
 	/* Move the newer inodes into the tail of the LRU list. */
-	list_splice_tail(&skiped, &sbi->s_es_lru);
+	list_splice_tail(&skipped, &sbi->s_es_lru);
+	INIT_LIST_HEAD(&skipped);
 
 	/*
 	 * If we skipped any inodes, and we weren't able to make any
