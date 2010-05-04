From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] ext4: Prevent creation of files larger than RLIMIT_FSIZE using fallocate
Date: Tue, 4 May 2010 11:15:04 +0530
Message-ID: <201005041115.04400.knikanth@suse.de>
References: <201004281854.49730.knikanth@suse.de> <201005030953.45157.knikanth@suse.de> <20100503065945.GA13756@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>, coly.li@suse.de,
	Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>,
	Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab0EDFnY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 May 2010 01:43:24 -0400
In-Reply-To: <20100503065945.GA13756@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I assumed that Amit would send a patch with s-o-b, if not, please take
this patch.

Thanks
Nikanth

Prevent creation of files larger than RLIMIT_FSIZE using fallocate.

Currently using posix_fallocate one can bypass an RLIMIT_FSIZE limit
and create a file larger than the limit. Add a check for that.


Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 236b834..39b8123 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3672,6 +3672,11 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	 */
 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
 	mutex_lock(&inode->i_mutex);
+	ret = inode_newsize_ok(inode, (len + offset));
+	if (ret) {
+		mutex_unlock(&inode->i_mutex);
+		return ret;
+	}
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		block = block + ret;
