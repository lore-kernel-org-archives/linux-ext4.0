From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: About reserve of blocks for "overflow extents" in ext4 metadata
Date: Tue, 08 Dec 2009 09:48:30 -0600
Message-ID: <4B1E754E.6080505@redhat.com>
References: <41BA663C8B2F72499F48B0EF991C188E0478535CF5@RU-EXSTRCL1.ru.corp.acronis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbZLHPsX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 10:48:23 -0500
In-Reply-To: <41BA663C8B2F72499F48B0EF991C188E0478535CF5@RU-EXSTRCL1.ru.corp.acronis.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vyacheslav Dubeyko wrote:
> Hello,
> 
> I think that it make sense to has in ext4 metadata a reserve of
> blocks for "overflow extents" (it is the extents that to form
> extent's tree and it is placed in some blocks is described in i_block
> inode's field for a file). The reserve of blocks for "overflow
> extents" can be located (during operation of ext4 file system
> creation by mkfs) after inode table for every virtual (FLEX_BG) group
> by united aggregate of blocks. The size and placement of this reserve
> has to be described by free special inode.
> 
> In my opinion, the reserve of blocks for "overflow extents" resolves
> such problems: 1) In the case of ext4 volume's shrinking resize
> (especially, in the case of very fragmented volume) it can be very
> difficult to estimate possibility of successful resize because of
> existing mechanism of extents' tree layout on the volume. It is
> possible to encounter during resize the problem of free blocks' lack
> for rebuilding of extents' tree for replaced files. The reserve of
> blocks for "overflow extents" guarantee against encountering of such
> problem during resizes. 2) The presence of the reserve of blocks for
> "overflow extents" means that all existing extents' trees of files
> will locate in one place. This fact and placement the reserve just
> after inode table will increase efficiency of operations with
> extents' trees, in my opinion. 3) The localized layout of extents'
> trees of files means efficient journaling of this metadata, also.
> 
> I think that the reserve of blocks for "overflow extents" can has
> such on-disk layout. The reserve is union of bitmap (that keeps
> knowledge about used and free blocks in reserve) and some number of
> blocks (used for extents' trees). All blocks has allocated for the
> reserve during volume creation has to set as used in block bitmap of
> group(s) that contains the reserve. The size in blocks of the reserve
> can be defined by: inode_counts * count_blocks_for_inode (count of
> blocks that make possible to form extents' tree with some average
> depth). The field i_block of special inode (that will describe the
> reserve) will have two extents: 1) the extent that describes
> placement and size of reserve's bitmap block(s); 2) the extent that
> describes placement and size of blocks used for trees' extents.

If I understand this correctly, then you would be pre-reserving
all extent metadata blocks that are possible on the filesystem, in 
the same way that we currently pre-provision inodes, at mkfs time?

What happens if we have a highly fragmented filesystem, and we 
run out of these reserved "overflow extents" blocks?  And would
overprovisioning waste more filesystem space as the inodes do
today?

-Eric
