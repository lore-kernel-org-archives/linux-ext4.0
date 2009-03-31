From: Theodore Tso <tytso@mit.edu>
Subject: Re: Once more: Recovering a damaged ext4 fs?
Date: Tue, 31 Mar 2009 08:42:04 -0400
Message-ID: <20090331124204.GF13356@mit.edu>
References: <p0624058dc5f2d7be08cc@[130.161.115.44]> <20090327224616.GD5176@mit.edu> <p0624058ec5f30b501efb@[130.161.115.44]> <20090328123035.GD2155@mit.edu> <p06240592c5f3caee289b@[130.161.115.44]> <20090328130922.GE2155@mit.edu> <p062405b1c5f59a4c5ed1@[130.161.115.44]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "J.D. Bakker" <jdb@lartmaker.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55715 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757226AbZCaMmJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 08:42:09 -0400
Content-Disposition: inline
In-Reply-To: <p062405b1c5f59a4c5ed1@[130.161.115.44]>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK, here's a patch that should allow mke2fs -S to work.  It should be
applied against the e2fsprogs 1.41.4.

Sorry for the delay in getting this to you; things have been crazy
busy on my end.

						- Ted

commit a620baddee647faf42c49ee2e04ee3f667149d68
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Mar 31 07:42:24 2009 -0400

    mke2fs: Don't try to create the journal in super-only mode
    
    Since we aren't initializing the inode table, creating the journal
    will just fail.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index e69e5ce..4f50ffa 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2079,6 +2079,12 @@ int main (int argc, char *argv[])
 		    EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
 		journal_blocks = figure_journal_size(journal_size, fs);
 
+		if (super_only) {
+			printf(_("Skipping journal creation in super-only mode\n"));
+			fs->super->s_journal_inum = EXT2_JOURNAL_INO;
+			goto no_journal;
+		}
+
 		if (!journal_blocks) {
 			fs->super->s_feature_compat &=
 				~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
