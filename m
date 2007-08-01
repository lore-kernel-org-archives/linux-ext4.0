From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 3/4] e2fsprogs: Make mke2fs use undo I/O manager.
Date: Wed, 1 Aug 2007 02:14:09 -0500
Message-ID: <20070801071409.GR5469@schatzie.adilger.int>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com> <70b3f394cda275d59094d52f60d1ee76492033fc.1185933778.git.aneesh.kumar@linux.vnet.ibm.com> <20070801060439.GP5469@schatzie.adilger.int> <46B024A9.1080000@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:56954 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbXHAHOu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 03:14:50 -0400
Content-Disposition: inline
In-Reply-To: <46B024A9.1080000@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 01, 2007  11:44 +0530, Aneesh Kumar K.V wrote:
> Andreas Dilger wrote:
> >On Aug 01, 2007  07:34 +0530, Aneesh Kumar K.V wrote:
> >>When running mke2fs, if a file system is detected
> >>on the device, we use Undo I/O manager as the io manager.
> >>This helps in reverting the changes made to the filesystem
> >>in case we wrongly selected the device.
> >>
> >>The environment variable MKE2FS_SCRATCH_DIR
> >>is used to indicate the  directory within which the tdb
> >>file need to be created. The file will be named mke2fs-XXXXXX
> >
> >It might be more useful to have "mke2fs-{dev}-{timestamp}" as
> >the filename, so that it is clear where the image came from.
> >
> 
> I added it as a FIXME!! in the code. So i was intending to do it.
> 
> +	/* FIXME!! Should we generate Unique file name ?? */
> +	sprintf(tdb_file, "%s/mke2fs-XXXXXX", tdb_dir);

I don't think the "uniqueness" is as important as the fact that
having the dev and timestamp makes it easier to know which undo
file is related to a particular filesystem.  In that regard, the
undo file should also contain the filesystem UUID in addition to
the mtime to ensure it is being replayed on the same filesystem.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
