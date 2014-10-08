From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] generic/017: skip tests with mkfs failures
Date: Tue, 7 Oct 2014 22:11:02 -0400
Message-ID: <20141008021102.GA20071@thunk.org>
References: <1412619830-23088-1-git-send-email-paul.paulson@seagate.com>
 <20141007005300.GA11741@thunk.org>
 <CAG4SSaSQt15AOOVR50EruW8sq_9Az3W26z+7pHy-2E9D3gOcgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Paul Paulson <paul.paulson@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41644 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaJHCLH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Oct 2014 22:11:07 -0400
Content-Disposition: inline
In-Reply-To: <CAG4SSaSQt15AOOVR50EruW8sq_9Az3W26z+7pHy-2E9D3gOcgg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 07, 2014 at 01:12:51PM -0500, Paul Paulson wrote:
> We'd like to run the full test suite using maximum partition sizes on
> SMR drives for functional and performance evaluation purposes. Since
> drive capacities are increasing so rapidly it would be nice if mke2fs
> would support filesystems up to the maximum configurations specified
> in the Ext4_Disk_Layout document using default filesystem configs. For
> example, the 127877120 inode limit that we ran into is only 3% of the
> number of inodes specified in the document (2^32 inodes in a 4 TiB
> filesystem with 1KiB block sizes for 32-bit mode).

Sure, but the default file system configs don't include 1k block
sizes.  There really is only one reason that I care about the 1k block
size --- it's to make it easy to validate on an x86 architecture what
happens when a file system with a default 4k block size is mounted on
an architectures such as PowerPC or Itanium which has a page size of
16k or 64k.  That is, to test the case where block size < page size.

But we really don't encourage people use a 1k block size in
production.  And while it would make sense from a performance point of
view to use a 16k or 64k block size file system on a PowerPC or
Itanium system, people who care about making their file system
portable across PowerPC and x86 (for example) will need to use a 4k
block file system (since Linux doesn't support block size > page
size). 

So using a 1k block file system on a terabyte file system is neither
the default nor a sane thing to do.  I'll look into making mke2fs
handle this case more smoothly, but it's not something that I consider
a high priority or something I would encourage as a realstic
production use case.

Cheers,

						- Ted
