From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix the incorrect info of /proc/mounts after
 mount no-journal fs
Date: Sun, 22 May 2011 16:12:20 -0400
Message-ID: <20110522201220.GA10009@thunk.org>
References: <1305771094-2976-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47381 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1EVUMY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2011 16:12:24 -0400
Content-Disposition: inline
In-Reply-To: <1305771094-2976-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 19, 2011 at 10:11:34AM +0800, Robin Dong wrote:
> After mkfs without journal:
> 
>   # mkfs.ext4 -O ^has_journal /dev/sda
>   # mount -t ext4 /dev/sda /test
> 
> the /proc/mounts will show:
> "/dev/sda /test ext4 rw,relatime,user_xattr,acl,barrier=1,data=writeback 0 0"
> which usually make users think the fs is using writeback-mode.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

It's actually better to simply always not set WRITEBACK_DATA() if we
are not journaling (either because of a noload mount option or because
the file systme doesn't have a journal).

						- Ted

commit d0e5cab82ecbe5578d3d17b90ba3515918ea0b9f
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun May 22 16:10:01 2011 -0400

    ext4: don't show mount options in /proc/mounts if there is no journal
    
    After creating an ext4 file system without a journal:
    
      # mke2fs -t ext4 -O ^has_journal /dev/sda
      # mount -t ext4 /dev/sda /test
    
    the /proc/mounts will show:
    "/dev/sda /test ext4 rw,relatime,user_xattr,acl,barrier=1,data=writeback 0 0"
    which can fool users into thinking that the fs is using writeback mode.
    
    So don't set the writeback option when the journal has not been
    enabled; we don't depend on the writeback option being set, since
    ext4_should_writeback_data() in ext4_jbd2.h tests to see if the
    journal is not present before returning true.
    
    Reported-by: Robin Dong <sanbai@taobao.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ed5e80e..fdce4ee 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3485,7 +3485,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount_wq;
 	} else {
 		clear_opt(sb, DATA_FLAGS);
-		set_opt(sb, WRITEBACK_DATA);
 		sbi->s_journal = NULL;
 		needs_recovery = 0;
 		goto no_journal;
