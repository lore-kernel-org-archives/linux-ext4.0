Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF4F3812F0
	for <linux-ext4@vger.kernel.org>; Mon,  5 Oct 2026 21:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791237222; cv=none; b=gjhA2yWazPcpoKgfLIWEhmYlCNT2oe7ZjlSscFT2iRhptsrDCl2P7VF6VrYBvg3P8fRlCGPg5ogkPGCl+AOi1LjOXcgCo2vk61t29AG8nmWrQqDGJXANidyh7EqHSgiygVdTyjA0HhkA24Z+0TVgkTd+mCnbrB6V5JdXkunG5fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791237222; c=relaxed/simple;
	bh=a3MOrtqJIYgyAd0vmm8ZuSFi+r+bRngwRMxO6oEj6rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IlWXP2LO4s5umQ0qRkpcOgoQOY1pPSLE5FOzvd9f8vKbWfwcJQQnAPnPYQ198p7Pdlm1Ar9TsJ9ZLhYB4Pc/f656ghJnIMKOYrqcw7787DQ00yu3NMPL3V2uPW14TIUdIeGoY0OGqxwDh5HeO8P5V5RHaqD3c0dHZHYi8IMBFyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/md7v5b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/md7v5b"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A97AC1F000FF;
	Mon,  5 Oct 2026 21:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791237220;
	bh=LC38sweBk7HjKctrNNxzjOt3CoTdW/7g/QTtX00S2zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F/md7v5b5erOfwyEXcv4qGNHD6vTaTc+xy1SPDaHFSzyplVR6xA/vNeodW4g19CEu
	 Q88ROpl5z8lbC3bUoaJ33aXuViK4FdDlk4kk8krL8cCVM9WniBej8Edc93vCamyBP+
	 i263D4uuff/04aQH5UompLvh4UJ/elRlkoFyqUGlSwKo9Va2LpzEv3Olq8xwG7k7/o
	 MAM88Ri9TRqtu19FvvpF/vmyeS63NG5fbfZT2DkXrQf+Z/VZg1WkaYuX66jWNq8KGI
	 +/rYieM+mU/obew5tBZL2QbyAEI8uOv4H5DOPvafMdXbTTJIfI0RQVIwBCy3VD8NYe
	 GHpvcUlO28c2Q==
Date: Mon, 5 Oct 2026 14:53:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Mike Small <smallm@sdf.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
	Nandakumar Raghavan <naraghavan@linux.microsoft.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	srivatsa@csail.mit.edu
Subject: Re: [PATCH v3] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
Message-ID: <20261005215340.GG1615495@frogsfrogsfrogs>
References: <apCRFu5vpNxRLO8Y@mit.edu>
 <20260910120441.1017866-1-naraghavan@linux.microsoft.com>
 <arC0q5wHTuakmtW9@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <1a5d4f15-3d6b-2476-d0be-493606c17c17@ieee.org>
 <20260924003642.GE6239@frogsfrogsfrogs>
 <chxv77gma8g.fsf@sdf.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <chxv77gma8g.fsf@sdf.org>

