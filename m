From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 17/41] ext2 convert to new aops.
Date: Wed, 16 May 2007 14:45:05 +0200
Message-ID: <20070516124505.GA29668@wotan.suse.de>
References: <20070514060619.689648000@wotan.suse.de> <20070514060652.572496000@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070514060652.572496000@wotan.suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 14, 2007 at 04:06:36PM +1000, npiggin@suse.de wrote:
> Cc: linux-ext4@vger.kernel.org
> Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Found a problem in ext2 pagecache directory handling. Trivial fix follows.
Longer-term, it might be better to rework these things a bit so they can
directly use the pagecache_write_begin/pagecache_write_end accessors.
---
Index: linux-2.6/fs/ext2/dir.c
===================================================================
--- linux-2.6.orig/fs/ext2/dir.c
+++ linux-2.6/fs/ext2/dir.c
@@ -70,10 +70,18 @@ static int ext2_commit_chunk(struct page
 
 	dir->i_version++;
 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
+
+	if (pos+len > dir->i_size) {
+		i_size_write(dir, pos+len);
+		mark_inode_dirty(dir);
+	}
+
 	if (IS_DIRSYNC(dir))
 		err = write_one_page(page, 1);
 	else
 		unlock_page(page);
+	mark_page_accessed(page);
+
 	return err;
 }
 
