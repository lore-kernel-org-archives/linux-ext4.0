From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH 2/4] e2fsprogs: Add undoe2fs
Date: Wed, 01 Aug 2007 12:03:16 +0530
Message-ID: <1185949996.3870.9.camel@garfield.linsyssoft.com>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
	 <47f96570519d76b8d59f92b729a0a48c4a1b68d8.1185933778.git.aneesh.kumar@linux.vnet.ibm.com>
	 <20070801060211.GO5469@schatzie.adilger.int>
	 <46B02539.5020505@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:35231 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbXHAGcd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 02:32:33 -0400
In-Reply-To: <46B02539.5020505@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-08-01 at 11:46 +0530, Aneesh Kumar K.V wrote:
> 
> Andreas Dilger wrote:
> > On Aug 01, 2007  07:34 +0530, Aneesh Kumar K.V wrote:
> >> undoe2fs can be used to replay the transaction saved
> >> in the transaction file using undo I/O Manager
> > 
> > This should save the mtime of the superblock, and only do the undo
> > step if the filesystem hasn't changed.  Otherwise it could seriously
> > corrupt the filesystem.
> 
> 
> I am not sure i understand this. The Undo I/O manager tracks all the write
> happening to the file system and copy the original content of the blocks to
> the tdb file. Undoe2fs simply copies these blocks back to the file system. So
> That way if you look at undoe2fs it doesn't have any knowledge of the file
> system at all.
> 
> Can you let me know a use case where this will fail.

undoe2fs made a copy of all the changes to the filesystem. After that
the filesystem was mounted and used thereby rendering the checkpoint
invalid. If this checkpoint was replayed it could seriously corrupt the
filesystem. Hence as Andreas suggests the mtime of the filesystem should
be checked and only then the transaction should be replayed.

Infact mounting the filesystem when the replay is in progress would also
corrupt the filesystem.

Is should the checkpoint be deleted if e2fsck was aborted?

Thanks,
Kalpak.