On Mon, Oct 05, 2026 at 03:35:11PM +0000, Mike Small wrote:
> "Darrick J. Wong" <djwong@kernel.org> writes:
> 
> > On Wed, Sep 23, 2026 at 03:55:23PM -0400, Dan Streetman wrote:
> >> 
> >> 
> >> On Sun, 20 Sep 2026, Nandakumar Raghavan wrote:
> >> 
> >> > On Thu, Sep 10, 2026 at 05:04:41AM -0700, Nandakumar Raghavan wrote:
> >> > > During journal replay, e2fsck writes the primary superblock back to disk
> >> > > in multiple I/O operations. The payload lands before the checksum, leaving
> >> > > a transient window where the on-disk superblock has a bad checksum.
> >> > > 
> >> > > If udevd processes a change uevent during this window, libblkid probes the
> >> > > primary superblock, finds a checksum mismatch, and concludes the partition
> >> > > has no recognisable filesystem. udev then fires a remove event, wiping all
> >> > > symlinks in /dev/disk/by-label/ and /dev/disk/by-uuid/. Any mount unit
> >> > > that depends on those symlinks will fail.
> >> > > 
> >> > > udevd already serialises its own partition probes against whole-disk device
> >> > > access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it requeues the
> >> > > event. Take advantage of this protocol by acquiring flock(LOCK_EX) on the
> >> > > whole-disk device before opening the filesystem. This forces udevd to defer
> >> > > all probes on that disk until e2fsck exits and the lock is released, by
> >> > > which point the filesystem is fully consistent.
> ...
> >> > Gentle ping on this patch.
> >> > 
> >> > I would appreciate any feedback.
> >> > 
> >> 
> >> Can you clarify why this should go into only fsck.ext4? Doesn't this
> >> problem exist for other filesystems too?
> >> 
> >> I sent an earlier email as well with links to:
> >> 
> >> 1) fsck used to lock the device, but it surfaced a bug in udevd
> >> https://bugs.freedesktop.org/show_bug.cgi?id=79576
> >> 
> >> 2) because of the bug, fsck stopped locking the device
> >> https://github.com/util-linux/util-linux/commit/3bbdae633f4a1dda5f95ee6c61f18a1c8ef12250
> >> 
> >> 3) the systemd-udevd bug was fixed
> >> https://github.com/systemd/systemd/commit/5d354e525a5
> >> 
> >> To me, it makes more sense for the locking that already exists in fsck
> >> to get updated (or reverted) to lock the entire device, using the
> >> existing -l param (or maybe a new param like --lock-device,
> >> --udevd-lock, etc., if util-linux maintainers don't want to change -l
> >> behavior).
> >> 
> >> Do you see an issue with doing the locking there instead of here in
> >> fsck.ext4?
> >
> > /sbin/fsck (aka the dispatch wrapper program) doesn't necessarily know
> > which block device(s) are going to be opened by a the fsck.$FSTYP
> > program that it creates.  It might be able to infer that by opening any
> > parameter and performing the udev locking protocol after checking if
> > what it opened is a block device, but that wouldn't work for (say) a
> > fsck.XXX program for a multi-device filesystem wherein you only need to
> > specify one device and it will find the others.
> >
> > That said, this patchset also doesn't handle multi-device ext4
> > filesystems (i.e. external jbd2 journal device) because the author
> > doesn't want to do that.  In their defense, the udev flock()ing protocol
> > requires one to determine if an opened block device is a partition; if
> > it is, then it requires opening and locking the parent bdev (e.g. sdf1
> > -> sdf) instead of locking the original device.  This makes it way more
> > complicated for multi-device filesystems because now the client has to
> > detect multiple partitions coming from the same underlying device and
> > handle that appropriately.  I don't know why the protocol designers made
> > that choice.
> >
> > I can run "trace-cmd record -e 'flock*'" to observe the locking
> > interactions with scsi disk partitions, but for whatever reason I don't
> > see any flocking going on if I use kpartx to create the partitions with
> > device-mapper.  No idea why that is.
> >
> > --D
> 
> Systemd-udevd will not take its shared lock when the device in the
> uevent starts with "dm-", "md", or "drbd". See udev_get_whole_disk() in
> src/udev/udev-worker.c and how that's used by worker_lock_whole_disk().

Doesn't that mean that blkid and e2fsck can still stomp on each other if
the device is /dev/dm-0 ?

That's not in the specification, which means that for us, it's an
undocumented implementation detail.

> Maybe that explains you not seeing the flocks in the second case. Would
> the partition device names (or what their symlinks expand to?) look like
> /^dm-*/?

(For kpartx, yes it does since it uses dm to create partition devices)

But the fact that udev doesn't take the flock *at all* on dm/md/drbd
devices makes this whole proposal feel pointless.  Why would we add more
code to e2fsprogs to satisfy a locking protocol that even the supposed
benefactor doesn't follow consistently?

--D

> Regards,
> Mike Small
