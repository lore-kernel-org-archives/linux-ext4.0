From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: dumpe2fs: only print 'unused inodes' once
Date: Thu, 11 Sep 2014 08:53:09 -0400
Message-ID: <20140911125309.GC15632@thunk.org>
References: <BAY179-W101B94761503C2D6FBA0CBFDCE0@phx.gbl>
 <20140909194746.GF10351@birch.djwong.org>
 <20140910213843.GB15632@thunk.org>
 <20140910214746.GJ10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: TR Reardon <thomas_reardon@hotmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50685 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbaIKMxO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 08:53:14 -0400
Content-Disposition: inline
In-Reply-To: <20140910214746.GJ10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2014 at 02:47:46PM -0700, Darrick J. Wong wrote:
> > 
> > Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
> >   Primary superblock at 0, Group descriptors at 1-1
> >   Reserved GDT blocks at 2-512
> >   Block bitmap at 513 (+513), Inode bitmap at 529 (+529)
> >   Inode table at 545-1056 (+545), Checksum 0xe0c6
> 
> But... 0xE0C6 is the group descriptor checksum.  Since we report the bitmap
> csum after mentioning them:
> 
> >  Block bitmap at 2 (+2), csum 0xc759340d, Inode bitmap at 18 (+18), csum 0x941e2bba
> 
> It would make more sense to report the group checksum on the first line:
> 
> Group 0: (Blocks 0-32767) csum 0xe0c6 [ITABLE_ZEROED]                                     
> 

Good point, I was thinking more about about the case where we only had
checksums on the block group.  But in the case of metadata_csum, where
everything is checksummed, your suggestion is much better.

I'm not too worried about breaking scripts; dumpe2fs hasn't had a
stable format in a while.  And breaking it for 1.43 is probably
acceptable.

We should probably add stable way of extracting information about the
location of the bitmaps and inode table to debugfs, though.  Something
where we do something like this:

0:0:1:9:1025:1041:1057
1:32768:32769:32777:1026:1042:1569
2:-1:-1:-1:1027:1043:2081

where we use colon separated fields for the group number, and the
location of the superblock, group descriptors, block bitmap, inode
bitmap, and inode table.  Becasue that sort of thing is really useful
when trying to annotate a blktrace output (and there's a script that I
should find and drop into contrib that does exactly that).

					- Ted
