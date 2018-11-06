Return-Path: <SRS0=hSPz=NR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46204 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbeKGHqd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 02:46:33 -0500
Date: Tue, 6 Nov 2018 17:19:05 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/11] ext4: iloc.bh cleanup in add_new_gdb()
Message-ID: <20181106221905.GH2570@thunk.org>
References: <cover.1540935522.git.vvs@virtuozzo.com>
 <eb58c8ca-8456-7b5f-9c12-99f03e3057af@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb58c8ca-8456-7b5f-9c12-99f03e3057af@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 12:58:38AM +0300, Vasily Averin wrote:
> iloc.bh was taken in ext4_reserve_inode_write() and released
> in ext4_mark_iloc_dirty(). It should not be released 2nd time
> in rollback after failed ext4_handle_dirty_metadata(gdb_bh)
> 
> Fixes b40971426a83 ("ext4: add error checking to calls to ...") # 2.6.38
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

I fixed this in a simpler way:

>From 6a91a2eb1c5af1381caebfb4c1c91dc175351f6f Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 6 Nov 2018 17:18:17 -0500
Subject: [PATCH] ext4: avoid possible double brelse() in add_new_gdb() on
 error path

Fixes: b40971426a83 ("ext4: add error checking to calls to ...")
Reported-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org # 2.6.38
---
 fs/ext4/resize.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 85158e9de7c2..a5efee34415f 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -871,6 +871,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
 	if (unlikely(err)) {
 		ext4_std_error(sb, err);
+		iloc.bh = NULL;
 		goto exit_inode;
 	}
 	brelse(dind);
-- 
2.18.0.rc0
