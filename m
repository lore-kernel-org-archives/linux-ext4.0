From: Greg KH <gregkh@suse.de>
Subject: [patch 32/39] ext4: Init the complete page while building buddy
	cache
Date: Wed, 18 Feb 2009 13:33:14 -0800
Message-ID: <20090218213314.GG19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
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
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56372 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757270AbZBRVf6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:58 -0500
Content-Disposition: inline; filename="ext4-init-the-complete-page-while-building-buddy-cache.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 29eaf024980e07cc01f31ae4ea5d68c917f4b7da)

We need to init the complete page during buddy cache init
by setting the contents to '1'.  Otherwise we can see the
following errors after doing an online resize of the
filesystem:

EXT4-fs error (device sdb1): ext4_mb_mark_diskspace_used:
	Allocating block 1040385 in system zone of 127 group

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -846,6 +846,8 @@ static int ext4_mb_init_cache(struct pag
 
 	err = 0;
 	first_block = page->index * blocks_per_page;
+	/* init the page  */
+	memset(page_address(page), 0xff, PAGE_CACHE_SIZE);
 	for (i = 0; i < blocks_per_page; i++) {
 		int group;
 		struct ext4_group_info *grinfo;
@@ -872,7 +874,6 @@ static int ext4_mb_init_cache(struct pag
 			BUG_ON(incore == NULL);
 			mb_debug("put buddy for group %u in page %lu/%x\n",
 				group, page->index, i * blocksize);
-			memset(data, 0xff, blocksize);
 			grinfo = ext4_get_group_info(sb, group);
 			grinfo->bb_fragments = 0;
 			memset(grinfo->bb_counters, 0,

