From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 11/17] richacl: Check if an acl is equivalent to a file
	mode
Date: Thu, 29 Jul 2010 23:27:49 +0530
Message-ID: <1280426275-4602-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1280426275-4602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de, adilger@sun.com,
	sandeen@redhat.com, tytso@mit.edu, bfields@citi.umich.edu,
	jlayton@redhat.com
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <1280426275-4602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/options/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

This function is used to avoid storing richacls on disk if the acl can
be computed from the file permission bits.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/richacl_base.c       |   54 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |    1 +
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 6074116..5afdc5a 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -541,3 +541,57 @@ richacl_inherit(const struct richacl *dir_acl, int isdir)
 
 	return acl;
 }
+
+/**
+ * richacl_equiv_mode  -  check if @acl is equivalent to file permission bits
+ * @mode_p:	the file mode (including the file type)
+ *
+ * If @acl can be fully represented by file permission bits, this function
+ * returns 0, and the file permission bits in @mode_p are set to the equivalent
+ * of @acl.
+ *
+ * This function is used to avoid storing richacls on disk if the acl can be
+ * computed from the file permission bits.  It allows user-space to make sure
+ * that a file has no explicit richacl set.
+ */
+int
+richacl_equiv_mode(const struct richacl *acl, mode_t *mode_p)
+{
+	const struct richace *ace = acl->a_entries;
+	unsigned int x;
+	mode_t mode;
+
+	if (acl->a_count != 1 ||
+	    acl->a_flags != ACL4_MASKED ||
+	    !richace_is_everyone(ace) ||
+	    !richace_is_allow(ace) ||
+	    ace->e_flags & ~ACE4_SPECIAL_WHO)
+		return -1;
+
+	/*
+	 * Figure out the permissions we care about: ACE4_DELETE_CHILD is
+	 * meaningless for non-directories, so we ignore it.
+	 */
+	x = ~ACE4_POSIX_ALWAYS_ALLOWED;
+	if (!S_ISDIR(*mode_p))
+		x &= ~ACE4_DELETE_CHILD;
+
+	mode = richacl_masks_to_mode(acl);
+	if ((acl->a_group_mask & x) != (richacl_mode_to_mask(mode >> 3) & x) ||
+	    (acl->a_other_mask & x) != (richacl_mode_to_mask(mode) & x))
+		return -1;
+
+	/*
+	 * Ignore permissions which the owner is always allowed.
+	 */
+	x &= ~ACE4_POSIX_OWNER_ALLOWED;
+	if ((acl->a_owner_mask & x) != (richacl_mode_to_mask(mode >> 6) & x))
+		return -1;
+
+	if ((ace->e_mask & x) != (ACE4_POSIX_MODE_ALL & x))
+		return -1;
+
+	*mode_p = (*mode_p & ~S_IRWXUGO) | mode;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(richacl_equiv_mode);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 05d2319..6151770 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -292,6 +292,7 @@ extern struct richacl *richacl_chmod(struct richacl *, mode_t);
 extern int richacl_permission(struct inode *, const struct richacl *,
 			      unsigned int);
 extern struct richacl *richacl_inherit(const struct richacl *, int);
+extern int richacl_equiv_mode(const struct richacl *, mode_t *);
 
 /* richacl_inode.c */
 
-- 
1.7.0.4

_______________________________________________
NOTE: THIS LIST IS DEPRECATED.  Please use linux-nfs@vger.kernel.org instead.
(To subscribe to linux-nfs@vger.kernel.org: send "subscribe linux-nfs" in the body of a message to majordomo@vger.kernel.org.)

NFSv4 mailing list
NFSv4@linux-nfs.org
http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
