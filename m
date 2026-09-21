Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F652455616;
	Mon, 21 Sep 2026 09:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981678; cv=none; b=m3VrXH/UyNthOsjP35KA9wCS4ouW2cn/YZtPMrMhlJHBV6fDi633PItIGow/XLDtH8MqW1IuVWqeR2nMH2fVLNzewVSgyYMBexCiAB23wfHXpQL7UvFK2+jKLDFqTCiB1+hvDDKPnYhaUjO6Oo9mJmMSHm4e43TSAJlny3LSbZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981678; c=relaxed/simple;
	bh=sRKEu1/qqfwRyFwE+XaUw08xHMRrUtuVx5raLVwn1hU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ldrs5OdjOGkWechc3JjwbZNtN+ooz8Rix4I+h5fIgR0cn6sK8olceh4ptViO8nvxIUbvYiqImMf9bQa1DvJUMXt6ShLn13HWh9HpSWahTvH6rNeKDAxrdvxsNur7S7hENrvQu1qVGYdPSBweyRPMulwAGye4cmzET91YQSL4rd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sEw4Io67; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sEw4Io67"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789981670; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EOa/5tsQSRM8oUQZbGURvWMXis/Fe7v/dd80qFR2lSk=;
	b=sEw4Io67adUHM7r9Z8EbjrptNuZkaiTDIWfHKCkugqTgGJCdgDIMWMPC0cyBfiYa4I3fDxtNXb6LHvsukShIEzoxSDlzyzRLIPoXwfQ8U5Ei9bXSL5xXegvk6R0/Es96P+zfH0/Y6gJxtEELFI9EtSgBHwwWulUfRsxB+6CXT2Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XBLnGor_1789981668;
Received: from 30.221.147.168(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBLnGor_1789981668 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 21 Sep 2026 17:07:49 +0800
Message-ID: <b4a10712-1658-4fba-a037-095fab466270@linux.alibaba.com>
Date: Mon, 21 Sep 2026 17:07:48 +0800
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
Cc: fstests@vger.kernel.org, zlang@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, sandeen@redhat.com, dgc@kernel.org
References: <20260920094137.2749428-1-libaokun@linux.alibaba.com>
 <20260921052719.GB6253@frogsfrogsfrogs>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260921052719.GB6253@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Darrick,

On 2026/9/21 13:27, Darrick J. Wong wrote:
> On Sun, Sep 20, 2026 at 05:41:37PM +0800, Baokun Li wrote:
>> blkid may serve a stale label from its cache instead of probing the
>> device, so the label just set via xfs_io can be missed and the output
>> mismatch is non-deterministic.
>>
>> Pass "-c /dev/null" so that blkid always probes the on-disk superblock
>> directly.  Unlike the low-level probing mode (-p), which requires
>> util-linux 2.16 or later, this is also supported by the legacy blkid
>> shipped with e2fsprogs.
>>
>> Fixes: c3c9630968a6 ("generic: test online label ioctl")
>> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> Seems fine to me; I guess blkid could be racing with whatever updates
> the cache...udev?


Not a race, and not related to udev.  It's a long story; details below.

In the xfstests-bld appliance blkid is e2fsprogs' legacy blkid and its
cache is /etc/blkid.tab; the only writers are blkid itself and
e2fsprogs' fsck (both probe with the cache enabled).  systemd's udev
uses libblkid's low-level probe API and never touches this file.

What we hit is a strictly sequential sequence that depends on two
"same second" coincidences.  The cache validity check (blkid_verify()
in lib/blkid/probe.c) is:

    now >= TIME && mtime(seconds) <= TIME && age < 2s

Both sides are in seconds, and only the 2s window applies to a fresh
blkid process (BLKID_BID_FL_VERIFIED is not persistent).

mkfs only advances the device mtime and never updates the cache; the fs
label ioctl updates neither, so right after setting a new label a
cached lookup can still return the old one.

The trap is set by _check_scratch_fs: it runs "fsck -t ext4 ...", which
probes the device with the cache enabled and writes the entry back with
TIME=now and the current label state.

Here is a sequential 490/491/492 run that trips it (timestamps from a
CI log, ext4/bigalloc_1k):

    M-2  09:09:44  end of 490: fsck finds the previous entry stale
                   (age >= 2s) -> probes -> tab = {no LABEL, TIME=44}

    M-1  09:09:45  start of 491: mkfs -> device mtime = 45
                   (mkfs doesn't update the cache; tab stays TIME=44)
    M    09:09:46  end of 491: unmount + _check_scratch_fs
                   -> fsck sees mtime(45) > TIME(44) -> probes
                   -> tab = {no LABEL, TIME=46}          <- trap

    M    09:09:46  start of 492: mkfs -> device mtime = 46
    M    09:09:46  mount; ioctl label="label.492" (mtime unchanged)
    M    09:09:46  blkid(35): mtime(46) <= TIME(46), age < 2s
                   -> cache deemed valid, no probe -> prints no LABEL
    M+1  09:09:47  umount; blkid(39): still < 2s -> again
    M+1  09:09:47  check reports output mismatch (two lines missing)

The difference between the e2fsprogs and util-linux libblkid is the
time granularity: the former stores seconds only (TIME="%ld",
bid_time = time(0), compares st_mtime <= bid_time), while the latter
stores usec (TIME="sec.usec") and has an nsec tie-break in the compare,
so the same-second case is much easier to hit with the e2fsprogs blkid.

The patch avoids this by probing with -c /dev/null (the legacy blkid
has no -p).  Reproduced on ext4/bigalloc_1k: unpatched 10 of 65 runs
fail, patched 120/120 pass.


>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>
> --D


Thanks for the review!

Cheers,
Baokun

