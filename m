Received: from mx.sdf.org (ol.sdf.org [205.166.94.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA574BE443
	for <linux-ext4@vger.kernel.org>; Mon,  5 Oct 2026 15:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.166.94.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791214713; cv=none; b=Q6ElqYsF7emd2G0AoylKrO1+Mn0rZadZSGuog1sfT9DDnJ62oGJLi3EegYAcSnGxIinQJeOcekMGXoR0TfKehHv6bzR8hkFMxDd/0zdkcIyqQrCTD2UBncNQ4hV58XeoV++7leVSYVdv2OC7HoFZ9bLB4OtMRQbigmowETQ6hc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791214713; c=relaxed/simple;
	bh=XH2uLPE1HhpBo0dMPAX/KEcu0I2LN/r7sXVe5oMIAXc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Dr4cfX3lTMuogmhGU16ry3pz9MrMn9eiZtd9YhL+5aHbXZhnXCOL8khKvdMm5W7GYPoDupHDi4QvZilRWZZxZdpFeNu92omNNfBNd8/84QmApSMHZ7k1PVaZoAw64FO5YYDg++eABsMQImX6KprOpAwkmkGMz/QdLs86MlMae0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sdf.org; spf=pass smtp.mailfrom=sdf.org; arc=none smtp.client-ip=205.166.94.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sdf.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sdf.org
Received: from sdf.org (iceland.freeshell.org [205.166.94.5])
	by mx.sdf.org (8.18.1/8.14.3) with ESMTPS id 695FZDMU001124
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
	Mon, 5 Oct 2026 15:35:13 GMT
Received: (from smallm@localhost)
	by sdf.org (8.18.1/8.12.8/Submit) id 695FZBJg015392;
	Mon, 5 Oct 2026 15:35:11 GMT
From: Mike Small <smallm@sdf.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
        Nandakumar Raghavan
 <naraghavan@linux.microsoft.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
        srivatsa@csail.mit.edu
Subject: Re: [PATCH v3] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
In-Reply-To: <20260924003642.GE6239@frogsfrogsfrogs> (Darrick J. Wong's
	message of "Wed, 23 Sep 2026 17:36:42 -0700")
References: <apCRFu5vpNxRLO8Y@mit.edu>
	<20260910120441.1017866-1-naraghavan@linux.microsoft.com>
	<arC0q5wHTuakmtW9@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
	<1a5d4f15-3d6b-2476-d0be-493606c17c17@ieee.org>
	<20260924003642.GE6239@frogsfrogsfrogs>
Date: Mon, 05 Oct 2026 15:35:11 +0000
Message-ID: <chxv77gma8g.fsf@sdf.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Wed, Sep 23, 2026 at 03:55:23PM -0400, Dan Streetman wrote:
>> 
>> 
>> On Sun, 20 Sep 2026, Nandakumar Raghavan wrote:
>> 
>> > On Thu, Sep 10, 2026 at 05:04:41AM -0700, Nandakumar Raghavan wrote:
>> > > During journal replay, e2fsck writes the primary superblock back to disk
>> > > in multiple I/O operations. The payload lands before the checksum, leaving
>> > > a transient window where the on-disk superblock has a bad checksum.
>> > > 
>> > > If udevd processes a change uevent during this window, libblkid probes the
>> > > primary superblock, finds a checksum mismatch, and concludes the partition
>> > > has no recognisable filesystem. udev then fires a remove event, wiping all
>> > > symlinks in /dev/disk/by-label/ and /dev/disk/by-uuid/. Any mount unit
>> > > that depends on those symlinks will fail.
>> > > 
>> > > udevd already serialises its own partition probes against whole-disk device
>> > > access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it requeues the
>> > > event. Take advantage of this protocol by acquiring flock(LOCK_EX) on the
>> > > whole-disk device before opening the filesystem. This forces udevd to defer
>> > > all probes on that disk until e2fsck exits and the lock is released, by
>> > > which point the filesystem is fully consistent.
...
>> > Gentle ping on this patch.
>> > 
>> > I would appreciate any feedback.
>> > 
>> 
>> Can you clarify why this should go into only fsck.ext4? Doesn't this
>> problem exist for other filesystems too?
>> 
>> I sent an earlier email as well with links to:
>> 
>> 1) fsck used to lock the device, but it surfaced a bug in udevd
>> https://bugs.freedesktop.org/show_bug.cgi?id=79576
>> 
>> 2) because of the bug, fsck stopped locking the device
>> https://github.com/util-linux/util-linux/commit/3bbdae633f4a1dda5f95ee6c61f18a1c8ef12250
>> 
>> 3) the systemd-udevd bug was fixed
>> https://github.com/systemd/systemd/commit/5d354e525a5
>> 
>> To me, it makes more sense for the locking that already exists in fsck
>> to get updated (or reverted) to lock the entire device, using the
>> existing -l param (or maybe a new param like --lock-device,
>> --udevd-lock, etc., if util-linux maintainers don't want to change -l
>> behavior).
>> 
>> Do you see an issue with doing the locking there instead of here in
>> fsck.ext4?
>
> /sbin/fsck (aka the dispatch wrapper program) doesn't necessarily know
> which block device(s) are going to be opened by a the fsck.$FSTYP
> program that it creates.  It might be able to infer that by opening any
> parameter and performing the udev locking protocol after checking if
> what it opened is a block device, but that wouldn't work for (say) a
> fsck.XXX program for a multi-device filesystem wherein you only need to
> specify one device and it will find the others.
>
> That said, this patchset also doesn't handle multi-device ext4
> filesystems (i.e. external jbd2 journal device) because the author
> doesn't want to do that.  In their defense, the udev flock()ing protocol
> requires one to determine if an opened block device is a partition; if
> it is, then it requires opening and locking the parent bdev (e.g. sdf1
> -> sdf) instead of locking the original device.  This makes it way more
> complicated for multi-device filesystems because now the client has to
> detect multiple partitions coming from the same underlying device and
> handle that appropriately.  I don't know why the protocol designers made
> that choice.
>
> I can run "trace-cmd record -e 'flock*'" to observe the locking
> interactions with scsi disk partitions, but for whatever reason I don't
> see any flocking going on if I use kpartx to create the partitions with
> device-mapper.  No idea why that is.
>
> --D

Systemd-udevd will not take its shared lock when the device in the
uevent starts with "dm-", "md", or "drbd". See udev_get_whole_disk() in
src/udev/udev-worker.c and how that's used by worker_lock_whole_disk().
Maybe that explains you not seeing the flocks in the second case. Would
the partition device names (or what their symlinks expand to?) look like
/^dm-*/?

Regards,
Mike Small
