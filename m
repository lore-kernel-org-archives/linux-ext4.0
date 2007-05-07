From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][take 4] e2fsprogs: Add ext4migrate
Date: Mon, 7 May 2007 14:01:15 -0700
Message-ID: <20070507210115.GB8181@schatzie.adilger.int>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20070506051759.GP6220@schatzie.adilger.int> <463E9C53.8000503@linux.vnet.ibm.com> <20070507132001.GB17180@thunk.org> <463F2DB7.6090507@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46858 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966910AbXEGVBR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2007 17:01:17 -0400
Content-Disposition: inline
In-Reply-To: <463F2DB7.6090507@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 07, 2007  19:16 +0530, Aneesh Kumar K.V wrote:
> Theodore Tso wrote:
> >Actually, changing the inode size is actually going to be more useful
> >to a larger number of people, since they can use it today to support
> >in-inode EA's.  In addition, changing the inode size must be done
> >off-line, whereas it's not so clear that off-line conversion to
> >extents is the best way to go (more on that below).
> 
> That way we don't need to add kernel code that convert ext3 inode to 
> ext4 inode while defragmentation. Last time i looked at the online 
> defrag code, i was not able to figure out a easy way to take indirect 
> map inode as input, then defrag the same and write the result in extent 
> map.

I think the online defrag code _should_ be fairly easily made to handle
defrag of block-mapped files, so long as it is always creating extent-
mapped files in the end.  All that should be necessary is to have the
kernel read data from the block-mapped file and write it into the newly
mapped blocks.  That functionality needs to exist for a long time anyways
to support upgrading the filesystem so it shouldn't be a huge burden.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
