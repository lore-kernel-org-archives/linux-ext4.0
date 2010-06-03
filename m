From: Nick Piggin <npiggin@suse.de>
Subject: [patch v3] fix truncate inode time modification breakage
Date: Thu, 3 Jun 2010 22:01:46 +1000
Message-ID: <20100603120146.GK6822@laptop>
References: <20100601133923.GT9453@laptop>
 <20100601134801.GA11061@lst.de>
 <20100601135655.GU9453@laptop>
 <20100602195538.GG6152@laptop>
 <E1OK5dA-00070W-0s@pomaz-ex.szeredi.hu>
 <20100603091434.GA6822@laptop>
 <E1OK6iv-0007EN-5J@pomaz-ex.szeredi.hu>
 <20100603100724.GE6822@laptop>
 <E1OK87y-0007RX-5Q@pomaz-ex.szeredi.hu>
 <20100603110914.GA14006@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Hugh Dickins <hughd@google.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100603110914.GA14006@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I think this should be the best way to fix 2.6.35. I'll look at what
it takes to completely direct truncate time/mode changes from the vfs
probably on top of Christophs latest truncate patchsets.

--

mtime and ctime should be changed only if the file size has actually
changed. Patches changing ext2 and tmpfs from vmtruncate to new truncate
sequence has caused regressions where they always update timestamps.

There is some strange cases in POSIX where truncate(2) must not update
times unless the size has acutally changed, see 6e656be89.

This area is all still rather buggy in different ways in a lot of
filesystems and needs a cleanup and audit (ideally the vfs will provide
a simple attribute or call to direct all filesystems exactly which
attributes to change). But coming up with the best solution will take a
while and is not appropriate for rc anyway.

So fix recent regression for now.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 fs/ext2/inode.c |    2 +-
 mm/shmem.c      |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c
+++ linux-2.6/mm/shmem.c
@@ -764,10 +764,11 @@ done2:
 static int shmem_notify_change(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
+	loff_t newsize = attr->ia_size;
 	int error;
 
-	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
-		loff_t newsize = attr->ia_size;
+	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)
+					&& newsize != inode->i_size) {
 		struct page *page = NULL;
 
 		if (newsize < inode->i_size) {
Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c
+++ linux-2.6/fs/ext2/inode.c
@@ -1552,7 +1552,7 @@ int ext2_setattr(struct dentry *dentry,
 		if (error)
 			return error;
 	}
-	if (iattr->ia_valid & ATTR_SIZE) {
+	if (iattr->ia_valid & ATTR_SIZE && iattr->ia_size != inode->i_size) {
 		error = ext2_setsize(inode, iattr->ia_size);
 		if (error)
 			return error;
