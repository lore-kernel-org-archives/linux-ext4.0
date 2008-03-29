From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Kernel patch: ext2 creators list update
Date: Sat, 29 Mar 2008 08:21:28 -0400
Message-ID: <20080329122128.GA32033@mit.edu>
References: <B897C02B-AB2F-4888-960A-2B72546BD5C1@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Pietro Gagliardi <pietro10@mac.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43356 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbYC2MVg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Mar 2008 08:21:36 -0400
Content-Disposition: inline
In-Reply-To: <B897C02B-AB2F-4888-960A-2B72546BD5C1@mac.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 28, 2008 at 05:54:07PM -0400, Pietro Gagliardi wrote:
> Hello. I'm working on a new OS that will have ext2 as the primary
> filesystem. I'm adding my OS to the list of creators, for the
> superblock item s_creator_os. I know the kernel doesn't use these
> values; I don't know if any user programs do, though.

It turns out s_creator_os was a mistake, because there's no sane way
*to* use it.  You want filesystems to be portable across different
operating systems, so using it to change the interpretation of various
fields causes problem for cross-OS compatibility, if you want to mount
an ext2 filesystem created on FreeBSD on Linux, for example.  So at
best it's only good as a non-functional comment and that's about it.

So more support of this field means that people might do things like
what they did with Hurd, which was absolutely the *wrong* way to do
things.  So for example, if you delete files on a Hurd filesystem on
most other operating systems, the other OS's probably won't know to
remove the Hurd's translator block, resulting in a (mostly harmless)
corrupted filesystem because the translator block won't be freed.  So
the s_creator_os simply because an attractive nuisance, that invites
people to do the Wrong Thing.  (They should have used an RO compat
feature flag instead.)

Fortunately, Hurd never got any real popularity, so the fact that the
Linux kernel doesn't currectly Hurd-variant filesystems isn't a big
deal.  But it was clearly a bad mistake on our part.

So actually, what we should do instead is add coments saying that the
use of s_creator_os is deprecated, and gradually reduce the use of it
entirely.  (Hurd will eventually move its the functionality for
storing an inode's "translator" to an extended attribute, at which
point the need for s_creator_os can actually go away completely.)

	       	       	   	  	- Ted
