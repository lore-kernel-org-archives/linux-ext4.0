From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Wed, 20 Apr 2011 11:21:31 -0400
Message-ID: <20110420152131.GA7123@infradead.org>
References: <4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
 <20110418004040.GS21395@dastard>
 <6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
 <BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
 <20110419034455.GB23985@dastard>
 <BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
 <20110419074538.GG23985@dastard>
 <20110419140909.GD3030@thunk.org>
 <4DAD987F.5000506@sandeen.net>
 <20110419160114.GE3030@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <david@fromorbit.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>, xfs-oss <xfs@oss.sgi.com>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	P?draig Brady <P@draigbrady.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1DTPVq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Apr 2011 11:21:46 -0400
Content-Disposition: inline
In-Reply-To: <20110419160114.GE3030@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 19, 2011 at 12:01:14PM -0400, Ted Ts'o wrote:
> 1) We define it as only reflecting ondisk state, and nuke the delalloc
> flag from orbit.
> 
> 2) We state that if the file is currently has unflushed pages in the
> page cache, and FIEMAP_FLAG_SYNC is not passed, whether or not extents
> return the DELALLOC flag or how they handle the UNWRITTEN flag is
> undefined.

That seems like a weird option, as the pagecache state really has
nothing to do at all with the extent layout, and the existence of dirty
pages really has nothing to do with the unwritten flag.

> 3) We state that FIEMAP is supposed to return information which
> reflects the union of the on-disk and page cache state, with all that
> this implies.

How do you want to union the existance of an extent with a state
on disk, with a pending modification to it that is still in-memory
and not flushed out to disk yet?  This is looking into an uncertain
future, as the extent map might change in various other ways before
the transaction to conver the unwritten extents goes to disk.

And if we do this it would need to be a new option to FIEMAP, as
it changes the semantics from the existing one that returns the
actual state on disk (plus the magic delalloc bit).

And even if you find semantics that take pending unwrittent extent
conversions into account and still make sense how do you plan to
implement them?  For buffered writes into unwritten extents it could
be done by walking the pagecache and buffers after adding a new
flag for an already converted unwritten extent to the buffer head
state.  But there's no easy way to do that for direct I/O.

> In the case of #1 and #2, we really need to implement support for
> SEEK_HOLE/SEEK_DATA for userspace programs like cp who want to know
> this information.

We need to do that anyway, as fiemap is a horrible interface for
tools that just want to skip holes.  

