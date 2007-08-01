From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/4] e2fsprogs: Add undo I/O manager
Date: Wed, 1 Aug 2007 16:52:47 -0600
Message-ID: <20070801225247.GC5692@schatzie.adilger.int>
References: <11859824513552-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <f2c3823cb66c7a30436b1f2163cbe3bba791a115.1185981319.git.aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:60606 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbXHBPJy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2007 11:09:54 -0400
Content-Disposition: inline
In-Reply-To: <f2c3823cb66c7a30436b1f2163cbe3bba791a115.1185981319.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 01, 2007  21:04 +0530, Aneesh Kumar K.V wrote:
> +static errcode_t write_file_system_identity(io_channel undo_channel,
> +							TDB_CONTEXT *tdb)
> +{
> +	/* Write to tdb file in the file system byte order */
> +	tdb_key.dptr = "filesystem MTIME";
> +	tdb_key.dsize = sizeof("filesystem MTIME");
> +	tdb_data.dptr = (unsigned char *) &(super.s_mtime);
> +	tdb_data.dsize = sizeof(super.s_mtime);
> +
> +	tdb_key.dptr = "filesystem UUID";
> +	tdb_key.dsize = sizeof("filesystem UUID");
> +	tdb_data.dptr = (unsigned char *)&(super.s_uuid);
> +	tdb_data.dsize = sizeof(super.s_uuid);

Is this the mtime and UUID of the new filesystem or the old one?  It
should be the UUID and mtime of the new filesystem, so that the
undo file can be verified against the current superblock.  This poses
a bit of a problem, because that information isn't saved until after
the mke2fs run is finished.

One possibility is to overwrite this information at the end of mke2fs
after the new UUID and mtime are written?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
