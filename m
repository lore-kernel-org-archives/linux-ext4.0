From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Please summarize state of ext4 resize >16TB
Date: Wed, 8 Jan 2014 15:04:38 -0500
Message-ID: <20140108200438.GB17750@thunk.org>
References: <BBC8F4C34A7B5A4DB487459885025E7F018A0BAE0391@EXCLUSTER.iomegacorp.com>
 <20140108193018.GF9229@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ryan, Michael" <Michael.Ryan2@lenovoemc.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46912 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbaAHUEo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jan 2014 15:04:44 -0500
Content-Disposition: inline
In-Reply-To: <20140108193018.GF9229@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 08, 2014 at 11:30:18AM -0800, Darrick J. Wong wrote:
> 
> In most cases it's necessary to turn on 64bit (the feature flag) to cross the
> 16T boundary.  I've had patches against resize2fs to add this ability--it
> involves moving data blocks and rewriting group descriptors--on the list for a
> few months, but I don't know of Ted's plans to put them in a release.  Probably
> post-1.43, is my guess.

It's something that should eventually hit the master/next branch, so
it should be in an eventual 1.43 release.  Of course, I don't
currently have a timeline for when a 1.43 release would come out.  :-)

Probably in a few months if I had to guess, though.  The 1.42.x
release is pretty much locked down for all but the most trivial new
features, so I will be shortly switching my e2fsprogs focus to testing
and merging in the new features for the 1.43 release.

> I don't have any kernel patches to turn on 64bit, and I haven't any current
> plans to make any.

Turning on 64-bit requires rewriting the block group descriptors, and
searching the inodes to relocate data blocks to make room for the
expanded block group descriptors.  As such, I don't expect that we
would ever support on-line enablement of the 64-bit feature.  If
you've created a file system without the 64-bit feature, or have a
legacy file system that was created previously, you will have to
unmount the file system in order to set the 64-bit feature.

Regards,

						- Ted
