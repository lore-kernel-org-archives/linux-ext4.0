Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B7240A940;
	Wed, 23 Sep 2026 10:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157772; cv=none; b=J0v7fwcajswFLnN/r0DrCHr+8hk2eNj7SdNk79Yr0bjorrS22fp6CK0nHUDK9ozgTo4Cg3N/NFvDb8NnqWWkoZ35+xRODzg3gFTrr75uoZkdsu25g+ZT6DduH8NAZDN94PuwsZzUKaYKLUrkYooi7+TKAQ/i5BiD2kyFReXdY54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157772; c=relaxed/simple;
	bh=UXuCaDlmLLKzcXoPVndGfwOywoXKG3yQILcEYGnX2Rw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZ9zEdmzD88FUCo0GAWqXUhgymTmTWK1eGm82RuuqFM/sVGW5RnScQtI5u98Un+dhxU1Hv5peaiVHxJO0yjc02/bMVItaFW7fnKbfFWIUTc7WuuAG6dp0eL+8WHlanw4YakqQn4tdVBfyjp9phuQ9NzHLxomjEBTb/CLqbRVbKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=UWJxP7Zy; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="UWJxP7Zy"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790157760; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RGclB5mo0HMup1GTonOpeUl/PPpEqlOL7mLAbExQtxI=;
	b=UWJxP7Zy0I9myRexeMJo0tAidtXMOuRqpvAGK7H83e+VYDBsWG65C/RB5BjbFT0mf/AbXSA3B6pjoc65kvIfv78uJrIO41JlvXC4FKT5TAlLqTx4EpElnmGoXmw20nQHV5HCAVsUl8E5z2u/b9HtYN/Fc56+hBP5HCxc+ZkqJpA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XBWj.C7_1790157759;
Received: from 30.221.148.48(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBWj.C7_1790157759 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 18:02:39 +0800
Message-ID: <8cc9f978-6365-4898-b3db-9f0b232aeb4c@linux.alibaba.com>
Date: Wed, 23 Sep 2026 18:02:38 +0800
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
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <arKZu30pMe0ZavVA@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/9/22 23:56, Theodore Tso wrote:
> On Tue, Sep 22, 2026 at 03:17:27PM -0500, Baokun Li wrote:
>> I checked my environment again though -- it turned out not to be
>> xfstests-bld at all.  xfstests-bld never touches e2fsprogs.
>>
>> What happened is that I had manually run "make install" of a locally
>> patched e2fsprogs in the test VM, which overwrote util-linux's blkid
>> and fsck.
> What e2fsprogs's configure script will do is that it checks to see if
> the blkid libraries are available for building against.  That is, if
> you are using Debian or Ubuntu, you need to have the libblkid-dev
> package install.  Among other things, this makes the following files
> available:
>
> /usr/include/blkid/blkid.h
> /usr/lib/x86_64-linux-gnu/libblkid.a
> /usr/lib/x86_64-linux-gnu/libblkid.so
>
> ... which are the files needed to build against libblkid and then link
> against it statically or dynamically.  If these files aren't
> available, then e2fsprogs will assume that it needs to build the local
> libblkid, which is what is needed when building on Android, MacOS,
> NetBSD, Open Solaris, etc.

Indeed, I originally built and installed it manually in an
environment without libblkid-dev.

>> Rebuilding e2fsprogs with these options disabled made the test pass:
>>
>>     ./configure --disable-libblkid --disable-fsck \
>>             --disable-libuuid --disable-uuidd
> This works, but this wll also disable those e2fsprogs features that
> require those libraries.  So mke2fs will not generate UUID's in the
> superblock, e2fsck won't handle LABEL=xyzzy specifiers, etc.
> Fortunately xfstests don't depend on these featuers, so this will work.


Hmm, what I disabled is exactly the set duplicated by util-linux:
the blkid/uuid libs and UUID/LABEL= handling all live there, so
the tools just link the system ones -- there is no functional loss.

> The way I build with a locally patched e2fsprogs is that I'll build it
> using the Debian build tools, which will enforce building with the
> necessary prereqsuite packages, and then I'll put the built packages
> in the directory test-appliance/debs and then build a fresh test
> appliance image.  Or I'll just upload the packages to the VM and then
> install it before launching the tests.

That sounds much better than a hand install -- I'll give it a try.

>> That said, I think the patch is still needed, because
>> FS_IOC_SETFSLABEL does not update the block device's mtime:
>>
>>     blkid -s LABEL ...    # get A
>>     FS_IOC_SETFSLABEL     # set B (device mtime unchanged)
>>     blkid -s LABEL ...    # still get A (within 2s)
>>
>> The first read writes a cache entry with TIME=now, and the ioctl
>> leaves the device mtime untouched, so a second read within the 2s
>> window still trusts the cache.
> The patch to xfstests might still be appropriate, but it seems to me
> that tune2fs should get fixed to update the device mtime (if it can),
> and perhaps the kernel should try to update block device inode as well
> as part of the FS_IOC_SETFSLABEL ioctl to address potential corner
> cases with systemd/udev.


Yes -- we need to add a utime() in tune2fs's ioctl path to update
the device mtime; I'll send a patch shortly.

For the kernel side, we don't have the dev path that the caller
is using, so it is not doable there: the inode we can reach
inside the ioctl is not the one userspace sees.  Details are in my
reply to Darrick:

https://lore.kernel.org/all/eeeab8d8-dfd3-45ff-9f30-d83c527210f2@linux.alibaba.com

Also, a thought that just came up: on the blkid side, would it be
feasible to not trust the cache for mounted devices and always
re-probe?  The mount / set label / umount / get label (within 2s)
window would remain, but it would be much smaller.


Thanks,
Baokun


