From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/8] e2fsprogs: save checksum seeds; misc fixes
Date: Fri, 4 Dec 2015 22:15:50 -0700
Message-ID: <0C22C0C1-7131-48FD-A8A7-3F8039C65148@dilger.ca>
References: <20151205024416.31087.14808.stgit@birch.djwong.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33418 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbLEFQP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Dec 2015 00:16:15 -0500
Received: by iouu10 with SMTP id u10so139376474iou.0
        for <linux-ext4@vger.kernel.org>; Fri, 04 Dec 2015 21:16:15 -0800 (PST)
In-Reply-To: <20151205024416.31087.14808.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Patch #6 should probably go in via maint?

Cheers, Andreas

> On Dec 4, 2015, at 19:44, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> Hi all,
> 
> Here's a short patch series that rolls up all my pending fixes for
> e2fsprogs.  The first five patches introduce the "metdata_csum_seed"
> feature which decouples the metadata block checksums from the FS UUID
> so that said UUID can be changed while the FS is mounted.
> 
> Patch #6 fixes filefrag not to report holes as fragmentation.
> 
> Patch #7 changes tune2fs so that prior to making invasive changes to
> the filesystem it'll check that the FS has been fsck'd recently and if
> so confirms with the administrator that they actually want to proceed.
> 
> Patch #8 teaches tune2fs to recover the journal if necessary.  This
> prevents tune2fs modifications from being clobbered by a journal
> replay.
> 
> The patchset should apply cleanly against the -next branch as of 30
> November.  Comments and questions are, as always, welcome.
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
