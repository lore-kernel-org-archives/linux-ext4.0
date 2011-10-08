From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/28] ext4: Prevent stack overrun in ext4_file_open when
	recording last known mountpoint
Date: Sat, 08 Oct 2011 00:54:10 -0700
Message-ID: <20111008075410.20506.47923.stgit@elm3c44.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In ext4_file_open, the filesystem records the mountpoint of the first file that
is opened after mounting the filesystem.  It does this by allocating a 64-byte
stack buffer, calling d_path() to grab the mount point through which this file
was accessed, and then memcpy()ing 64 bytes into the superblock's
s_last_mounted field, starting from the return value of d_path(), which is
stored as "cp".  However, if cp > buf (which it frequently is since path
components are prepended starting at the end of buf) then we can end up copying
stack data into the superblock.

Writing stack variables into the superblock doesn't sound like a great idea, so
use strlcpy instead.  Andi Kleen suggested using strlcpy instead of strncpy.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index e4095e9..9781099 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -181,8 +181,8 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		path.dentry = mnt->mnt_root;
 		cp = d_path(&path, buf, sizeof(buf));
 		if (!IS_ERR(cp)) {
-			memcpy(sbi->s_es->s_last_mounted, cp,
-			       sizeof(sbi->s_es->s_last_mounted));
+			strlcpy(sbi->s_es->s_last_mounted, cp,
+				sizeof(sbi->s_es->s_last_mounted));
 			ext4_mark_super_dirty(sb);
 		}
 	}
