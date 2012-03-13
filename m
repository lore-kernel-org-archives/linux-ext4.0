From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Tue, 13 Mar 2012 17:33:04 -0400
Message-ID: <20120313213304.GB11969@thunk.org>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
 <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
 <20120310044804.GB5652@thunk.org>
 <4F5F9A97.5060404@ubuntu.com>
 <20120313195339.GA24124@thunk.org>
 <4F5FAC9C.9070607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Phillip Susi <phillsusi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44189 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab2CMVdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Mar 2012 17:33:07 -0400
Content-Disposition: inline
In-Reply-To: <4F5FAC9C.9070607@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 13, 2012 at 04:22:52PM -0400, Phillip Susi wrote:
> 
> I think a format change would be preferable to runtime sorting.

Are you volunteering to spearhead the design and coding of such a
thing?  Run-time sorting is backwards compatible, and a heck of a lot
easier to code and test...

The reality is we'd probably want to implement run-time sorting
*anyway*, for the vast majority of people who don't want to convert to
a new incompatible file system format.  (Even if you can do the
conversion using e2fsck --- which is possible, but it would be even
more code to write --- system administrators tend to be very
conservative about such things, since they might need to boot an older
kernel, or use a rescue CD that doesn't have an uptodate kernel or
file system utilities, etc.)

> So the index nodes contain the hash ranges for the leaf block, but
> the leaf block only contains the regular directory entries, not a
> hash for each name?  That would mean that adding or removing names
> would require moving around the regular directory entries wouldn't
> it?

They aren't sorted in the leaf block, so we only need to move around
regular directory entries when we do a node split (and at the moment
we don't support shrinking directories), so we don't have to worry the
reverse case.

> I would think that hash collisions are rare enough that reading a
> directory block you end up not needing once in a blue moon would be
> chalked up under "who cares".  So just stick with hash, offset pairs
> to map the hash to the normal directory entry.

With a 64-bit hash, and if we were actually going to implement this as
a new incompatible feature, you're probably right in terms of
accepting the extra directory block search.

We would still have to implement the case where hash collisions *do*
exist, though, and make sure the right thing happens in that case.
Even if the chance of that happening is 1 in 2**32, with enough
deployed systems (i.e., every Android handset, etc.) it's going to
happen in real life.

					- Ted




