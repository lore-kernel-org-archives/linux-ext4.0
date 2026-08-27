Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5FC3DBD54
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 12:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787833276; cv=none; b=NA8P3XJJl03EuE3T2laCf5ScpueAPvNnPIp7e/tElsGpc9oedi8dyKygHzt1qSzQ2Rz+MU6eSfyaFaSsHVTw22oqGOXt0eoIRimVCK8YkuHFf/rmj8iGcGTcpxRFcGBUMlTRofTsulT1Mdpa4oiSu6tbEA4vkGQjj3Knrx5G34o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787833276; c=relaxed/simple;
	bh=X+FTJ3CaqyUURB5NhL8ZZqiTmJjIJa3WKcGkjliYo4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0z5yIu+Jdv9tjhQ536NOrsRmGiA0ihQz8NRCAUJNacBkDhPnMYPd7rtK4R48MVS93HHIADCA2nHlMaNfwU899a1V9PCn/PNz6M5Ezu+qgQHElvLtDi152hqzJZ7h7UNG9FerhJ/NYcKKerkixRU4kHRGhbRxxlBTommsGcltfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=N1NrrLWL; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="N1NrrLWL"
Received: by linux.microsoft.com (Postfix, from userid 1217)
	id 30E2C20B7167; Thu, 27 Aug 2026 05:20:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 30E2C20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787833242;
	bh=77o1LH+SRzAPTn0UHo8mOCi2BedIEaJxOyPGf5p08Sc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N1NrrLWLXaGDJ2vBksmBa43YU7R+Zfrr7OyXN8k3TPWTjVWPppm/+ilsC+18Z+Sre
	 4RAOfz0PourRcfDAdmfrgp1eP7ruSXPpMdV1UaO4ZcOkyYLAlzYBa+ebBTwp96+PNe
	 kubQokucfA7/xMmuxFzPeynYPTGZD+Vv8y4zWC7I=
Date: Thu, 27 Aug 2026 05:20:42 -0700
From: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, srivatsa@csail.mit.edu
Subject: Re: [PATCH v2] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
Message-ID: <apArmuXXwb6Ro0DL@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <aoxF8FvVffocUSyI@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
 <20260824224006.GB6038@frogsfrogsfrogs>
 <ao7ygPaBH1AVudFR@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <8C5E6B25-DF64-4437-9269-3A7E0FC932D1@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8C5E6B25-DF64-4437-9269-3A7E0FC932D1@dilger.ca>

