From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] debugfs: open with EXT2_FLAG_64BITS
Date: Fri, 11 Sep 2009 10:18:28 -0500
Message-ID: <4AAA6A44.90902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbZIKPSd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2009 11:18:33 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8BFIakO015115
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 11:18:36 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8BFIT8m015350
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 11:18:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pointing debugfs from the pu branch at a large filesystem is
still failing with:

 Filesystem too large to use legacy bitmaps while reading block bitmap

We need to open with EXT2_FLAG_64BITS; I'm not sure if this
should be a switch based on the size of the fs or not?

But in any case the below gets things moving enough to
use debugfs on a large filesystem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 3bb309f..fbebae7 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -127,7 +127,7 @@ void do_open_filesys(int argc, char **argv)
 	int	catastrophic = 0;
 	blk64_t	superblock = 0;
 	blk64_t	blocksize = 0;
-	int	open_flags = EXT2_FLAG_SOFTSUPP_FEATURES;
+	int	open_flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS; 
 	char	*data_filename = 0;
 
 	reset_getopt();
@@ -2148,7 +2148,7 @@ int main(int argc, char **argv)
 	int		sci_idx;
 	const char	*usage = "Usage: %s [-b blocksize] [-s superblock] [-f cmd_file] [-R request] [-V] [[-w] [-c] device]";
 	int		c;
-	int		open_flags = EXT2_FLAG_SOFTSUPP_FEATURES;
+	int		open_flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS;
 	char		*request = 0;
 	int		exit_status = 0;
 	char		*cmd_file = 0;

