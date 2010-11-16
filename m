From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] ext3: Return error code from generic_check_addressable
Date: Tue, 16 Nov 2010 14:57:44 -0800
Message-ID: <20101116225744.GD18195@tux1.beaverton.ibm.com>
References: <20101115214831.GA18195@tux1.beaverton.ibm.com> <4CE1AC38.9040201@redhat.com> <20101115230346.GB18195@tux1.beaverton.ibm.com> <alpine.LFD.2.00.1011161351230.5515@dhcp-lab-213.englab.brq.redhat.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"Patrick J. LoPresti" <lopresti@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49243 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab0KPW5q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 17:57:46 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011161351230.5515@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext3: Return error code from generic_check_accessible

ext3_fill_super should return the error code that generic_check_accessible
returns when an error condition occurs.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext3/super.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 2fedaf8..960629b 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1842,13 +1842,15 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	if (generic_check_addressable(sb->s_blocksize_bits,
-				      le32_to_cpu(es->s_blocks_count))) {
+	err = generic_check_addressable(sb->s_blocksize_bits,
+					le32_to_cpu(es->s_blocks_count));
+	if (err) {
 		ext3_msg(sb, KERN_ERR,
 			"error: filesystem is too large to mount safely");
 		if (sizeof(sector_t) < 8)
 			ext3_msg(sb, KERN_ERR,
 				"error: CONFIG_LBDAF not enabled");
+		ret = err;
 		goto failed_mount;
 	}
 