On Thu, Aug 27, 2026 at 01:33:45AM -0600, Andreas Dilger wrote:
> On Aug 26, 2026, at 08:04, Nandakumar Raghavan <naraghavan@linux.microsoft.com> wrote:
> > 
> > On Mon, Aug 24, 2026 at 03:40:06PM -0700, Darrick J. Wong wrote:
> >> On Mon, Aug 24, 2026 at 09:15:11AM -0700, Nandakumar Raghavan wrote:
> >>> During journal replay, e2fsck writes the primary superblock back to disk
> >>> in multiple I/O operations. The payload lands before the checksum, leaving
> >>> a transient window where the on-disk superblock has a bad checksum.
> >>> 
> >>> If udevd processes a change uevent during this window, libblkid probes the
> >>> primary superblock, finds a checksum mismatch, and concludes the partition
> >>> has no recognisable filesystem. udev then fires a remove event, wiping all
> >>> symlinks in /dev/disk/by-label/ and /dev/disk/by-uuid/. Any mount unit
> >>> that depends on those symlinks will fail.
> >>> 
> >>> udevd already serialises its own partition probes against whole-disk device
> >>> access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it requeues the
> >>> event. Take advantage of this protocol by acquiring flock(LOCK_EX) on the
> >>> whole-disk device before opening the filesystem. This forces udevd to defer
> >>> all probes on that disk until e2fsck exits and the lock is released, by
> >>> which point the filesystem is fully consistent.
> >>> 
> >>> The whole-disk device is resolved via sysfs (/sys/dev/block/MAJ:MIN/partition)
> >>> so that the lock covers the same device node that udevd locks. If sysfs
> >>> resolution fails, a warning is emitted and the lock falls back to the
> >>> partition device itself.
> >>> 
> >>> This mechanism relies on Linux-specific interfaces (sysfs, flock() semantics
> >>> on block devices) and is compiled out entirely on non-Linux platforms.
> >> 
> >> You're clearly implementing the "Locking Block Device Access" protocol
> >> as documented by systemd:
> >> https://systemd.io/BLOCK_DEVICE_LOCKING/
> >> 
> >> So why not use libsystemd like the example in that posting provides?
> >> sd_device_get_parent_with_subsystem_devtype is much less gross than
> >> open-coding the same logic here.
> > This was on purpose and not something I missed. The sd_device_get_parent_with_subsystem_devtype
> > requires libsystemd v251+, and e2fsck needs to keep working in contexts where
> > that dependency isn't available or isn't guaranteed to be new enough -
> > non-systemd distros, older LTS systems doing root-fs repair before userspace
> > is fully up, embedded/recovery images, etc.
> > Taking a hard runtime dependency on a versioned libsystemd API for a tool
> > this fundamental felt like a much bigger cost than by parsing (/sys/dev/block/MAJ:MIN/partition, .../dev), which only relies on a stable
> > kernel ABI with no library and no version floor. Happy to reconsider if
> > the project wants to take the dependency, but wanted to flag the tradeoff
> > explicitly rather than silently pick one side.
> 
> I for one am not eager to have e2fsprogs depend on libsystemd to build.
> 
> >> 
> >>> Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
> >>> ---
> >>> 
> >>> @@ -1488,6 +1580,10 @@ int main (int argc, char *argv[])
> >>> 
> >>> check_mount(ctx);
> >>> 
> >>> +#ifdef __linux__
> >>> + lock_fd = lock_whole_disk(ctx, ctx->filesystem_name);
> >> 
> >> If the filesystem has an external journal device, doesn't that also need
> >> locking?
> > 
> > Good point, and no, it doesn't currently - lock_whole_disk() is only called on
> > ctx->filesystem_name. An external journal device (-O journal_dev) is a separate
> > block device with its own by-uuid symlinks, and I don't have a strong argument
> > that it's immune to the same class of race during replay. I'd like to treat
> > this as a follow-up rather than block on it, since it needs a bit more digging
> > into whether the external journal's own superblock write pattern actually
> > creates the same transient-bad-checksum window - but I don't want to just wave
> > it away either.
> 
> At one point I was working on having jbd2 "mount" the journal device, and then
> ext4 would connect to the running journal as a "service", rather than having
> the journal device be mounted exclusively as subpart of the ext4 filesystem.
> I might have even posted patches for this to the list (maybe 15 years ago?)
> 
> This was intended to solve a number of issues:
> - ensuring that the jbd2 block device was visibly "in use" to userspace
> - allow a single jbd2 device (e.g. on NVMe) to be shared among multiple ext4
>   filesystems (on HDDs)
> 
> That shared device would have been much more useful when HDDs were prevalent
> and an NVMe device was harder to share (e.g. before LVM/DM).  It had some other
> issues like what to do if there are journaled blocks to recover but one of the
> using filesystems does not mount and recover them? Maybe copy those blocks to
> the end of the journal and shrink the usable journal size?
> 
> It still has some appeal from the visibility POV, and for sharing it avoids
> stranding dedicated NVMe journal space on one inactive filesystem when other
> busy filesystems could be sharing the space.
> 
> Cheers, Andreas
Thanks for the history, Andreas and I can see how it would solve the visibility
problem more fundamentally than one-off locking external journal devices case by case.

That said, it sounds like a much bigger architectural change than what I'm
trying to do here. I'll keep it in mind as background, but for this patch
I'd still like to treat "should the external journal device also get
locked" as a narrower, separate follow-up rather than pull in a jbd2
redesign.
> 
> 
> 
> 
