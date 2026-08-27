Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C055E2F7F01
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 07:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787816039; cv=none; b=AiyrDGVer+y2YM/Nz8oRjmKGp6CrAbZGmsHN9EahyRuBGp01B0/BDNbTh7dbZhzjOfX8Q45aEq1DMQi3FRQGXgdTmTU0jABacTkkXCqJya7lTX/riGinDekns+kDg8/7DxegczvFNJDlaDJ194XPmuP4meBpB8FdH9iSLVgRaQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787816039; c=relaxed/simple;
	bh=cfCf72Fy/qyuIJC5cljE7vuhpoUlPwF/Y93WSydxfRs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YRIPmvCUL5mCcxoaiGDzesozS9/6vOdxNx9+P+oc8uO4bTn1X6vWw6MIwfRo/czxI/v05Ugoezo+skMyQCFPcrmRht0WWXKXs2K7jjslLVETNlKLu7ZpjJbvgIa5d8NOUoGPCjxCsRJIK+HO9J70nAsA8qFgnQdeLpJ0tJPWBSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=s4S4Wf18; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="s4S4Wf18"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-ca80d708489so511318a12.1
        for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 00:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1787816037; x=1788420837; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=A8mkF6ZHkXJ09TL3pb1Og28OGuKaOrsstEVbqLr737c=;
        b=s4S4Wf18oOPkkkCA+Kqe9qpiVzf+PX4T3EqWb/Lbe7PYCAraM4S80BLNpj3mgiGXSo
         6CiSR41nIf518ellAC1UrcivNVG8iYQsZy+YCmvBYRAoT3IzRbV5ZW1pfmBzDiFUZuCq
         uz+OR2tdPvn0NjnIrDUImKArP8OnIe30aXYZfHvJbd2vLGm3++Sjg2x9c6bl29Fq5ArB
         /fp28PW14IzWKWoxl1Q1EU3E8D4NnXDAoYl23FLuL6tGcnMu9MBB9vs2pq34/JGb460i
         648xd8hJhol+4BqrqOWOvn/79vXAqB2PbnCf3e38a8wYj30O3pFRFyrEzj1nIUA2Nbp9
         iqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787816037; x=1788420837;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A8mkF6ZHkXJ09TL3pb1Og28OGuKaOrsstEVbqLr737c=;
        b=nGse8Xzf+NVj91AF3XuUj1YP8M1A5ZPkPHgn5Hea94olsDr8s2njYRv5DZNKWeLQHk
         Y6IpZ5nlfpjAfp30xTaOGHu0qz9/N4EQnnSQWJlijn9HAd1QqbyRYsXXa6GuLavQLVCa
         VBSal/FXemFzK3Zw0qWlUHbqNX1X4PYF3k3izy+WdGoog5tDcPPE/MRLw1PkrxyzhBQo
         XKNkLplxA/MY6iHl/YIb18ipQxuWVZFn43GLHzR7Mrbk2kcA1ksPUdkuKAD8DS8IJeOO
         8rLWfGc6a688QY8lHVxDHnrVZp05eBMIHfoQHQWlT/Ou/eKl87aNYAFCIiUVOfSHhhzV
         L2dQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrmh1ihSOkw7s7jOq0KEYgEKLxSWfpkZeSvV+zUIkg4MR7e4jUSVIOu2DF2ZCzgV2/R9F0eudblx8xI@vger.kernel.org
X-Gm-Message-State: AFuF++nsEy4hYONF2PC52WSk01aJtVZ7IpOzt4I8FSeLSxMr3Wr63m0w
	4qmkrR6C01W2rfyFmRBZeNktyMw3J/K2eEKN8Ba6AB+bo2q3kjeArB7bglyj5Xbku0M=
X-Gm-Gg: AR+sD11RQ/JNKTe7o84F+TfJzX9t16Y5ycrQ32tkL4GbqKscRLXPEKv70esRWSkJhkf
	fGc9Q3V84d2DEPwITASE0PYRg2VaIlyvQXWp0B+dEhpbccY9+CQWesblyVO6ysTeFNA9JYa17R0
	HmnmXlmM2sIshEjhDikyGBLuH38mh22MGk6xDP3JUNzjclT69V5iziKPCBe6ksczjO+Sy9ZJk8m
	2LiPlwC2PjwwXLeft0MHfRfKiu/oFQmyqjYBmoqshbmwLR6ANR8XbTJ1WeOXHnHuUHYSNflefe1
	L5RZiRFVYrfF4FBtAAQ5M3NWjBq+P1j4VVO+V/RUVMIi4UHCMHHOQKcS1xBmzjzvzgl1kr7RmKB
	5WKOSfFIPAMH5E5z7WuZruir5pEhhBZy9pSQ/mO37S/MTx2JuBaQUyt1DSZPUhqMmds+OzZIzTa
	xoKmJCJ3J6U4NqZYS4KBvYhU8GlsZypu8er2SYNvm6hXGgjCN3XYxyyIzrNO/hYy7UL7Yss4LHF
	54XCfmrBJUrsW5VnQ==
X-Received: by 2002:a17:90b:5484:b0:385:3ab:fecb with SMTP id 98e67ed59e1d1-3969bae971bmr5551066a91.4.1787816036721;
        Thu, 27 Aug 2026 00:33:56 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:519f:762d:ed84:5e92])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fcfa3asm1682404a91.6.2026.08.27.00.33.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2026 00:33:56 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <ao7ygPaBH1AVudFR@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Date: Thu, 27 Aug 2026 01:33:45 -0600
