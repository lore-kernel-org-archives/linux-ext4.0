From: Greg KH <gregkh@suse.de>
Subject: [patch 18/39] ext4: avoid ext4_error when mounting a fs with a
	single bg
Date: Wed, 18 Feb 2009 13:32:47 -0800
Message-ID: <20090218213247.GS19814@kroah.com>
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
Received: from kroah.org ([198.145.64.141]:56240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756860AbZBRVfo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:44 -0500
Content-Disposition: inline; filename="ext4-avoid-ext4_error-when-mounting-a-fs-with-a-single-bg.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 565a9617b2151e21b22700e97a8b04e70e103153)

Remove some completely unneeded code which which caused an ext4_error
to be generated when mounting a file system with only a single block
group.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1445,7 +1445,6 @@ static int ext4_fill_flex_info(struct su
 	ext4_group_t flex_group_count;
 	ext4_group_t flex_group;
 	int groups_per_flex = 0;
-	__u64 block_bitmap = 0;
 	int i;
 
 	if (!sbi->s_es->s_log_groups_per_flex) {
@@ -1468,9 +1467,6 @@ static int ext4_fill_flex_info(struct su
 		goto failed;
 	}
 
-	gdp = ext4_get_group_desc(sb, 1, &bh);
-	block_bitmap = ext4_block_bitmap(sb, gdp) - 1;
