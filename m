From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH (RESEND)] don't scan/accumulate more pages than mballoc will
 allocate
Date: Mon, 29 Mar 2010 10:29:37 -0500
Message-ID: <4BB0C761.50204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab0C2P3m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 11:29:42 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2TFTglK011455
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 11:29:42 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2TFTbSR023301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 11:29:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(resend, email sent Friday seems lost)

There was a bug reported on RHEL5 that a 10G dd on a 12G box
had a very, very slow sync after that.

At issue was the loop in write_cache_pages scanning all the way
to the end of the 10G file, even though the subsequent call
to mpage_da_submit_io would only actually write a smallish amt; then
we went back to the write_cache_pages loop ... wasting tons of time
in calling __mpage_da_writepage for thousands of pages we would
just revisit (many times) later.

Upstream it's not such a big issue for sys_sync because we get
to the loop with a much smaller nr_to_write, which limits the loop.

However, talking with Aneesh he realized that fsync upstream still
gets here with a very large nr_to_write and we face the same problem.

This patch makes mpage_add_bh_to_extent stop the loop after we've
accumulated 2048 pages, by setting mpd->io_done = 1; which ultimately
causes the write_cache_pages loop to break.

Repeating the test with a dirty_ratio of 80 (to leave something for
fsync to do), I don't see huge IO performance gains, but the reduction
in cpu usage is striking: 80% usage with stock, and 2% with the
below patch.  Instrumenting the loop in write_cache_pages clearly
shows that we are wasting time here.

It'd be better to not have a magic number of 2048 in here, so I'll
look for a cleaner way to get this info out of mballoc; I still need
to look at what Aneesh has in the patch queue, that might help.
This is something we could probably put in for now, though; the 2048
is already enshrined in a comment in inode.c, at least.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c
+++ linux-2.6/fs/ext4/inode.c
@@ -2318,6 +2318,10 @@ static void mpage_add_bh_to_extent(struc
 	sector_t next;
 	int nrblocks = mpd->b_size >> mpd->inode->i_blkbits;
 
+	/* Don't go larger than mballoc is willing to allocate */
+	if (nrblocks >= 2048)
+		goto flush_it;
+
 	/* check if thereserved journal credits might overflow */
 	if (!(EXT4_I(mpd->inode)->i_flags & EXT4_EXTENTS_FL)) {
 		if (nrblocks >= EXT4_MAX_TRANS_DATA) {

