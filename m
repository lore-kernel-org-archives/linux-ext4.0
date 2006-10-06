From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 5 Oct 2006 23:58:29 -0600
Message-ID: <20061006055829.GH22010@schatzie.adilger.int>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com> <20061005213133.2c4cd82d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:5863 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S932200AbWJFF6b
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Oct 2006 01:58:31 -0400
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20061005213133.2c4cd82d.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 05, 2006  21:31 -0700, Andrew Morton wrote:
> If you mount the filesystem with `-t ext4dev -o extents' then create some
> extenty files, then unount it and then mount it without `-o extents', the
> driver will then refuse to create extenty files.
> 
> IOW: you need to give it `-o extents' each time.
> 
> That seems fairly pointless.  In fact, if I'd created the fs with `mke2fs
> -O extents' (which doesn't work at present) then I'd expect it to use
> extents from thereon after, without requiring `mount -o extents'.

I think this is an oversight.  For Lustre we wanted the ability to mount
ext3 filesystems with or without extents, because different customers
have different levels of tolerance for risk.  These days all of our
customers use extents (better performance in conjunction with mballoc),
but the patches have not been changed for ext4 (which should really
default to using extents on a filesystem with the INCOMPAT_EXTENT feature
set unless told otherwise).  That is a necessity for filesystems larger
than 2^32 blocks, since there is no way to create old block-mapped files
past that limit.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

