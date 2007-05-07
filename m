From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][take 4] e2fsprogs: Add ext4migrate
Date: Mon, 7 May 2007 11:57:00 -0400
Message-ID: <20070507155659.GE17180@thunk.org>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20070506051759.GP6220@schatzie.adilger.int> <463E9C53.8000503@linux.vnet.ibm.com> <20070507132001.GB17180@thunk.org> <463F2DB7.6090507@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48357 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934405AbXEGP5H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2007 11:57:07 -0400
Content-Disposition: inline
In-Reply-To: <463F2DB7.6090507@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 07, 2007 at 07:16:31PM +0530, Aneesh Kumar K.V wrote:
> 
> One of the option i was thinking was to use this tool to migrate to 
> extent map and then towards the end use the online defrag ioctl to 
> defrag the resulting ext4 inode.

As we discussed on the phone, my recommendation would be to take your
existing code and move it into the kernel so that triggered off of an
ioctl, your code could migrate an inode from using indirect blocks to
extents while a filesystem is mounted.  The main things you will need
to watch for is to make sure the inode is locked so that another
process doesn't try to extend or truncate it, and to use the JBD layer
to provide appropriate journalling support.

Given that ext4migrated imported the kernel extent functions, it
should be relatively straightforward to simply make them use the
kernel extent functions while in kernel space.

Once the the inode has been converted on-line then it can be
defragmented on-line.  That would be much more convenient than having
to unmount the filesystem to do the off-line migration, followed by
mounting it to do the defragmentation.

Regards,

					- Ted
