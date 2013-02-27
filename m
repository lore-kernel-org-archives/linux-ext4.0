From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Wed, 27 Feb 2013 13:49:12 -0500
Message-ID: <20130227184912.GA19624@thunk.org>
References: <nsxr4k2kdwv.fsf@closure.thunk.org>
 <20130227124727.GA225@x4>
 <20130227153435.GB5609@thunk.org>
 <20130227154450.GA23402@x4>
 <20130227170157.GA222@x4>
 <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Markus, Dave, can you confirm that this fixes your problem?

Thanks!!

(Sigh, this is a real brown paper bug; I'm embarassed I missed this in
my code review.)

						- Ted

>From f47f0d11096ca5d9e1965d8a9f266aa13fe2b73b Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Wed, 27 Feb 2013 13:47:52 -0500
Subject: [PATCH] ext4: fix extent status tree regression for file systems >
 512GB

This fixes a regression introduced by commit f7fec032aa782.  The
problem was that the extents status flags caused us to mask out block
numbers smaller than 2**28 blocks.  Since we didn't test with file
systems smaller than 512GB, we didn't notice this during the
development cycle.

A typical failure looks like this:

EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block
152052301: comm ls: bad entry in directory: rec_len is smaller than minimal -
offset=0(0), inode=0, rec_len=0, name_len=0

... where 'debugfs -R "stat <172235804>" /dev/sdb1' reports that the
inode has block number 688923213.  When viewed in hex, block number
152052301 (from the syslog) is 0x910224D, while block number 688923213
is 0x2910224D.  Note the missing "0x20000000" in the block number.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Reported-by: Dave Jones <davej@redhat.com>
Cc: Zheng Liu <gnehzuil.liu@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents_status.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index cf83e77..c795ff6 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -20,10 +20,10 @@
 #define es_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
-#define EXTENT_STATUS_WRITTEN	0x80000000	/* written extent */
-#define EXTENT_STATUS_UNWRITTEN	0x40000000	/* unwritten extent */
-#define EXTENT_STATUS_DELAYED	0x20000000	/* delayed extent */
-#define EXTENT_STATUS_HOLE	0x10000000	/* hole */
+#define EXTENT_STATUS_WRITTEN	(((unsigned long long) 1) << 63)
+#define EXTENT_STATUS_UNWRITTEN	(((unsigned long long) 1) << 62)
+#define EXTENT_STATUS_DELAYED	(((unsigned long long) 1) << 61)
+#define EXTENT_STATUS_HOLE	(((unsigned long long) 1) << 60)
 
 #define EXTENT_STATUS_FLAGS	(EXTENT_STATUS_WRITTEN | \
 				 EXTENT_STATUS_UNWRITTEN | \
@@ -58,22 +58,22 @@ extern int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
 
 static inline int ext4_es_is_written(struct extent_status *es)
 {
-	return (es->es_pblk & EXTENT_STATUS_WRITTEN);
+	return (es->es_pblk & EXTENT_STATUS_WRITTEN) != 0;
 }
 
 static inline int ext4_es_is_unwritten(struct extent_status *es)
 {
-	return (es->es_pblk & EXTENT_STATUS_UNWRITTEN);
+	return (es->es_pblk & EXTENT_STATUS_UNWRITTEN) != 0;
 }
 
 static inline int ext4_es_is_delayed(struct extent_status *es)
 {
-	return (es->es_pblk & EXTENT_STATUS_DELAYED);
+	return (es->es_pblk & EXTENT_STATUS_DELAYED) != 0;
 }
 
 static inline int ext4_es_is_hole(struct extent_status *es)
 {
-	return (es->es_pblk & EXTENT_STATUS_HOLE);
+	return (es->es_pblk & EXTENT_STATUS_HOLE) != 0;
 }
 
 static inline ext4_fsblk_t ext4_es_status(struct extent_status *es)
-- 
1.7.12.rc0.22.gcdd159b
