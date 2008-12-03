From: Greg KH <gregkh@suse.de>
Subject: [patch 089/104] ext4: fix xattr deadlock
Date: Wed, 3 Dec 2008 11:56:26 -0800
Message-ID: <20081203195626.GL8950@kroah.com>
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
	alan@lxorguk.ukuu.org.uk, Kalpak Shah <kalpak.shah@sun.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56667 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756102AbYLCT5y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:54 -0500
Content-Disposition: inline; filename="ext4-fix-xattr-deadlock.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kalpak Shah <kalpak.shah@sun.com>

(cherry picked from commit 4d20c685fa365766a8f13584b4c8178a15ab7103)

ext4_xattr_set_handle() eventually ends up calling
ext4_mark_inode_dirty() which tries to expand the inode by shifting
the EAs.  This leads to the xattr_sem being downed again and leading
to a deadlock.

This patch makes sure that if ext4_xattr_set_handle() is in the
call-chain, ext4_mark_inode_dirty() will not expand the inode.

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/xattr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -959,6 +959,7 @@ ext4_xattr_set_handle(handle_t *handle, 
 	struct ext4_xattr_block_find bs = {
 		.s = { .not_found = -ENODATA, },
 	};
+	unsigned long no_expand;
 	int error;
 
 	if (!name)
@@ -966,6 +967,9 @@ ext4_xattr_set_handle(handle_t *handle, 
 	if (strlen(name) > 255)
 		return -ERANGE;
 	down_write(&EXT4_I(inode)->xattr_sem);
+	no_expand = EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND;
+	EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
+
 	error = ext4_get_inode_loc(inode, &is.iloc);
 	if (error)
 		goto cleanup;
@@ -1042,6 +1046,8 @@ ext4_xattr_set_handle(handle_t *handle, 
 cleanup:
 	brelse(is.iloc.bh);
 	brelse(bs.bh);
+	if (no_expand == 0)
+		EXT4_I(inode)->i_state &= ~EXT4_STATE_NO_EXPAND;
 	up_write(&EXT4_I(inode)->xattr_sem);
 	return error;
 }

