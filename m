From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Date: Fri, 08 Apr 2011 12:27:48 -0700
Message-ID: <1302290868.4461.7.camel@mingming-laptop>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34021 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757763Ab1DHT2h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Apr 2011 15:28:37 -0400
In-Reply-To: <20110406224410.GB24354@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2011-04-06 at 15:44 -0700, Darrick J. Wong wrote:
> Hi all,
> 
> I spent last week analyzing a client's corrupted ext3 image to see if I could
> determine what had gone wrong and caused the filesystem to blow apart.  As best
> as I could tell, a data block got miswritten into a different sector ... which
> happened to be an indirect block.  Some time later the indirect block, which
> now pointed at one of the inode tables (among other things that shouldn't ever
> become file data) was loaded as part of a file write, which caused that inode
> table to be blown to smithereens.  Just for fun I tried reading from one of
> these busted-inode files and ... failed to encounter any errors.  Somehow, they
> didn't find it funny that ext3 would read block numbers from a table with the
> contents "ibm.com" with a straight face.  Fortunately there were backups. :)
> 
> The client at this point asked if ext4 would do a better job of sanity
> checking, which got me to wonder why ext4 checksums block groups but not
> inodes.  It's on Ted's todo list, but apparently nobody wrote any patch, so I
> did.  The following two patches are a first draft of adding inode checksum
> support to both the kernel driver and to the various e2fsprogs.
> 

We had some discussion about this week at SF (at the ext4 bof at the
linux colloboration summit). Beyond checksumming the inode itself, it
would be more useful to checksum the extent indexing blocks, as the ext3
corruption actually happen at the indirect block.  

The idea is to reduce the eh_max (the max # of extents stored in this
block) to save some space to store the checksums in the block, 

/*
 * Each block (leaves and indexes), even inode-stored has header.
 */
struct ext4_extent_header {
        __le16  eh_magic;       /* probably will support different
formats */
        __le16  eh_entries;     /* number of valid entries */
        __le16  eh_max;         /* capacity of store in entries */
        __le16  eh_depth;       /* has tree real underlying blocks? */
        __le32  eh_generation;  /* generation of the tree */
};
This would make us a RO feature to checksum the leaves and indexes
blocks too.

> If you have an existing ext* fs with 256-byte inodes, you ought to be able to
> "tune2fs -O inode_csum /dev/XXX", fsck /dev/XXX, and mount the filesystem with
> checksumming enabled.  It seems to work for me (i386/x86-64), but I'm looking
> for comments for improvement and perhaps some more testing (ppc64 is still
> building).  This inode checksum feature is not enabled by default.
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


