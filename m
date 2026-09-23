Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D9B3B2D04;
	Wed, 23 Sep 2026 09:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790154794; cv=none; b=SFbpcd/k2g3yzAhwCqC6vUXpw7sxOEXWfXswg15swsw7O8AqvFzuCZ9yvzcVL9bKj/AdbXBgzV+ta81w99mjc+6D4rEgjv1kjz+kIcvyKgrjH0xTVjvEktQECc39zhXQ5y5NdvEUGMM5UM9lzbYDb4jamxILWyWtgV9P7rgB3T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790154794; c=relaxed/simple;
	bh=MDDfBcmpZsiS84VkxriAREG5/EOIBDnwy5z09d5NXnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lgDvHoa8nSQB+F7iASF4XTsjK4kUCHc3qECdDOEjZm2arew4GpRt9WjwKiTqhBu6S6r9uE2SZ6nXalhellR+LBpMhgeWMY6oEHut8739PJBTnr4mrtu4SAlGaP1RuwNYBYNAo4oQVNL1zi1JhgtlvB6HaZDpIy8tFfT7yn+WT90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=uSLZ22e5; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="uSLZ22e5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790154783; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EkmkbW6uWSFKxZa5RPcpAVvadAQXx10Aq1DH3CdSOsk=;
	b=uSLZ22e5dpCAlAqJP73rGbBI95CxtkQB16ImtjBLCkbo03do06rIAvKsuAx73l+8kBcEsFF6qduAGGSn+e1a1Bq+qEEWKa86IYslc+vT/cbxeJq63MSzVULjFHPhETd8poK6d8q/I8yviPB4fBuryjVD8ef9ldrDQz7n6jPbyDg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XBWhjZd_1790154782;
Received: from 30.221.148.48(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBWhjZd_1790154782 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 17:13:02 +0800
Message-ID: <eeeab8d8-dfd3-45ff-9f30-d83c527210f2@linux.alibaba.com>
Date: Wed, 23 Sep 2026 17:13:02 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] generic/492: bypass the blkid cache when probing the
 label
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, fstests@vger.kernel.org, zlang@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 sandeen@redhat.com, dgc@kernel.org
References: <20260920094137.2749428-1-libaokun@linux.alibaba.com>
 <20260921052719.GB6253@frogsfrogsfrogs>
 <b4a10712-1658-4fba-a037-095fab466270@linux.alibaba.com>
 <20260921234910.GC6253@frogsfrogsfrogs> <arHaTLxSEk3yQxU4@mit.edu>
 <74463cb5-14af-47bb-9380-ca75dc5d293a@linux.alibaba.com>
 <20260922145335.GV6283@frogsfrogsfrogs>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260922145335.GV6283@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/9/22 22:53, Darrick J. Wong wrote:
