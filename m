From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: ext4_fill_super shouldn't return 0 on
 corruption
Date: Fri, 19 Nov 2010 09:59:37 -0500
Message-ID: <20101119145936.GD10039@thunk.org>
References: <20101115214831.GA18195@tux1.beaverton.ibm.com>
 <4CE1AC38.9040201@redhat.com>
 <20101115230346.GB18195@tux1.beaverton.ibm.com>
 <alpine.LFD.2.00.1011161351230.5515@dhcp-lab-213.englab.brq.redhat.com>
 <20101116225538.GC18195@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"Patrick J. LoPresti" <lopresti@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56228 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab0KSPlX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 10:41:23 -0500
Content-Disposition: inline
In-Reply-To: <20101116225538.GC18195@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 16, 2010 at 02:55:38PM -0800, Darrick J. Wong wrote:
> > the untested diff below seems like a more general solution to me,
> > since it allows to return the actual error from
> > generic_check_addressable().
> 
> It seems to work ok for me, so:
> 
> Acked-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> I will make the same change to ext3.

OK, this is what I've added to the ext4 patch queue

---
ext4: ext4_fill_super shouldn't return 0 on corruption

From: "Darrick J. Wong" <djwong@us.ibm.com>

At the start of ext4_fill_super, ret is set to -EINVAL, and any
failure path out of that function returns ret.  However, the
generic_check_addressable clause sets ret = 0 (if it passes), which
means that a subsequent failure (e.g.  a group checksum error) returns
0 even though the mount should fail.  This causes vfs_kern_mount in
turn to think that the mount succeeded, leading to an oops.

A simple fix is to avoid using ret for the generic_check_addressable
check, which was last changed in commit 30ca22c70e3.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 61182fe..3d89b72 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3268,13 +3268,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * Test whether we have more sectors than will fit in sector_t,
 	 * and whether the max offset is addressable by the page cache.
 	 */
-	ret = generic_check_addressable(sb->s_blocksize_bits,
+	err = generic_check_addressable(sb->s_blocksize_bits,
 					ext4_blocks_count(es));
-	if (ret) {
+	if (err) {
 		ext4_msg(sb, KERN_ERR, "filesystem"
 			 " too large to mount safely on this system");
 		if (sizeof(sector_t) < 8)
 			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
+		ret = err;
 		goto failed_mount;
 	}
 

