From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2 2/4] ext4: Add generic writepage callback
Date: Thu, 4 Jun 2009 09:20:51 -0400
Message-ID: <20090604132051.GH21314@mit.edu>
References: <1244095805-17015-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1244095805-17015-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50395 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbZFDNUw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2009 09:20:52 -0400
Content-Disposition: inline
In-Reply-To: <1244095805-17015-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've applied this to the ext4 patch queue with the following changelog
comment.

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

ext4: Fix mmap/truncate race when blocksize < pagesize && !nodellaoc

This patch fixes the mmap/truncate race that was fixed for delayed
allocation by merging ext4_{journalled,normal,da}_writepage() into
ext4_writepage().

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I also had to apply the following fix so that the patch would compile:

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1359aa1..24c8634 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -44,6 +44,10 @@
 
 #define MPAGE_DA_EXTENT_TAIL 0x01
 
+static int __ext4_journalled_writepage(struct page *page,
+				       struct writeback_control *wbc,
+				       unsigned int len);
+
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
 					      loff_t new_size)
 {


						- Ted
