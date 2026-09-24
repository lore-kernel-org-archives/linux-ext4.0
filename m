Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDE042CB0D;
	Thu, 24 Sep 2026 08:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790237367; cv=none; b=GP+CQucrM78b8v6as12QysrZoM4GXGjtQpn9ioFBx2+hoinpoXqJmtz1jITOndoFX1pnkf9cnQlRv5h+pL/AMBhf1dnWlZsrIl+wVzcp2uFpX87ndrXso+mwYDCVS5a1g4OT+Va+AcS00jouyJHOyd2/OHSZCG2DhSCunA9bswI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790237367; c=relaxed/simple;
	bh=YPu10d4gCbWLiq/SiXEDGdgQk3zAzOEMn+Dzlo5otdA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MoMDlvIGK5fv6jWK9/wPUrg9+zyhfFdp+GiiETOfsIMa2CKiecEl4fGJ1E5XnlBET8gQXwjD+P6JTdzVeGRr31kMIpSsm/3h63da4AFTRyPVZ+RuZnUP0BcZcubJS4IBmCwrYy2OzROowvw51KYVrDvKATH9FqShojSs1nXQ81U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZzOEDoHf; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZzOEDoHf"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790237357; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=851eSIVYb4TgX8lgc+kKPtDZIkWTqS9p38FkXCV2hko=;
	b=ZzOEDoHfdGUVoPogJY/oHH0FKpIpacG7y2E41HS3s6I3U5ORf7nomjYd/PFOtgSxSgZlMtH2tyM3czL+gH9CreUXUVMDIXwfgNPY3DeyjAYxqfEs3gI4jLU/MYOzEhLr3Mx85vd5TM9iCm9UR7SkAbkGDda6tA0GD9UNC+suMl4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XBZ2a3w_1790237356;
Received: from 30.221.147.180(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBZ2a3w_1790237356 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Sep 2026 16:09:16 +0800
Message-ID: <b020985c-2784-4438-baae-07d16f3afc7b@linux.alibaba.com>
Date: Thu, 24 Sep 2026 16:09:15 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] generic/492: bypass the blkid cache when probing the
 label
To: Theodore Tso <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
 zlang@kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 sandeen@redhat.com, dgc@kernel.org
References: <20260920094137.2749428-1-libaokun@linux.alibaba.com>
 <20260921052719.GB6253@frogsfrogsfrogs>
 <b4a10712-1658-4fba-a037-095fab466270@linux.alibaba.com>
 <20260921234910.GC6253@frogsfrogsfrogs> <arHaTLxSEk3yQxU4@mit.edu>
 <74463cb5-14af-47bb-9380-ca75dc5d293a@linux.alibaba.com>
 <arKZu30pMe0ZavVA@mit.edu>
 <8cc9f978-6365-4898-b3db-9f0b232aeb4c@linux.alibaba.com>
 <arRIECW5MBX7fwfe@mit.edu>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <arRIECW5MBX7fwfe@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/9/24 10:25, Theodore Tso wrote:
> On Wed, Sep 23, 2026 at 06:02:38PM -0500, Baokun Li wrote:
>>>>     ./configure --disable-libblkid --disable-fsck \
>>>>             --disable-libuuid --disable-uuidd
>>> This works, but this wll also disable those e2fsprogs features that
>>> require those libraries.  So mke2fs will not generate UUID's in the
>>> superblock, e2fsck won't handle LABEL=xyzzy specifiers, etc.
>>> Fortunately xfstests don't depend on these featuers, so this will work.
>> Hmm, what I disabled is exactly the set duplicated by util-linux:
>> the blkid/uuid libs and UUID/LABEL= handling all live there, so
>> the tools just link the system ones -- there is no functional loss.
> The fact that you needed the --disable options implies that e2fsprogs
> wasn't able to use the util-linux supplied libraries.  If the
> configure script determines libblkid and libuuid are available for
> linking against, (e.g., libblkid-dev and uuid-dev are installed), the
> built-in libblkid and libuuid file systems are disabled.
>
> From the configure script output:
>
> checking for blkid_get_cache in -lblkid... yes
> Using system blkid library by default
>
> checking for uuid_generate in -luuid... yes
> Using system uuid by default
> Disabling uuidd by default
>
> In contrast, if you run the configure script on MacOS, NetBSD, or a
> Linux system missing the libuuid / libblkid development files, you
> will see:
>
> checking for uuid_generate in -luuid... no
> Enabling private uuid library by default
> Building uuidd by default

Right.  The flags went in only after the development packages were
installed.  The original hand build had no libblkid-dev, so it built
and installed the private copies, which is how the distro's
blkid/fsck/findfs got shadowed.

With libblkid-dev, uuid-dev and pkg-config installed, a plain
./configure now prints exactly your first output.  Compared with my
--disable build, the only extra program it produces is the fsck
wrapper.

>> Also, a thought that just came up: on the blkid side, would it be
>> feasible to not trust the cache for mounted devices and always
>> re-probe?  The mount / set label / umount / get label (within 2s)
>> window would remain, but it would be much smaller.
> Maybe.  It's not clear how often people might be trying to query the
> blkid data.  Also, figuring out whether or not a device is mounted is
> not free.  That would mean that for every blkid query, it would have
> to read /proc/mounts to make that determination.  And note that on
> some data center servers, there could potentially be hundreds if not
> thousands of entries in /proc/mounts, either because you have a huge
> number of bind mounts or overlayfs, and/or because you might have a
> huge number of read-only iscsi mounts to deliver software packages to
> your container based Borg or Kubernetes jobs.
>
> I suppose you could put in the blkid cache a hint as to whether the
> file system is mounted, but that in itself could get stale and out of
> date.

Agreed -- checking whether a device is mounted on every probe might
cost more than simply re-probing the device.  Updating the mtime on
the write side (e.g., in tune2fs, xfs_io, or the kernel) looks like
the better approach.


Cheers,
Baokun


