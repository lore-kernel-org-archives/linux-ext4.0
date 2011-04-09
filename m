From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Date: Fri, 8 Apr 2011 18:04:05 -0600
Message-ID: <758AFDD2-90D4-4F3D-87E8-DDCA3AC50B5E@dilger.ca>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <1302290868.4461.7.camel@mingming-laptop>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:43844 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab1DIAEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 20:04:07 -0400
In-Reply-To: <1302290868.4461.7.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-08, at 1:27 PM, Mingming Cao wrote:
> On Wed, 2011-04-06 at 15:44 -0700, Darrick J. Wong wrote:
>> Hi all,
>> 
>> I spent last week analyzing a client's corrupted ext3 image to see if I could
>> determine what had gone wrong and caused the filesystem to blow apart.  As best
>> as I could tell, a data block got miswritten into a different sector ... which
>> happened to be an indirect block.  Some time later the indirect block, which
>> now pointed at one of the inode tables (among other things that shouldn't ever
>> become file data) was loaded as part of a file write, which caused that inode
>> table to be blown to smithereens.  Just for fun I tried reading from one of
>> these busted-inode files and ... failed to encounter any errors.  Somehow, they
>> didn't find it funny that ext3 would read block numbers from a table with the
>> contents "ibm.com" with a straight face.  Fortunately there were backups. :)
>> 
>> The client at this point asked if ext4 would do a better job of sanity
>> checking, which got me to wonder why ext4 checksums block groups but not
>> inodes.  It's on Ted's todo list, but apparently nobody wrote any patch, so I
>> did.  The following two patches are a first draft of adding inode checksum
>> support to both the kernel driver and to the various e2fsprogs.
>> 
> 
> We had some discussion about this week at SF (at the ext4 bof at the
> linux colloboration summit). Beyond checksumming the inode itself, it
> would be more useful to checksum the extent indexing blocks, as the ext3
> corruption actually happen at the indirect block.  
> 
> The idea is to reduce the eh_max (the max # of extents stored in this
> block) to save some space to store the checksums in the block, 
> 
> /*
> * Each block (leaves and indexes), even inode-stored has header.
> */
> struct ext4_extent_header {
>        __le16  eh_magic;       /* probably will support different
> formats */
>        __le16  eh_entries;     /* number of valid entries */
>        __le16  eh_max;         /* capacity of store in entries */
>        __le16  eh_depth;       /* has tree real underlying blocks? */
>        __le32  eh_generation;  /* generation of the tree */
> };
> This would make us a RO feature to checksum the leaves and indexes
> blocks too.

I proposed this quite a long time ago on ext2-devel "topics for the file system mini-summit" and "extents in e2fsprogs", June 2006), called "ext3_extent_tail", and in fact there is some rudimentary allowance for the extent tail in ext2fs_extent_header_verify() so that it doesn't complain if eh_max is 1 or 2 less than the actual maximum number of extents that could fit into the block.

The proposed structure from the old emails looked like:

struct ext4_extent_tail {     /* optional, if eh_max allows it, and flagged */
	__le64 et_inum;
	__le32 et_igeneration;
	__le32 et_checksum;
}

Whether we really need et_inum to be a 64-bit value is subject to debate at this point, but due to the index/extent fields being 12 bytes in size there is always going to be 16 bytes available to hold something.  We could put a magic perhaps, that is high enough never to conflict with an inode number if we ever get there?

Cheers, Andreas





