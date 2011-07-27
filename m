From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Date: Wed, 27 Jul 2011 03:16:12 -0600
Message-ID: <EF1F2330-D8C4-427A-ABB9-D1E607D91A3D@gmail.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <1302290868.4461.7.camel@mingming-laptop> <20110727082730.GG20655@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Mingming Cao <cmm@us.ibm.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "djwong@us.ibm.com" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42420 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab1G0JPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jul 2011 05:15:46 -0400
In-Reply-To: <20110727082730.GG20655@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-27, at 2:27 AM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> On Fri, Apr 08, 2011 at 12:27:48PM -0700, Mingming Cao wrote:
>> Beyond checksumming the inode itself, it
>> would be more useful to checksum the extent indexing blocks, as the ext3
>> corruption actually happen at the indirect block.  
>> 
>> The idea is to reduce the eh_max (the max # of extents stored in this
>> block) to save some space to store the checksums in the block, 
>> 
>> /*
>> * Each block (leaves and indexes), even inode-stored has header.
>> */
>> struct ext4_extent_header {
>>        __le16  eh_magic;       /* probably will support different
>> formats */
>>        __le16  eh_entries;     /* number of valid entries */
>>        __le16  eh_max;         /* capacity of store in entries */
>>        __le16  eh_depth;       /* has tree real underlying blocks? */
>>        __le32  eh_generation;  /* generation of the tree */
> 
> Does anyone use eh_generation?  Linux 3.0 shows no users and it didn't look like
> the snapshot patches do either.  If nobody intends to start using this field,
> (part of) it could become eh_checksum

We use eh_generation in Lustre to detect if the extent tree is being changed while it is unlocked.

In the past, the discussion about adding checksums to the index and extent blocks was about using an ext4_extent_tail that contained not only the checksum of the block, but also a back-pointer to the inode/generation of the inode using this block.

That would allow e2fsck to verify that it is using the correct index/extent blocks and not pointing to a stale block that belonged to some other inode.

Since the header and index/extent entries are always 3 *__u32 in size, the extent tail can always be 4 * __u32 in size yet only consume a single slot in the block. There of course is no reason to put an extent tail inside the inode itself.

Cheers, Andreas