From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: [PATCH] VFS: Handle lazytime in do_mount()
Date: Wed, 11 Oct 2017 07:01:31 +0200
Message-ID: <20171011050131.GB13028@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since commit e462ec50cb5fa ("VFS: Differentiate mount flags (MS_*) from
internal superblock flags") the lazytime mount option doesn't get passed
on anymore.

Fix the issue by handling the option in do_mount().

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
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
+			    SB_LAZYTIME);
 
 	if (flags & MS_REMOUNT)
 		retval = do_remount(&path, flags, sb_flags, mnt_flags,
-- 
Markus
