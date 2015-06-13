From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4 crypto: prevent mount when blocksize != pagesize
Date: Fri, 12 Jun 2015 23:45:46 -0400
Message-ID: <20150613034546.GN24181@thunk.org>
References: <1434035567-12651-1-git-send-email-waydi1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Seunghun Lee <waydi1@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434035567-12651-1-git-send-email-waydi1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 12, 2015 at 12:12:47AM +0900, Seunghun Lee wrote:
> Encryption mode is unsupported when blocksize != pagesize.
> 
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>

This only checks for blocksize != pagesize in the case where the test
dummy encryption mount option is given.  We need to check also for the
case when the file system has the encryption feature set.  So this is
the better check.

						- Ted

commit 660947160c07e42b6c5def33a1977da09567ed55
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Jun 12 23:44:33 2015 -0400

    ext4 crypto: fail the mount if blocksize != pagesize
    
    We currently don't correctly handle the case where blocksize !=
    pagesize, so disallow the mount in those cases.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 31e85be..e13fe40 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4065,7 +4065,15 @@ no_journal:
 		}
 	}
 
-	if (unlikely(sbi->s_mount_flags & EXT4_MF_TEST_DUMMY_ENCRYPTION) &&
+	if ((DUMMY_ENCRYPTION_ENABLED(sbi) ||
+	     EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT)) &&
+	    (blocksize != PAGE_CACHE_SIZE)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Unsupported blocksize for fs encryption");
+		goto failed_mount_wq;
+	}
+
+	if (DUMMY_ENCRYPTION_ENABLED(sbi) &&
 	    !(sb->s_flags & MS_RDONLY) &&
 	    !EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT)) {
 		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT);
