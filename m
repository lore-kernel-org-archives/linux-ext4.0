From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] [PATCH] ext4: avoid calculating free inodes twice
 in find_group_orlov()
Date: Wed, 28 Dec 2011 19:10:34 -0500
Message-ID: <20111229001034.GH12370@thunk.org>
References: <1321514425-14937-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37305 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab1L2AKi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 19:10:38 -0500
Content-Disposition: inline
In-Reply-To: <1321514425-14937-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 17, 2011 at 03:20:25PM +0800, Zheng Liu wrote:
> ext4_free_inodes_count() shouldn't be called twice in here
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/ialloc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 00beb4f..1d81bfc 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -477,8 +477,7 @@ fallback_retry:
>  	for (i = 0; i < ngroups; i++) {
>  		grp = (parent_group + i) % ngroups;
>  		desc = ext4_get_group_desc(sb, grp, NULL);
> -		if (desc && ext4_free_inodes_count(sb, desc) &&
> -		    ext4_free_inodes_count(sb, desc) >= avefreei) {
> +		if (desc && ext4_free_inodes_count(sb, desc) >= avefreei) {

This change isn't safe, since avefreei could be zero, and we must not
return a group which has zero free inodes.

I've rewritten this patch (see below).

						- Ted

commit 045662c7c44c7d2e39bb70695b3a11812dbc2a95
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Dec 28 19:10:12 2011 -0500

    ext4: avoid counting the number of free inodes twice in find_group_orlov()
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 8fb6844..bbdedca 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -358,7 +358,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t real_ngroups = ext4_get_groups_count(sb);
 	int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
-	unsigned int freei, avefreei;
+	unsigned int freei, avefreei, grpfree;
 	ext4_fsblk_t freeb, avefreec;
 	unsigned int ndirs;
 	int max_dirs, min_inodes;
@@ -477,8 +477,8 @@ fallback_retry:
 	for (i = 0; i < ngroups; i++) {
 		grp = (parent_group + i) % ngroups;
 		desc = ext4_get_group_desc(sb, grp, NULL);
-		if (desc && ext4_free_inodes_count(sb, desc) &&
-		    ext4_free_inodes_count(sb, desc) >= avefreei) {
+		grp_free = ext4_free_inodes_count(sb, desc);
+		if (desc && grp_free && grp_free >= avefreei) {
 			*group = grp;
 			return 0;
 		}
     	       	    
