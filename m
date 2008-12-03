From: Greg KH <gregkh@suse.de>
Subject: [patch 082/104] ext4: add missing unlock in
	ext4_check_descriptors() on error path
Date: Wed, 3 Dec 2008 11:56:10 -0800
Message-ID: <20081203195610.GE8950@kroah.com>
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
	Li Zefan <lizf@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754112AbYLCT5o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:44 -0500
Content-Disposition: inline; filename="ext4-add-missing-unlock-in-ext4_check_descriptors-on-error-path.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Li Zefan <lizf@cn.fujitsu.com>

(cherry picked from commit 7ee1ec4ca30c6df8e989615cdaacb75f2af4fa6b)

If there group descriptors are corrupted we need unlock the block
group lock before returning from the function; else we will oops when
freeing a spinlock which is still being held.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1626,8 +1626,10 @@ static int ext4_check_descriptors(struct
 			       "Checksum for group %lu failed (%u!=%u)\n",
 			       i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
 			       gdp)), le16_to_cpu(gdp->bg_checksum));
-			if (!(sb->s_flags & MS_RDONLY))
+			if (!(sb->s_flags & MS_RDONLY)) {
+				spin_unlock(sb_bgl_lock(sbi, i));
 				return 0;
+			}
 		}
 		spin_unlock(sb_bgl_lock(sbi, i));
 		if (!flexbg_flag)

