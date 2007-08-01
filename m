From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 3/4] e2fsprogs: Make mke2fs use undo I/O manager.
Date: Wed, 1 Aug 2007 01:04:39 -0500
Message-ID: <20070801060439.GP5469@schatzie.adilger.int>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com> <70b3f394cda275d59094d52f60d1ee76492033fc.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:50167 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbXHAGFE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 02:05:04 -0400
Content-Disposition: inline
In-Reply-To: <70b3f394cda275d59094d52f60d1ee76492033fc.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 01, 2007  07:34 +0530, Aneesh Kumar K.V wrote:
> When running mke2fs, if a file system is detected
> on the device, we use Undo I/O manager as the io manager.
> This helps in reverting the changes made to the filesystem
> in case we wrongly selected the device.
> 
> The environment variable MKE2FS_SCRATCH_DIR
> is used to indicate the  directory within which the tdb
> file need to be created. The file will be named mke2fs-XXXXXX

It might be more useful to have "mke2fs-{dev}-{timestamp}" as
the filename, so that it is clear where the image came from.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
