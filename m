From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: don't change UUID on a mounted metadata_csum fs
Date: Tue, 29 Sep 2015 18:46:21 -0400
Message-ID: <20150929224621.GC2989@thunk.org>
References: <20150929153122.GJ10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50322 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbbI2WqY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Sep 2015 18:46:24 -0400
Content-Disposition: inline
In-Reply-To: <20150929153122.GJ10390@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 29, 2015 at 08:31:22AM -0700, Darrick J. Wong wrote:
> It's not safe to change the UUID on a mounted filesystem when the
> metadata_csum feature is enabled because there's (currently) no
> way to update the kernel's CRC seeds, which precompute the UUID
> component of the checksum for all metadata blocks.  Not to mention
> that we'd have to rewrite /all/ metadata blocks, and any kernel disk
> accesses will race with tune2fs, thus destroying the filesystem.

It's not safe, but if you know what you're doing, it can work if the
root file system is quiscent (or preferably, mounted read-only) and if
you reboot immediately afterwards.

In point of fact, the use case that inspired me to add this was
wanting to change the UUID right before creating a GCE image such that
it has a different UUID from the UUID from the base OS image that you
used to create the image.  And with metadata_csum, you can't even use
'debugfs -R "ssv uuid random"' to reset the uuid, since it won't
update the all of the metadata blocks.  The only way to update the
uuid while the root file system is mounted is to use "tune2fs -f -U
random".

If the concern is that it's too dangerous to do this even with the -f
option, maybe we could require two -f option --- i.e., "tune2fs -f -f
-U random /dev/sda1".  Or maybe we could require that the root file
system be mounted read-only, and adding a warning that this the
sytstem should be rebooted immediately afterwards.

In retrospect, we should have used a separate superblock field
containing the UUID for the metadata checksum seed.  This would allow
us to change the UUID used to find the root file system without
needing to jump through hoops.  Unfortunately, as in many things,
hindsight is 20-20.

						- Ted
