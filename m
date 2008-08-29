From: Theodore Tso <tytso@mit.edu>
Subject: Re: Do we need dump for ext4?
Date: Fri, 29 Aug 2008 10:17:03 -0400
Message-ID: <20080829141703.GC30887@mit.edu>
References: <48B6BD02.3080307@redhat.com> <48B7ED40.6020508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Ric Wheeler <rwheeler@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42925 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbYH2OSF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Aug 2008 10:18:05 -0400
Content-Disposition: inline
In-Reply-To: <48B7ED40.6020508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just for completeness's sake, can you apply the following patch to
dump, and then try doing a benchmark run using dump on ext4?

I'm curious how it would compare.

      	       	   	   	     	       - Ted

Index: dump-0.4b41/dump/traverse.c
===================================================================
--- dump-0.4b41.orig/dump/traverse.c
+++ dump-0.4b41/dump/traverse.c
@@ -157,14 +157,6 @@ int dump_fs_open(const char *disk, ext2_
 			retval = EXT2_ET_UNSUPP_FEATURE;
 			ext2fs_close(*fs);
 		}
-		else if ((retval = es->s_feature_incompat &
-					~(EXT2_LIB_FEATURE_INCOMPAT_SUPP |
-					  EXT3_FEATURE_INCOMPAT_RECOVER))) {
-			msg("Unsupported feature(s) 0x%x in filesystem\n",
-				retval);
-			retval = EXT2_ET_UNSUPP_FEATURE;
-			ext2fs_close(*fs);
-		}
 		else {
 			if (es->s_feature_compat &
 				EXT3_FEATURE_COMPAT_HAS_JOURNAL && 
