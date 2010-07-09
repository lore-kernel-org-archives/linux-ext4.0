From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: extent counting fun
Date: Fri, 9 Jul 2010 15:10:16 -0600
Message-ID: <62BE6CC5-00B2-494A-A776-347C7255E75C@dilger.ca>
References: <4C323184.8020401@redhat.com> <AF4CA4E6-4ADE-41E3-843D-02266228E2CB@dilger.ca> <4C327DC0.4070305@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:42883 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0GIVKi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jul 2010 17:10:38 -0400
In-Reply-To: <4C327DC0.4070305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-07-05, at 18:50, Eric Sandeen wrote:
> Andreas Dilger wrote:
>> What do the extents look like on disk?  Is this just because it is running on a block-mapped file and is skipping a singleton block periodically for indirect blocks, or is there a bug in the way the extents are being reported?
> 
> Well, I didn't actually look but I'm 98% sure it's just because it's not reporting the interspersed metadata blocks.
> 
> Sorry, above was on ext3, that wasn't clear, just a stock dd-streamed file.
> 
>>> I wouldn't object to having FIEMAP add a flag for metadata blocks.  I've always thought it would be useful to be able to query/dump metadata blocks (e.g. indirect/index blocks) and the inode itself.
> 
> Hm don't we have that already?  Hmm... just xattr I guess.

Right.

> In any case it's still a question of whether ext3 extent count should be "fudged" to make blocks separated by metadata look contiguous or not ...

Good question.  I don't know if there is any way to do this easily or correctly at the FIEMAP level, since it IS correctly returning that the file data is not contiguous.  I would be against having the FIEMAP ioctl return a non-accurate extent count just for this, since it would break applications that want to call it first to find the number of extents to be returned, then call it again and are surprised when there are more extents than what they expecting (i.e. skipping the end of the file).

At the filefrag level I can understand that it already knows intimate details of the on-disk layout for FIBMAP, so it wouldn't be terrible to have it "fudge" the extent reporting if there is a one-block gap every $BLOCKSIZE/4 blocks in the file data.  That would mean filefrag could not just "count" the extents, but would need to get the full extent data and process it for block-mapped files.

Actually requesting the metadata via a new FIEMAP_FLAG_METADATA in the request, and marking the returned extents with FIEMAP_EXTENT_METADATA would avoid the guesswork, since even filefrag with FIBMAP is not really sure that the indirect blocks are in the holes, it is just guessing.


In my previous postings on this topic, I thought it would make sense
to have the "extent" of e.g. an index block be the the logical range
of the file that this index block covers.  The inode itself might be
marked with FIEMAP_EXTENT_INODE|FIEMAP_EXTENT_METADATA and cover the
entire logical range of the file.

This would essentially allow the caller to generate a tree of the
metadata by heirarchical ordering of the extent ranges.

FIEMAP_EXTENT_INODE    [  0-  10GB] [itable blk offset, +inode size]
  FIEMAP_EXTENT_METADATA [  0-   1GB] [index blk offset, +blocksize]
    [data, no flag]      [  0- 128MB] [data offset, +128MB]
    [data, no flag]      [128- 256MB] [data offset, +128MB]
     :
     :
    [data, no flag]      [896-1024MB] [data offset, +128MB]
  FIEMAP_EXTENT_METADATA [1GB-   2GB] [index blk offset, +blocksize]
    [data, no flag]      [1024-1280MB] [data offset, +128MB]
     :
     :
  (etc)

Cheers, Andreas





