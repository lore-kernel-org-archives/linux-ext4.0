From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: e2fsprogs coverity patch <cid-4.diff>
Date: Mon, 12 Feb 2007 12:25:30 -0700
Message-ID: <20070212192530.GM6565@schatzie.adilger.int>
References: <200702100211.l1A2BZvu007411@igsi.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, wartens2@llnl.gov
To: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:38148 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965330AbXBLTZd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Feb 2007 14:25:33 -0500
Content-Disposition: inline
In-Reply-To: <200702100211.l1A2BZvu007411@igsi.llnl.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 09, 2007  18:11 -0800, Brian D. Behlendorf wrote:
> This check is unnecessary since fs_type is guaranteed to be set earlier in the
> function.

I'm not positive this is the right fix.  If we are creating a journal device,
we shouldn't be using the normal defaults based on the size of the journal
device because this will often be much smaller than the actual filesystem.

I'd argue that we set fs_type="journal" earlier when fs_type is being first
set, if INCOMPAT_JOURNAL_DEV is set.

> Index: e2fsprogs+chaos/misc/mke2fs.c
> ===================================================================
> --- e2fsprogs+chaos.orig/misc/mke2fs.c
> +++ e2fsprogs+chaos/misc/mke2fs.c
> @@ -1310,8 +1310,6 @@ static void PRS(int argc, char *argv[])
>  
>  	if (fs_param.s_feature_incompat & 
>  	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
> -		if (!fs_type)
> -			fs_type = "journal";
>  		reserved_ratio = 0;
>  		fs_param.s_feature_incompat = EXT3_FEATURE_INCOMPAT_JOURNAL_DEV;
>  		fs_param.s_feature_compat = 0;

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