Cc: "Darrick J. Wong" <djwong@kernel.org>,
 linux-ext4@vger.kernel.org,
 tytso@mit.edu,
 srivatsa@csail.mit.edu
Content-Transfer-Encoding: quoted-printable
Message-Id: <8C5E6B25-DF64-4437-9269-3A7E0FC932D1@dilger.ca>
References: <aoxF8FvVffocUSyI@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
 <20260824224006.GB6038@frogsfrogsfrogs>
 <ao7ygPaBH1AVudFR@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
To: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Aug 26, 2026, at 08:04, Nandakumar Raghavan =
<naraghavan@linux.microsoft.com> wrote:
>=20
> On Mon, Aug 24, 2026 at 03:40:06PM -0700, Darrick J. Wong wrote:
>> On Mon, Aug 24, 2026 at 09:15:11AM -0700, Nandakumar Raghavan wrote:
>>> During journal replay, e2fsck writes the primary superblock back to =
disk
>>> in multiple I/O operations. The payload lands before the checksum, =
leaving
>>> a transient window where the on-disk superblock has a bad checksum.
>>>=20
>>> If udevd processes a change uevent during this window, libblkid =
probes the
>>> primary superblock, finds a checksum mismatch, and concludes the =
partition
>>> has no recognisable filesystem. udev then fires a remove event, =
wiping all
>>> symlinks in /dev/disk/by-label/ and /dev/disk/by-uuid/. Any mount =
unit
>>> that depends on those symlinks will fail.
>>>=20
>>> udevd already serialises its own partition probes against whole-disk =
device
>>> access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it =
requeues the
>>> event. Take advantage of this protocol by acquiring flock(LOCK_EX) =
on the
>>> whole-disk device before opening the filesystem. This forces udevd =
to defer
>>> all probes on that disk until e2fsck exits and the lock is released, =
by
>>> which point the filesystem is fully consistent.
>>>=20
>>> The whole-disk device is resolved via sysfs =
(/sys/dev/block/MAJ:MIN/partition)
>>> so that the lock covers the same device node that udevd locks. If =
sysfs
>>> resolution fails, a warning is emitted and the lock falls back to =
the
>>> partition device itself.
>>>=20
>>> This mechanism relies on Linux-specific interfaces (sysfs, flock() =
semantics
>>> on block devices) and is compiled out entirely on non-Linux =
platforms.
>>=20
>> You're clearly implementing the "Locking Block Device Access" =
protocol
>> as documented by systemd:
>> https://systemd.io/BLOCK_DEVICE_LOCKING/
>>=20
>> So why not use libsystemd like the example in that posting provides?
>> sd_device_get_parent_with_subsystem_devtype is much less gross than
>> open-coding the same logic here.
> This was on purpose and not something I missed. The =
sd_device_get_parent_with_subsystem_devtype
> requires libsystemd v251+, and e2fsck needs to keep working in =
contexts where
> that dependency isn't available or isn't guaranteed to be new enough -
> non-systemd distros, older LTS systems doing root-fs repair before =
userspace
> is fully up, embedded/recovery images, etc.
> Taking a hard runtime dependency on a versioned libsystemd API for a =
tool
> this fundamental felt like a much bigger cost than by parsing =
(/sys/dev/block/MAJ:MIN/partition, .../dev), which only relies on a =
stable
> kernel ABI with no library and no version floor. Happy to reconsider =
if
> the project wants to take the dependency, but wanted to flag the =
tradeoff
> explicitly rather than silently pick one side.

I for one am not eager to have e2fsprogs depend on libsystemd to build.

>>=20
>>> Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
>>> ---
>>>=20
>>> @@ -1488,6 +1580,10 @@ int main (int argc, char *argv[])
>>>=20
>>> check_mount(ctx);
>>>=20
>>> +#ifdef __linux__
>>> + lock_fd =3D lock_whole_disk(ctx, ctx->filesystem_name);
>>=20
>> If the filesystem has an external journal device, doesn't that also =
need
>> locking?
>=20
> Good point, and no, it doesn't currently - lock_whole_disk() is only =
called on
> ctx->filesystem_name. An external journal device (-O journal_dev) is a =
separate
> block device with its own by-uuid symlinks, and I don't have a strong =
argument
> that it's immune to the same class of race during replay. I'd like to =
treat
> this as a follow-up rather than block on it, since it needs a bit more =
digging
> into whether the external journal's own superblock write pattern =
actually
> creates the same transient-bad-checksum window - but I don't want to =
just wave
> it away either.

At one point I was working on having jbd2 "mount" the journal device, =
and then
ext4 would connect to the running journal as a "service", rather than =
having
the journal device be mounted exclusively as subpart of the ext4 =
filesystem.
I might have even posted patches for this to the list (maybe 15 years =
ago?)

This was intended to solve a number of issues:
- ensuring that the jbd2 block device was visibly "in use" to userspace
- allow a single jbd2 device (e.g. on NVMe) to be shared among multiple =
ext4
  filesystems (on HDDs)

That shared device would have been much more useful when HDDs were =
prevalent
and an NVMe device was harder to share (e.g. before LVM/DM).  It had =
some other
issues like what to do if there are journaled blocks to recover but one =
of the
using filesystems does not mount and recover them? Maybe copy those =
blocks to
the end of the journal and shrink the usable journal size?

It still has some appeal from the visibility POV, and for sharing it =
avoids
stranding dedicated NVMe journal space on one inactive filesystem when =
other
busy filesystems could be sharing the space.

Cheers, Andreas





