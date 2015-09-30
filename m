From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] tune2fs: don't change UUID on a mounted metadata_csum fs
Date: Tue, 29 Sep 2015 19:21:08 -0600
Message-ID: <8B6E949A-7397-49BB-84BC-72479FE0F7A7@dilger.ca>
References: <20150929153122.GJ10390@birch.djwong.org> <20150929224621.GC2989@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34145 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbI3BVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Sep 2015 21:21:13 -0400
Received: by padhy16 with SMTP id hy16so22076389pad.1
        for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2015 18:21:12 -0700 (PDT)
In-Reply-To: <20150929224621.GC2989@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 29, 2015, at 16:46, Theodore Ts'o <tytso@mit.edu> wrote:
> 
>> On Tue, Sep 29, 2015 at 08:31:22AM -0700, Darrick J. Wong wrote:
>> It's not safe to change the UUID on a mounted filesystem when the
>> metadata_csum feature is enabled because there's (currently) no
>> way to update the kernel's CRC seeds, which precompute the UUID
>> component of the checksum for all metadata blocks.  Not to mention
>> that we'd have to rewrite /all/ metadata blocks, and any kernel disk
>> accesses will race with tune2fs, thus destroying the filesystem.
> 
> It's not safe, but if you know what you're doing, it can work if the
> root file system is quiscent (or preferably, mounted read-only) and if
> you reboot immediately afterwards.
> 
> In point of fact, the use case that inspired me to add this was
> wanting to change the UUID right before creating a GCE image such that
> it has a different UUID from the UUID from the base OS image that you
> used to create the image.

I don't see how changing the UUID for mounted file systems can work
for metadata_csum file systems?

Wouldn't this cause a checksum error for every piece of metadata?

For regular file systems it wouldn't be fatal so long as the group descriptors
are written out to disk again with the new checksum. 

> And with metadata_csum, you can't even use
> 'debugfs -R "ssv uuid random"' to reset the uuid, since it won't
> update the all of the metadata blocks.  The only way to update the
> uuid while the root file system is mounted is to use "tune2fs -f -U
> random".
> 
> If the concern is that it's too dangerous to do this even with the -f
> option, maybe we could require two -f option --- i.e., "tune2fs -f -f
> -U random /dev/sda1".

I'd rather something like --force-uuid or similar so that it is clear what is
being forced, since "-f" is too overloaded to mean different things. 

> Or maybe we could require that the root file
> system be mounted read-only, and adding a warning that this the
> sytstem should be rebooted immediately afterwards.

I still don't think this can help for metadata_csum?

Cheers, Andreas
