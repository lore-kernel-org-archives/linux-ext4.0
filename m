From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] vfs: avoid hang caused by attempting to rmdir an invalid file system
Date: Mon, 28 May 2012 13:34:05 -0400
Message-ID: <1338226445-8911-1-git-send-email-tytso@mit.edu>
References: <20120528173133.GA31109@thunk.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, sami.liedes@iki.fi,
	Theodore Ts'o <tytso@mit.edu>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120528173133.GA31109@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If we rmdir a directory which is a hard link to '.', we will deadlock
trying to grab the directory's i_mutex.  Check for this condition and
return EINVAL, which is what we return if the user attempts to rmdir
"/foo/bar/."

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/namei.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 0062dd1..081f872 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2774,6 +2774,17 @@ static long do_rmdir(int dfd, const char __user *pathname)
 		error = -ENOENT;
 		goto exit3;
 	}
+	if (nd.path.dentry->d_inode == dentry->d_inode) {
+		/*
+		 * Corrupt file system where there is a symlink to
+		 * '.'; treat it as if we are trying to rmdir '.'
+		 *
+		 * XXX Should we call into the low-level file system
+		 * to request that the file system be marked corrupt?
+		 */
+		error = -EINVAL;
+		goto exit3;
+	}
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
-- 
1.7.10.2.552.gaa3bb87

