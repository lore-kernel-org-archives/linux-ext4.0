From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 3/6][TAKE7] revalidate write permissions for fallocate
Date: Fri, 13 Jul 2007 18:18:47 +0530
Message-ID: <20070713124847.GC22961@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com,
	adilger@clusterfs.com, dgc@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070713123816.GA18000@amitarora.in.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: David P. Quigley <dpquigl@tycho.nsa.gov>

Revalidate the write permissions for fallocate(2), in case security policy has
changed since the files were opened.

Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>

---
 fs/open.c |    3 +++
 1 files changed, 3 insertions(+)

Index: linux-2.6.22/fs/open.c
===================================================================
--- linux-2.6.22.orig/fs/open.c
+++ linux-2.6.22/fs/open.c
@@ -407,6 +407,9 @@ asmlinkage long sys_fallocate(int fd, in
 		goto out;
 	if (!(file->f_mode & FMODE_WRITE))
 		goto out_fput;
+	ret = security_file_permission(file, MAY_WRITE);
+	if (ret)
+		goto out_fput;
 
 	inode = file->f_path.dentry->d_inode;
 
