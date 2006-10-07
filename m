From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Get rid of extents mount option - try 2
Date: Sat, 7 Oct 2006 13:20:27 -0400
Message-ID: <20061007172027.GB5478@thunk.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com> <20061005205526.7fe744f5.akpm@osdl.org> <20061006122105.GA21816@thunk.org> <1160169015.8658.50.camel@kleikamp.austin.ibm.com> <1160169700.8658.56.camel@kleikamp.austin.ibm.com> <20061006153219.d5b62ee8.akpm@osdl.org> <1160176800.8658.70.camel@kleikamp.austin.ibm.com> <20061007041439.GA5478@thunk.org> <1160236427.14217.14.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39598 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S932354AbWJGRUu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Oct 2006 13:20:50 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
Content-Disposition: inline
In-Reply-To: <1160236427.14217.14.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Oct 07, 2006 at 10:53:47AM -0500, Dave Kleikamp wrote:
> I noticed we are missing Documentation/filesystems/ext4.txt.  Over the
> weekend, I'll try to put something together with instructions on getting
> the right version of e2fsprogs, etc.

For now just say to grab the latest from:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim

We'll have to upgrade it once we have a released version of e2fsprogs
that supports extents (although by then we may need e2fsprogs-interim
for 48 or 64 bit extents, or whatever next new feature we're working
on :-).

> I guess this would be useful to turn the feature off immediately after
> turning it on, but with the removal of the extents mount option, we no
> longer have the ability to make old-style files once the feature is
> turned on.  So it's unlikely that you'd be able to turn the feature off
> once a file system has been used.

Well, we could have tune2fs scan all inodes, and have it allocate
triple/double/indirect blocks to replace the extent tree, at some
point.  The count would allow us to turn it off immediately after
turning it on without forcing the full scan of all inodes.  Maybe it's
not worth the overhead though.  

> Also, do we update the superblock in every transaction that creates or
> deletes a file?  Otherwise, how do we guarantee the count is accurate
> after replaying the journal?

Yes, we do.  The number of free inodes has to be kept up-to-date,
after all, so the superblock is marked dirty and as being part of the
transaction.

						- Ted
