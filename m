From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-28.diff>
Date: Fri, 9 Feb 2007 18:11:24 -0800
Message-ID: <200702100211.l1A2BOQM007246@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:31558 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbXBJCOb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lawrence Livermore National Labs recently ran the source code
analysis tool Coverity over the e2fsprogs-1.39 source to see 
if it would identify any significant bugs.  The analysis
turned up 38 mostly minor issues which are enumerated here
with patches.  We went through and resolved these issues
but would love to see these mostly minor changes reviewed
and commited upstream.

Thanks,
Brian Behlendorf <behlendorf1@llnl.gov>, and
Herb Wartens <wartens2@llnl.gov>

-----------------------------------------------------------------------------
Coverity ID: 28: Resource Leak

block_buf must be freed on return from this function.  The other
potential resource leaks in this function are handled by calling exit().

Index: e2fsprogs+chaos/misc/e2image.c
===================================================================
--- e2fsprogs+chaos.orig/misc/e2image.c
+++ e2fsprogs+chaos/misc/e2image.c
@@ -540,6 +540,7 @@ static void write_raw_image_file(ext2_fi
 	}
 	use_inode_shortcuts(fs, 0);
 	output_meta_data_blocks(fs, fd);
+	free(block_buf);
 }
 
 static void install_image(char *device, char *image_fn, int raw_flag)
