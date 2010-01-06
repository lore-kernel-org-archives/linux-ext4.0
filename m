From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH] genhd: overlapping variable definition
Date: Wed, 6 Jan 2010 15:45:55 -0800
Message-ID: <20100106154555.3dd77fe2@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Greg KH <gregkh@suse.de>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>,
	Jerome Marchand <jmarchan@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:55968 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311Ab0AFXq1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jan 2010 18:46:27 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes the sparse warning:
fs/ext4/super.c:2390:40: warning: symbol 'i' shadows an earlier one
fs/ext4/super.c:2368:22: originally declared here

Using 'i' in a macro is dubious practice.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/include/linux/genhd.h	2010-01-06 10:49:11.822315232 -0800
+++ b/include/linux/genhd.h	2010-01-06 10:50:02.272939396 -0800
@@ -256,9 +256,9 @@ extern struct hd_struct *disk_map_sector
 #define part_stat_read(part, field)					\
 ({									\
 	typeof((part)->dkstats->field) res = 0;				\
-	int i;								\
-	for_each_possible_cpu(i)					\
-		res += per_cpu_ptr((part)->dkstats, i)->field;		\
+	unsigned int _cpu;						\
+	for_each_possible_cpu(_cpu)					\
+		res += per_cpu_ptr((part)->dkstats, _cpu)->field;	\
 	res;								\
 })
 
