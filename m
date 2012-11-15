From: "George Spelvin" <linux@horizon.com>
Subject: Re: 64bit + resize2fs... this is Not Good.
Date: 14 Nov 2012 22:43:03 -0500
Message-ID: <20121115034303.3956.qmail@science.horizon.com>
References: <20121114233854.GD24980@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:39496 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2992461Ab2KODnF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Nov 2012 22:43:05 -0500
In-Reply-To: <20121114233854.GD24980@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> It's actually not 1000x times.  It's a 1000x times up to a maximum of
> 1024 current and reserved gdt blocks (which is the absolute maxmimum
> which can be supported using resize_inode feature).  Contrary to what
> you had expected, it's simply not possible to have 2048 or 4096
> reserved gdt blocks using the resize_inode scheme.  That's because it
> stores in the reserved gdt blocks using an indirect/direct scheme, and
> that's all the sapce that we have.  (With a 4k block, and 4 bytes per
> blocks --- the resize_inode scheme simply completely doesn't work if
> above 16TB since it uses 4 byte block numbers --- 4k/4 = 1024 block group
> descriptors.)

Er... you can't use extents?  The blocks *are* all contiguous.

>> Yeah, I see how that would cause problems, as you ask for 51.5G of
>> resize range.  What pisses me off is that I asked for 64 TiB!
>> (-E resize=17179869184)

> Yes, mke2fs should have issued an error message to let you know
> there's no way it could honor your request.

As long as I get to be at least a *little* bit grumpy that *both*
mke2fs and resize2fs, when asked to do something they couldn't to,
failed to produce any sort of error message, but silently f***ed it up.

> Again, I'm really sorry; you were exploring some of the less well
> tested code paths in e2fsprogs/resize2fs.  :-(

I seem to be developing a knack for that this last couple of months. :-(

I *thought* I was doing the obvious thing.

All I set out to do was expand a 10 TB RAID to 22 TB.
Really, everything I did I *thought* I chose the *safest*
possible option.

1. Restripe RAID
2. Try to resize FS, hit 16 TB limit.
3. Restripe RAID back down.
4. Create new 8 TB RAID from new drives
5. Format with 64-bit ext4, telling mke2fs that I will be resizing later.
5a. Fight with bug in mke2fs while doing so.

6. Copy over files from 32-bit FS
7. Destroy old RAID, and add drives to new RAID
8. Restripe up to 22 TB (again!)
9. Resize file system.  Personally, an off-line technique
  "feels safer" than on-line, so I went with that.

10. Kablooie!

Other than skipping the first 3 steps, what was I supposed to
do different?
