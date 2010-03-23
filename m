From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix up flex groups used_dirs manipulation
Date: Mon, 22 Mar 2010 22:34:33 -0500
Message-ID: <4BA836C9.1050104@redhat.com>
References: <20100323002123.GQ29604@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab0CWDek (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Mar 2010 23:34:40 -0400
In-Reply-To: <20100323002123.GQ29604@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Darrick J. Wong wrote:

...
> Unfortunately, this second behavior means that the "find the least full
> blockgroup" code can use stale data in its comparisons.  Am I correct that
> something is wrong here, or have I misinterpreted the code?  Is it /supposed/
> to be the case that used_dirs reflects the number of directories in the
> blockgroup at *mount time* and not at the current time?
>   
This does seem weird; the flex_group dir counters are indeed only updated
at mount time:

ext4_fill_super
        ext4_fill_flex_info
                atomic_add(ext4_used_dirs_count(sb, gdp),
                           &sbi->s_flex_groups[flex_group].used_dirs);

and yet it's read repeatedly in get_orlov_stats:

2 ialloc.c get_orlov_stats      430 stats->used_dirs = atomic_read(&flex_group[g].used_dirs);

I think this patch:

commit 7d39db14a42cbd719c7515b9da8f85a2eb6a0633
[PATCH] ext4: Use struct flex_groups to calculate get_orlov_stats()

"missed" a bit, maybe a cut and paste error:

 @@ -267,6 +267,13 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
                        if (is_directory) {
                                count = ext4_used_dirs_count(sb, gdp) - 1;
                                ext4_used_dirs_set(sb, gdp, count);
+                               if (sbi->s_log_groups_per_flex) {
+                                       ext4_group_t f;
+
+                                       f = ext4_flex_group(sbi, block_group);
+                                       atomic_dec(&sbi->s_flex_groups[f].free_inodes);
+                               }

why would we be decremeting free inodes in free_inode?  And then later
in the function we atomic_inc it again.  Very odd, and likely a thinko.

I think the following patch fixes it up, although it seems like we should
probably introduce (another) wrapper to set these counts in the gdp as
well as the flex groups if they are present, so we don't always have
to remember to manually hit both.

There also seems to be some inconsistency about when we update the flex
grp vs the group descriptor, but I may be reading things wrong; ext4_new_inode
decrements the flex group free inode count, but ext4_claim_inode decrements
the gdp free inode count?  I may be missing something there.

Anyway - does this make things behave more as expected?

-------- patch follows ----------

When used_dirs was introduced for the flex_groups struct, it looks
like the accounting was not put into place properly, in some places
manipulating free_inodes rather than used_dirs.


Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f3624ea..3a5c7ec 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -268,7 +268,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 					ext4_group_t f;
 
 					f = ext4_flex_group(sbi, block_group);
-					atomic_dec(&sbi->s_flex_groups[f].free_inodes);
+					atomic_dec(&sbi->s_flex_groups[f].used_dirs);
 				}
 
 			}
@@ -779,7 +779,7 @@ static int ext4_claim_inode(struct super_block *sb,
 		if (sbi->s_log_groups_per_flex) {
 			ext4_group_t f = ext4_flex_group(sbi, group);
 
-			atomic_inc(&sbi->s_flex_groups[f].free_inodes);
+			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
 		}
 	}

 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);

