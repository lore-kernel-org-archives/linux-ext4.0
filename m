From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fallocate creating fragmented files
Date: Fri, 1 Feb 2013 08:55:58 -0500
Message-ID: <20130201135558.GA1438@thunk.org>
References: <1359524809.5789.140661184325217.261ED7C8@webmail.messagingengine.com>
 <5108B833.6010004@redhat.com>
 <1359527713.648.140661184334613.06CF38D4@webmail.messagingengine.com>
 <510942C3.1070503@redhat.com>
 <20130130201412.GA32724@thunk.org>
 <1359580910.30605.140661184656041.31047642@webmail.messagingengine.com>
 <20130130214359.GD32724@thunk.org>
 <1359586282.5428.140661184689977.65F0D7DE@webmail.messagingengine.com>
 <1359718401.21008.140661185473973.37F5D749@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robert Mueller <robm@fastmail.fm>,
	Eric Sandeen <sandeen@redhat.com>,
	Linux Ext4 mailing list <linux-ext4@vger.kernel.org>
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46505 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab3BAN4E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Feb 2013 08:56:04 -0500
Content-Disposition: inline
In-Reply-To: <1359718401.21008.140661185473973.37F5D749@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 01, 2013 at 10:33:21PM +1100, Bron Gondwana wrote:
> 
> In particular, the way that Cyrus works seems entirely suboptimal for ext4.
> The index and database files receive very small appends (108 byte per message
> for the index, and probably just a few hundred per write for most of the the
> twoskip databases), and they happen pretty much randomly to one of tens of
> thousands of these little files, depending which mailbox received the message.

Are all of these files in a single directory?  If so, that's part of
the problem, since ext[34] uses the directory structure to try to
spread apart unrelated files, so that hueristic can't be easily used
if all of the files are in a single directory.

> Here's the same experiment on a "fresh" filesystem.  I created this by taking
> a server down, copying the entire contents of the SSD to a spare piece of rust,
> reformatting, and copying it all back (cp -a).  So the data on there is the
> same, just the allocations have changed.
> 
> [brong@imap15 conf]$ fallocate -l 20m testfile
> [brong@imap15 conf]$ filefrag -v testfile
> Filesystem type is: ef53
> File size of testfile is 20971520 (20480 blocks, blocksize 1024)
>  ext logical physical expected length flags
>    0       0 22913025            8182 unwritten
>    1    8182 22921217 22921207   8182 unwritten
>    2   16364 22929409 22929399   4116 unwritten,eof
> testfile: 3 extents found
> 
> As you can see, that's slightly more optimal.  I'm assuming 8182 is the
> maximum number of contiguous blocks before you hit an assigned metadata
> location and have to skip over it.

Is there a reason why you are using a 1k block size?  The size of a
block group is 8192 blocks for 1k blocks (or 8 megabytes), while with
a 4k block size, the size of a block group is 32768 blocks (or 128
megabytes).  In general the ext4 file system is going to be far more
efficient with a 4k block size.

Regards,

					- Ted
