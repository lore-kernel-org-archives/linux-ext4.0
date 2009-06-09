From: Greg KH <gregkh@suse.de>
Subject: [patch 84/87] ext4: Fix sub-block zeroing for writes into preallocated extents
Date: Tue, 09 Jun 2009 02:40:12 -0700
Message-ID: <20090609094112.103140898@blue.kroah.org>
References: <20090609093848.204935043@blue.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:32894 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622AbZFIKWX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 06:22:23 -0400
Content-Disposition: inline; filename=ext4-fix-sub-block-zeroing-for-writes-into-preallocated-extents.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 9c1ee184a30394e54165fa4c15923cabd952c106)

We need to mark the buffer_head mapping preallocated space as new
during write_begin. Otherwise we don't zero out the page cache content
properly for a partial write. This will cause file corruption with
preallocation.

Now that we mark the buffer_head new we also need to have a valid
buffer_head blocknr so that unmap_underlying_metadata() unmaps the
correct block.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |    2 ++
 fs/ext4/inode.c   |    7 +++++++
 2 files changed, 9 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2776,6 +2776,8 @@ int ext4_ext_get_blocks(handle_t *handle
 				if (allocated > max_blocks)
 					allocated = max_blocks;
 				set_buffer_unwritten(bh_result);
+				bh_result->b_bdev = inode->i_sb->s_bdev;
+				bh_result->b_blocknr = newblock;
 				goto out2;
 			}
 
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2246,6 +2246,13 @@ static int ext4_da_get_block_prep(struct
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
+		/*
+		 * With sub-block writes into unwritten extents
+		 * we also need to mark the buffer as new so that
+		 * the unwritten parts of the buffer gets correctly zeroed.
+		 */
+		if (buffer_unwritten(bh_result))
+			set_buffer_new(bh_result);
 		ret = 0;
 	}
 


