From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: renumber EXT4_EX_* flags to avoid flag aliasing
 problems flags
Date: Tue, 2 Sep 2014 21:44:16 -0400
Message-ID: <20140903014416.GA2504@thunk.org>
References: <1409515240-9451-1-git-send-email-tytso@mit.edu>
 <A71E6FF0-16EC-4747-89E4-F9574A89FF89@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33898 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbaICBoV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2014 21:44:21 -0400
Content-Disposition: inline
In-Reply-To: <A71E6FF0-16EC-4747-89E4-F9574A89FF89@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 02, 2014 at 01:01:54PM -0600, Andreas Dilger wrote:
> Why not move EXT4_EX_*CACHE flags to the end of the range (e.g. 0x8000
> and 0x4000) to minimize potential conflicts in the future?

Good idea, thanks!

					- Ted

commit ef78955523bffe055035f0b3a98aba31534bf27c
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Sep 2 21:41:59 2014 -0400

    ext4: renumber EXT4_EX_* flags to avoid flag aliasing problems
    
    Suggested-by: Andreas Dilger <adilger@dilger.ca>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4855800..f70c3fc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -569,7 +569,6 @@ enum {
 #define EXT4_GET_BLOCKS_NO_PUT_HOLE		0x0200
 	/* Convert written extents to unwritten */
 #define EXT4_GET_BLOCKS_CONVERT_UNWRITTEN	0x0400
-/* DO NOT ASSIGN ADDITIONAL FLAG VALUES WITHOUT ADJUSTING THE FLAGS BELOW */
 
 /*
  * The bit position of these flags must not overlap with any of the
@@ -580,8 +579,8 @@ enum {
  * caching the extents when reading from the extent tree while a
  * truncate or punch hole operation is in progress.
  */
-#define EXT4_EX_NOCACHE				0x0800
-#define EXT4_EX_FORCE_CACHE			0x1000
+#define EXT4_EX_NOCACHE				0x40000000
+#define EXT4_EX_FORCE_CACHE			0x20000000
 
 /*
  * Flags used by ext4_free_blocks
