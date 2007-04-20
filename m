From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix up lazy_bg bitmap initialization at mkfs time
Date: Fri, 20 Apr 2007 09:57:19 -0500
Message-ID: <4628D4CF.1020804@redhat.com>
References: <4627DA21.7050002@redhat.com> <20070420101020.GQ5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992866AbXDTPCC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Apr 2007 11:02:02 -0400
In-Reply-To: <20070420101020.GQ5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:

> Just as an FYI - it probably makes little sense to have a 128MB journal
> for a filesystem you want to use for testing, since it would still write
> 128MB to your loopback device when zeroing the journal.  It still makes
> sense for mke2fs and libext2fs to be fixed for correctness, but I think
> it also makes sense for lazy_bg to influence the journal size.
>   
yup, it probably should change that heuristic.  With lazy_bg, it should probably 
look at something like blocks per group * 2 instead of total filesystem blocks...
see below.

>> Unfortunately it also increases mkfs time a bit, as it must search
>> a huge string of unavailable blocks if it has to allocate in the 
>> last bg.  Ah well...
>>     
>
> It also probably makes sense for libext2fs to check group descriptors
> while allocating...
>   
yeah... I was going with the "lazy" theme.  ;-)  (and the 
small-functional-change-at-a-time theme...) But for large filesystems, that 
would certainly be a bonus. 

/*
 * Stupid algorithm --- we now just search forward starting from the
 * goal.  Should put in a smarter one someday....
 */
errcode_t ext2fs_new_block(...

I get the impression that allocation in libext2 is not too glorious in 
the first place... :)

-Eric

Anyway, how about something like this for calculating journal size in 
the face of lazy_bg.  I know the last group may be smaller... but I figure
this is just a heuristic anyway.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.39_ext4_hg/misc/util.c
===================================================================
--- e2fsprogs-1.39_ext4_hg.orig/misc/util.c
+++ e2fsprogs-1.39_ext4_hg/misc/util.c
@@ -252,8 +252,16 @@ void parse_journal_opts(const char *opts
 int figure_journal_size(int size, ext2_filsys fs)
 {
 	blk_t j_blocks;
+	blk_t fs_size;
 
-	if (fs->super->s_blocks_count < 2048) {
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
+ 				    EXT2_FEATURE_COMPAT_LAZY_BG)) {
+		fs_size = fs->super->s_blocks_per_group * 2; 
+	} else {
+		fs_size = fs->super->s_blocks_count;
+	}
+
+	if (fs_size < 2048) {
 		fputs(_("\nFilesystem too small for a journal\n"), stderr);
 		return 0;
 	}
@@ -276,13 +284,13 @@ int figure_journal_size(int size, ext2_f
 		return j_blocks;
 	}
 
-	if (fs->super->s_blocks_count < 32768)
+	if (fs_size < 32768)
 		j_blocks = 1400;
-	else if (fs->super->s_blocks_count < 256*1024)
+	else if (fs_size < 256*1024)
 		j_blocks = 4096;
-	else if (fs->super->s_blocks_count < 512*1024)
+	else if (fs_size < 512*1024)
 		j_blocks = 8192;
-	else if (fs->super->s_blocks_count < 1024*1024)
+	else if (fs_size < 1024*1024)
 		j_blocks = 16384;
 	else
 		j_blocks = 32768;
