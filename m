From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: e2fsprogs coverity patch <cid-33.diff>
Date: Tue, 29 May 2007 14:51:41 -0600
Message-ID: <20070529205141.GB5181@schatzie.adilger.int>
References: <200702100211.l1A2BTRb007321@igsi.llnl.gov> <465C75A8.5080506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Brian D. Behlendorf" <behlendorf1@llnl.gov>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, wartens2@llnl.gov
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:52960 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbXE2Uvo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 16:51:44 -0400
Content-Disposition: inline
In-Reply-To: <465C75A8.5080506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 29, 2007  13:49 -0500, Eric Sandeen wrote:
> Brian D. Behlendorf wrote:
> >Lawrence Livermore National Labs recently ran the source code
> >analysis tool Coverity over the e2fsprogs-1.39 source to see 
> >if it would identify any significant bugs.  The analysis
> >turned up 38 mostly minor issues which are enumerated here
> >with patches.  We went through and resolved these issues
> >but would love to see these mostly minor changes reviewed
> >and commited upstream.
> 
> Did cid-34.diff get lost?

I still have it in my "apply atop 1.39-WIP" series, so it appears not
to have made it into Ted's repo.  I'm including the patch again for
posterity.

=========================================================================
Coverity ID: 34: Resource Leak

The memory allocated by buf is not reclaimed.  This patch
addresses the issue.

Index: e2fsprogs+chaos/misc/mke2fs.c
===================================================================
--- e2fsprogs+chaos.orig/misc/mke2fs.c
+++ e2fsprogs+chaos/misc/mke2fs.c
@@ -749,7 +749,7 @@ static int set_os(struct ext2_super_bloc
 static void parse_extended_opts(struct ext2_super_block *param, 
 				const char *opts)
 {
-	char	*buf, *token, *next, *p, *arg;
+	char	*buf = NULL, *token, *next, *p, *arg;
 	int	len;
 	int	r_usage = 0;
 
@@ -834,6 +834,7 @@ static void parse_extended_opts(struct e
 				if (param->s_rev_level == EXT2_GOOD_OLD_REV) {
 					fprintf(stderr, 
 	_("On-line resizing not supported with revision 0 filesystems\n"));
+					free(buf);
 					exit(1);
 				}
 				param->s_feature_compat |=
@@ -852,8 +853,11 @@ static void parse_extended_opts(struct e
 			"Valid extended options are:\n"
 			"\tstride=<stride length in blocks>\n"
 			"\tresize=<resize maximum size in blocks>\n\n"));
+		free(buf);
 		exit(1);
 	}
+
+	free(buf);
 }	
 
 static __u32 ok_features[3] = {
=========================================================================

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
