From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot
 feature flags
Date: Fri, 16 Sep 2011 10:28:25 -0400
Message-ID: <20110916142825.GB6342@thunk.org>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu>
 <1316127052-1890-2-git-send-email-tytso@mit.edu>
 <F041558F-1F4B-4ADE-9DC2-53708C9124B8@dilger.ca>
 <20110915231127.GK28181@thunk.org>
 <14955E98-C987-40D6-A881-5D40077C2FB2@dilger.ca>
 <20110915234131.GL28181@thunk.org>
 <F48B39D1-7E73-4F3B-AA41-3D419CB5EF61@dilger.ca>
 <20110916010604.GM28181@thunk.org>
 <036188D0-DA3B-4DD1-A097-F0B6AC4B4BB4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60067 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab1IPO2a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 10:28:30 -0400
Content-Disposition: inline
In-Reply-To: <036188D0-DA3B-4DD1-A097-F0B6AC4B4BB4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 09:57:33PM -0600, Andreas Dilger wrote:
> True, but at the same time is there a reason _not_ to put the checksum
> at the end?  For the superblock in particular it seems easy to do and
> simplifies the code either way.

For the superblock, OK.  I'll buy that and I'll make the change so
that tail end of the superblock looks like this:

     __u32    s_overhead_blocks;      /* overhead blocks/clusters in fs */
     __u32   s_reserved[108];        /* Padding to the end of the block */
     __u32   s_checksum;	     	/* crc32c(superblock) */
};

							- Ted


