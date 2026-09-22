Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B864CDDFC;
	Tue, 22 Sep 2026 07:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061462; cv=none; b=GesWE8CmYfXf+0bK0tMW7C6gicMWa0D5S/J5fmjw8TsbgFEHb8w968UGuGZn7q38S9/RbeMlnQfTMRvbFVHDHvP2F2BIVyNyb5OTGsDsldv6KAzi1zSUf8grcutubAomXJ8qKI8sMl6DZOK4tPO7TVDDCotUUAVZqWF6bghzESw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061462; c=relaxed/simple;
	bh=g3WT5fQmj5Duph7hbDiDZSq+20odEp9msKA7Z/xy+w8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R+wXwbzZSG8Qec2h/NWWoFNvYvzHncHi068vNK9yl4ZYOvKzQstQmU0huT47FM7HDLiiP29BeTHA2iQBR/On5rEW5sxuw61s6m07PUPN97AWpJZ6Jn5L0mQBdXWGv2uq1/f/+u7VC9nUBEI/qwusDbZmxHFopcuuGRkWOh8isd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=W0+oxVka; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="W0+oxVka"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790061449; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2o4XTylnChwZeUtYXxHKFY/+eW5nR2VcYkBulaZBLeI=;
	b=W0+oxVkaRH9QxaGMjJuGaOQuV/MpmMw7/KEkGEmHx+S9qoN3rNW3mG/pZ+5YkIKGM4ZzGSDhsC9XzH4uhnZnh6K7OxW5gfBJHmmJ65sBHL1z4oJw0XJ/LxG7CVW9Y8d4rQhp65l5omExcASJL/zcO8Xh5mCrg9cBnN60iT38ggc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XBT05Qt_1790061448;
Received: from 30.221.148.19(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBT05Qt_1790061448 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Sep 2026 15:17:28 +0800
Message-ID: <74463cb5-14af-47bb-9380-ca75dc5d293a@linux.alibaba.com>
Date: Tue, 22 Sep 2026 15:17:27 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] generic/492: bypass the blkid cache when probing the
 label
To: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, zlang@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, sandeen@redhat.com, dgc@kernel.org
References: <20260920094137.2749428-1-libaokun@linux.alibaba.com>
 <20260921052719.GB6253@frogsfrogsfrogs>
 <b4a10712-1658-4fba-a037-095fab466270@linux.alibaba.com>
 <20260921234910.GC6253@frogsfrogsfrogs> <arHaTLxSEk3yQxU4@mit.edu>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <arHaTLxSEk3yQxU4@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/9/22 11:43, Theodore Tso wrote:
> On Mon, Sep 21, 2026 at 04:49:10PM -0500, Darrick J. Wong wrote:
>>> The difference between the e2fsprogs and util-linux libblkid is the
>>> time granularity: the former stores seconds only (TIME="%ld",
>>> bid_time = time(0), compares st_mtime <= bid_time), while the latter
>>> stores usec (TIME="sec.usec") and has an nsec tie-break in the compare,
>>> so the same-second case is much easier to hit with the e2fsprogs blkid.
>> Perhaps xfstests-bld should use the system blkid then?  IIRC the one
>> in e2fsprogs is very old and out of date.
> Historically, xfstests-bld was built in environments where libblkid
> wasn't available.  This included Android's runtime (which uses the
> bionic libc), and grte (Google Runtime Environment)[1].
>
> [1] https://github.com/bazelment/lrte/blob/master/grte/grte-build
>
> However, as more and more tests require utilities from util-linux,
> xfstests-bld was taught to build util-linux.  And if util-linux is
> being built, then we don't use e2fsprogs-libs any more, which is where
> libblkid is built.  From build-all:
>
> if test -z "$USE_LOCAL_E2FSLIBS" -o -d util-linux; then
>     SKIP_E2FSLIBS=yes
> fi
>
> I've always built xfstesets-bld with util-linux, even though it is
> listed as an optional repository.  This is because (a) util-linux is
> needed for Android and other non-standard Linux environments, and (b)
> the version of util-linux used by earlier Debian Stable was too old
> for some of the newer tests in fstests and blktests.
>
> If you aren't building xfstests-bld with util-linux, it falls back to
> building libblkid from e2fsprogs-libs.  HOWEVER, we don't actually
> blkid, and libblkid is always built statically.  So what seems to be
> going on is that one of the programs built by xfstests-bld is using
> the older libblkid, and that results in the blkid cache being writen
> with a second granularity.
>
> I've never noticed this issue because I've always built with
> util-linux.  The way to solve this is to require building with the
> system libblkid if util-linux is not being built, and to drop
> e2fsprogs-libs from xfstests-bld.  Or just build xfstests-bld with
> util-linux.  :-)


Thanks for the detailed explanation.

I checked my environment again though -- it turned out not to be
xfstests-bld at all.  xfstests-bld never touches e2fsprogs.

What happened is that I had manually run "make install" of a locally
patched e2fsprogs in the test VM, which overwrote util-linux's blkid
and fsck.

Rebuilding e2fsprogs with these options disabled made the test pass:

    ./configure --disable-libblkid --disable-fsck \
            --disable-libuuid --disable-uuidd

I ran unpatched generic/492 60 times on each side in a VM: 12/60
failures with the hand-installed strays, 0/60 with util-linux's
blkid/fsck.

That said, I think the patch is still needed, because
FS_IOC_SETFSLABEL does not update the block device's mtime:

    blkid -s LABEL ...    # get A
    FS_IOC_SETFSLABEL     # set B (device mtime unchanged)
    blkid -s LABEL ...    # still get A (within 2s)

The first read writes a cache entry with TIME=now, and the ioctl
leaves the device mtime untouched, so a second read within the 2s
window still trusts the cache.

I reproduced this with util-linux 2.41.5 too, so
"blkid -c /dev/null" is what keeps the test deterministic
regardless of which blkid the image carries.


Cheers,
Baokun


