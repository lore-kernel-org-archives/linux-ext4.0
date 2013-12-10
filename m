From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/9] Use %pd in Ext4
Date: Tue, 10 Dec 2013 15:26:55 +0000
Message-ID: <20131210152655.4916.77232.stgit@warthog.procyon.org.uk>
References: <20131210152612.4916.80435.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-fsdevel@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20131210152612.4916.80435.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use the new %pd printk() specifier in Ext4 to replace passing of dentry name or
dentry name and name length * 2 with just passing the dentry.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "Theodore Ts'o" <tytso@mit.edu>
cc: Andreas Dilger <adilger.kernel@dilger.ca>
cc: linux-ext4@vger.kernel.org
---

 fs/ext4/namei.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5a0408d7b114..3e9e70663233 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1425,9 +1425,8 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 			return ERR_PTR(-EIO);
 		}
 		if (unlikely(ino == dir->i_ino)) {
-			EXT4_ERROR_INODE(dir, "'%.*s' linked to parent dir",
-					 dentry->d_name.len,
-					 dentry->d_name.name);
+			EXT4_ERROR_INODE(dir, "'%pd' linked to parent dir",
+					 dentry);
 			return ERR_PTR(-EIO);
 		}
 		inode = ext4_iget(dir->i_sb, ino);

