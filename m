From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -next] ext4: fix printk format warning in page-io
Date: Tue, 01 Nov 2011 16:32:25 -0700
Message-ID: <4EB08189.2@xenotime.net>
References: <20111101205323.c12f2f940f23febba8ab8989@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linus <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20111101205323.c12f2f940f23febba8ab8989@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning:

fs/ext4/page-io.c:108:5: warning: format '%d' expects type 'int', but argument 6 has type 'ssize_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	"Theodore Ts'o" <tytso@mit.edu>
Cc:	Andreas Dilger <adilger.kernel@dilger.ca>
Cc:	linux-ext4@vger.kernel.org
---
 fs/ext4/page-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-2011-1101.orig/fs/ext4/page-io.c
+++ next-2011-1101/fs/ext4/page-io.c
@@ -104,7 +104,7 @@ int ext4_end_io_nolock(ext4_io_end_t *io
 		ext4_msg(inode->i_sb, KERN_EMERG,
 			 "failed to convert unwritten extents to written "
 			 "extents -- potential data loss!  "
-			 "(inode %lu, offset %llu, size %d, error %d)",
+			 "(inode %lu, offset %llu, size %zd, error %d)",
 			 inode->i_ino, offset, size, ret);
 	}
 
