From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Collapsing the number of feature flags (was Re: [PATCH v2.3
 00/23] ext4: Add metadata checksumming)
Date: Sat, 11 Feb 2012 21:55:18 -0500
Message-ID: <20120212025518.GA22492@thunk.org>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com>
 <20120208180847.GA3654@thunk.org>
 <3EBD659A-0A10-4DAE-9EA9-E736CE187574@dilger.ca>
 <20120210211131.GB5381@thunk.org>
 <28776282-021D-473A-99A1-F5A3DDC08966@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45425 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab2BLCzY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Feb 2012 21:55:24 -0500
Content-Disposition: inline
In-Reply-To: <28776282-021D-473A-99A1-F5A3DDC08966@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 11, 2012 at 06:38:03PM -0700, Andreas Dilger wrote:
> 
> I think that making it difficult for users to use anything but the default
> options in mke2fs/tune2fs/debugfs is equivalent to what you suggest.
> Unless you prevent the use of the old feature flags entirely, then it
> would still be possible to create filesystems with mixed up combinations
> of features.  I think the important outcome is that users are clearly
> made aware that they are stepping off the well-trodden path, and if
> things break they get to keep both pieces.  Having two feature flags
> that mean the same thing doesn't really help this, IMHO.

The problem is that sometimes people upgrade the kernel before they
upgrade userspace, and sometimes they upgrade e2fsprogs but are still
running an older kernel --- and there times when those are good and
proper things to do (i.e., they have to use some ancient obsolete RHEL
kernel becuase it's they only way they can talk to the EMC storage
device, but they want to use a newer e2fsprogs to fix bugs that have
since been fixed in the latest version of e2fsprogs).

So we have to support both, and so yes, we can't remove any code for
quite a while.  What we *can* do is say that if you enable metadata
checksums, you also must get all of these other features along for the
ride.  It's true that means users can still create mixed up feature
set --- but not if they want the new metadata checksum feature. 

It's an eventual solution, but it's not magic pixie dust, yes.
Realistically most of the time we haven't had *that* many problems
caused by random feature combinations.  There are certain combinations
that are problematic, but we know what they are up front.

If someone really wants to add that screen for certain feature
combinations and causes mke2fs/e2fsck to complain, or maybe even
outright refuse to function, that's a different thing, that's going to
be fairly specific for the distro.  I don't think that's something we
want to add upstream....

						- Ted
