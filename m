From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V8 2/8] fs: add field to superblock to support cleancache
Date: Thu, 14 Apr 2011 14:16:31 -0700
Message-ID: <20110414211631.GA27708__7207.95183810896$1302815893$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu,
	mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx,
	linux-btrfs@
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:32891 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1DNVSA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 17:18:00 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V8 2/8] fs: add field to superblock to support cleancache

This second patch of eight in this cleancache series adds a field to
the generic superblock to squirrel away a pool identifier that is
dynamically provided by cleancache-enabled filesystems at mount time
to uniquely identify files and pages belonging to this mounted filesystem.

Details and a FAQ can be found in Documentation/vm/cleancache.txt

[v8: trivial merge conflict update]
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Reviewed-by: Jeremy Fitzhardinge <jeremy@goop.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik Van Riel <riel@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Nitin Gupta <ngupta@vflare.org>

---

Diffstat:
 include/linux/fs.h                       |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.39-rc3/include/linux/fs.h	2011-04-11 18:21:51.000000000 -0600
+++ linux-2.6.39-rc3-cleancache/include/linux/fs.h	2011-04-13 16:46:44.444861817 -0600
@@ -1430,6 +1430,11 @@ struct super_block {
 	 */
 	char __rcu *s_options;
 	const struct dentry_operations *s_d_op; /* default d_op for dentries */
+
+	/*
+	 * Saved pool identifier for cleancache (-1 means none)
+	 */
+	int cleancache_poolid;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
