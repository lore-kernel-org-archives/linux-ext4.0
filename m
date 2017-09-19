From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: [PATCH] VFS: Handle lazytime in do_mount()
Date: Tue, 19 Sep 2017 12:18:19 +0200
Message-ID: <20170919101819.GA233@x4>
References: <20170918192644.GA232@x4>
 <20170919083506.GA233@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170919083506.GA233@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The lazytime option didn't get passed on when using current util-linux,
which passes MS_LAZYTIME in the mountflags directly.

Fix the issue by handling the option in do_mount().

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 54059b142d6b..b633838b8f02 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2823,7 +2823,8 @@ long do_mount(const char *dev_name, const char __user *dir_name,
 			    SB_MANDLOCK |
 			    SB_DIRSYNC |
 			    SB_SILENT |
-			    SB_POSIXACL);
+			    SB_POSIXACL |
+			    MS_LAZYTIME);
 
 	if (flags & MS_REMOUNT)
 		retval = do_remount(&path, flags, sb_flags, mnt_flags,
-- 
Markus
