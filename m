From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] btrfs: Prevent creation of files larger than RLIMIT_FSIZE using fallocate
Date: Tue, 4 May 2010 11:14:57 +0530
Message-ID: <201005041114.57957.knikanth@suse.de>
References: <201004281854.49730.knikanth@suse.de> <201005030953.45157.knikanth@suse.de> <20100503065945.GA13756@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>, coly.li@suse.de,
	Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0EDFnV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 May 2010 01:43:21 -0400
In-Reply-To: <20100503065945.GA13756@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Prevent creation of files larger than RLIMIT_FSIZE using fallocate.

Currently using posix_fallocate one can bypass an RLIMIT_FSIZE limit
and create a file larger than the limit. Add a check for that.


Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2bfdc64..a1d8fbc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5829,6 +5829,11 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	btrfs_wait_ordered_range(inode, alloc_start, alloc_end - alloc_start);
 
 	mutex_lock(&inode->i_mutex);
+
+	ret = inode_newsize_ok(inode, (offset + len));
+	if (ret)
+		goto out;
+
 	if (alloc_start > inode->i_size) {
 		ret = btrfs_cont_expand(inode, alloc_start);
 		if (ret)
