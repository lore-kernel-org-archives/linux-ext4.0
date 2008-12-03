From: Greg KH <gregkh@suse.de>
Subject: [patch 097/104] ext4: Mark the buffer_heads as dirty and uptodate
	after prepare_write
Date: Wed, 3 Dec 2008 11:56:44 -0800
Message-ID: <20081203195644.GT8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
	alan@lxorguk.ukuu.org.uk,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56779 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754442AbYLCT6E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:58:04 -0500
Content-Disposition: inline; filename="ext4-mark-the-buffer_heads-as-dirty-and-uptodate-after-prepare_write.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit ed9b3e3379731e9f9d2f73f3d7fd9e7d2ce3df4a)

We need to make sure we mark the buffer_heads as dirty and uptodate
so that block_write_full_page write them correctly.

This fixes mmap corruptions that can occur in low memory situations.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2242,6 +2242,8 @@ static int ext4_da_writepage(struct page
 			unlock_page(page);
 			return 0;
 		}
+		/* now mark the buffer_heads as dirty and uptodate */
+		block_commit_write(page, 0, PAGE_CACHE_SIZE);
 	}
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))