> On Tue, Sep 22, 2026 at 03:17:27PM +0800, Baokun Li wrote:
>> On 2026/9/22 11:43, Theodore Tso wrote:
>>> On Mon, Sep 21, 2026 at 04:49:10PM -0500, Darrick J. Wong wrote:
>>>>> The difference between the e2fsprogs and util-linux libblkid is the
>>>>> time granularity: the former stores seconds only (TIME="%ld",
>>>>> bid_time = time(0), compares st_mtime <= bid_time), while the latter
>>>>> stores usec (TIME="sec.usec") and has an nsec tie-break in the compare,
>>>>> so the same-second case is much easier to hit with the e2fsprogs blkid.
>>>> Perhaps xfstests-bld should use the system blkid then?  IIRC the one
>>>> in e2fsprogs is very old and out of date.
>>> Historically, xfstests-bld was built in environments where libblkid
>>> wasn't available.  This included Android's runtime (which uses the
>>> bionic libc), and grte (Google Runtime Environment)[1].
>>>
>>> [1] https://github.com/bazelment/lrte/blob/master/grte/grte-build
>>>
>>> However, as more and more tests require utilities from util-linux,
>>> xfstests-bld was taught to build util-linux.  And if util-linux is
>>> being built, then we don't use e2fsprogs-libs any more, which is where
>>> libblkid is built.  From build-all:
>>>
>>> if test -z "$USE_LOCAL_E2FSLIBS" -o -d util-linux; then
>>>     SKIP_E2FSLIBS=yes
>>> fi
>>>
>>> I've always built xfstesets-bld with util-linux, even though it is
>>> listed as an optional repository.  This is because (a) util-linux is
>>> needed for Android and other non-standard Linux environments, and (b)
>>> the version of util-linux used by earlier Debian Stable was too old
>>> for some of the newer tests in fstests and blktests.
>>>
>>> If you aren't building xfstests-bld with util-linux, it falls back to
>>> building libblkid from e2fsprogs-libs.  HOWEVER, we don't actually
>>> blkid, and libblkid is always built statically.  So what seems to be
>>> going on is that one of the programs built by xfstests-bld is using
>>> the older libblkid, and that results in the blkid cache being writen
>>> with a second granularity.
>>>
>>> I've never noticed this issue because I've always built with
>>> util-linux.  The way to solve this is to require building with the
>>> system libblkid if util-linux is not being built, and to drop
>>> e2fsprogs-libs from xfstests-bld.  Or just build xfstests-bld with
>>> util-linux.  :-)
>>
>> Thanks for the detailed explanation.
>>
>> I checked my environment again though -- it turned out not to be
>> xfstests-bld at all.  xfstests-bld never touches e2fsprogs.
>>
>> What happened is that I had manually run "make install" of a locally
>> patched e2fsprogs in the test VM, which overwrote util-linux's blkid
>> and fsck.
>>
>> Rebuilding e2fsprogs with these options disabled made the test pass:
>>
>>     ./configure --disable-libblkid --disable-fsck \
>>             --disable-libuuid --disable-uuidd
>>
>> I ran unpatched generic/492 60 times on each side in a VM: 12/60
>> failures with the hand-installed strays, 0/60 with util-linux's
>> blkid/fsck.
>>
>> That said, I think the patch is still needed, because
>> FS_IOC_SETFSLABEL does not update the block device's mtime:
> Many filesystems /never/ update the bdev mtime, why would they?


Not from FS_IOC_SETFSLABEL, at least -- as far as I can see, none of
the filesystems implementing it updates the mtime, and even btrfs does
not do it from its label ioctl.  btrfs does have update_dev_time() for
the add/remove case (5a1972bd9fd4, so that libblkid does not keep
reading a stale cache), but that is not wired into its label ioctl.

I can see why.  What blkid keys on is the mtime of the /dev/xxx node,
and once the mount is set up we hold no reference to that path anymore
-- the node can be deleted or re-created, and s_id only keeps an
informational name.

Worse, one block device can have any number of /dev nodes pointing at
it; an ioctl on a mountpoint fd cannot tell which one the caller means,
nor find them all.  So the kernel has no well-defined node to update
here.

And it gets easy in userspace: for tools that take the device as an
argument (tune2fs, e2label, xfs_admin), one utime(device_name, NULL)
is enough to guarantee that after set the label of a device with
the tool, blkid -s <device> won't see the old label.

The tricky counterpart is the standard way to invoke this ioctl: a
mountpoint as the argument, xfs_io being the typical case.  It seems
the only option there is what the kernel would have to do anyway --
resolve the device behind the mount and update that node's mtime.

Do you have any thoughts?


>>     blkid -s LABEL ...    # get A
>>     FS_IOC_SETFSLABEL     # set B (device mtime unchanged)
>>     blkid -s LABEL ...    # still get A (within 2s)
>>
>> The first read writes a cache entry with TIME=now, and the ioctl
>> leaves the device mtime untouched, so a second read within the 2s
>> window still trusts the cache.
>>
>> I reproduced this with util-linux 2.41.5 too, so
>> "blkid -c /dev/null" is what keeps the test deterministic
>> regardless of which blkid the image carries.
> <nod> That was the problem I thought you were solving here ;)

Yep, that's the idea.  The point was to stay away from blkid's
cache complexity -- testing how a userspace tool caches things is
not really what a kernel test should be doing.


Cheers,
Baokun


