Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3493D470EA8;
	Mon, 21 Sep 2026 23:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034552; cv=none; b=IO5jRr+A69GokRFnOPaSUK3c2CKGHCYaJi/T5EBc4b+2XbNJo+Gf7dcBAbOZwGiZ3CjsJvL7oYsBtYfQn0bg3C6R11A7G0EHtdvMrYOSETZE3hvQDLTa4IX+DNanXXDdHp2OP5NIf9aQfwb21Vdb3TlreBzTkkSpDgg80Vqsofw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034552; c=relaxed/simple;
	bh=sxAkHqTPTG+FHZSO72A/k9PBbKfyid3Xe+Vt7iJNS8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLwN54eSFCsn7ZnDtcncq3dRknoERVQTZWC8fVtFuVh8zn+GWn3+8SLQgGPa23GrWxP1w7nHKEaeoLwBINRWgrz1rIM3f5ZI+A+Oqf8d1XO2GFbIptOBTTo/m0LdlioC8OS+swRlpX2yUZEXUOTpUSkIwwDqPVgIe2rqHPbczmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BpHDygNE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpHDygNE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8A6041F000FF;
	Mon, 21 Sep 2026 23:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790034550;
	bh=fkWrJTpYBRZ2+QAbaTLvdz++3oPbNjmqWTJdXwsbXPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BpHDygNEkWxOEirG4DGvgTfW1hxIVA8/sW5MxC7GGXZZvewfZ3kdD10WHma9PWIgv
	 4Xjn9grUtitPkR9vUIZY3h5L9nr8fu7f+gdInJHiS2LwgDTlCMsy82T9VZwOhIcGsF
	 nbDXiHAlLbUpvXnmNd35h6XpUKZ/npKZYq5bWQgS6AoB54h2VFtxNlHLrYpzg1Yj/n
	 dKCKVoj6bNsxQLpkDh2F1alToZXj58586+3kOVhOn/T7a5ECupNEoUdFQY8KuZBtz7
	 tKduJeHgcFUkI30V9+sHmCBXM9cXwbAJ230fpHXChmA/5bChfVsCUPDWCWinYIzvfd
	 hmWKwAf+WO6Aw==
Date: Mon, 21 Sep 2026 16:49:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: fstests@vger.kernel.org, zlang@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, dgc@kernel.org
Subject: Re: [PATCH] generic/492: bypass the blkid cache when probing the
 label
Message-ID: <20260921234910.GC6253@frogsfrogsfrogs>
References: <20260920094137.2749428-1-libaokun@linux.alibaba.com>
 <20260921052719.GB6253@frogsfrogsfrogs>
 <b4a10712-1658-4fba-a037-095fab466270@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4a10712-1658-4fba-a037-095fab466270@linux.alibaba.com>

On Mon, Sep 21, 2026 at 05:07:48PM +0800, Baokun Li wrote:
> Hi Darrick,
> 
> On 2026/9/21 13:27, Darrick J. Wong wrote:
> > On Sun, Sep 20, 2026 at 05:41:37PM +0800, Baokun Li wrote:
> >> blkid may serve a stale label from its cache instead of probing the
> >> device, so the label just set via xfs_io can be missed and the output
> >> mismatch is non-deterministic.
> >>
> >> Pass "-c /dev/null" so that blkid always probes the on-disk superblock
> >> directly.  Unlike the low-level probing mode (-p), which requires
> >> util-linux 2.16 or later, this is also supported by the legacy blkid
> >> shipped with e2fsprogs.
> >>
> >> Fixes: c3c9630968a6 ("generic: test online label ioctl")
> >> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> > Seems fine to me; I guess blkid could be racing with whatever updates
> > the cache...udev?
> 
> 
> Not a race, and not related to udev.  It's a long story; details below.
> 
> In the xfstests-bld appliance blkid is e2fsprogs' legacy blkid and its
> cache is /etc/blkid.tab; the only writers are blkid itself and
> e2fsprogs' fsck (both probe with the cache enabled).  systemd's udev
> uses libblkid's low-level probe API and never touches this file.
> 
> What we hit is a strictly sequential sequence that depends on two
> "same second" coincidences.  The cache validity check (blkid_verify()
> in lib/blkid/probe.c) is:
> 
>     now >= TIME && mtime(seconds) <= TIME && age < 2s
> 
> Both sides are in seconds, and only the 2s window applies to a fresh
> blkid process (BLKID_BID_FL_VERIFIED is not persistent).
> 
> mkfs only advances the device mtime and never updates the cache; the fs
> label ioctl updates neither, so right after setting a new label a
> cached lookup can still return the old one.
> 
> The trap is set by _check_scratch_fs: it runs "fsck -t ext4 ...", which
> probes the device with the cache enabled and writes the entry back with
> TIME=now and the current label state.
> 
> Here is a sequential 490/491/492 run that trips it (timestamps from a
> CI log, ext4/bigalloc_1k):
> 
>     M-2  09:09:44  end of 490: fsck finds the previous entry stale
>                    (age >= 2s) -> probes -> tab = {no LABEL, TIME=44}
> 
>     M-1  09:09:45  start of 491: mkfs -> device mtime = 45
>                    (mkfs doesn't update the cache; tab stays TIME=44)
>     M    09:09:46  end of 491: unmount + _check_scratch_fs
>                    -> fsck sees mtime(45) > TIME(44) -> probes
>                    -> tab = {no LABEL, TIME=46}          <- trap
> 
>     M    09:09:46  start of 492: mkfs -> device mtime = 46
>     M    09:09:46  mount; ioctl label="label.492" (mtime unchanged)
>     M    09:09:46  blkid(35): mtime(46) <= TIME(46), age < 2s
>                    -> cache deemed valid, no probe -> prints no LABEL
>     M+1  09:09:47  umount; blkid(39): still < 2s -> again
>     M+1  09:09:47  check reports output mismatch (two lines missing)
> 
> The difference between the e2fsprogs and util-linux libblkid is the
> time granularity: the former stores seconds only (TIME="%ld",
> bid_time = time(0), compares st_mtime <= bid_time), while the latter
> stores usec (TIME="sec.usec") and has an nsec tie-break in the compare,
> so the same-second case is much easier to hit with the e2fsprogs blkid.

[add ext4 list to cc]

Perhaps xfstests-bld should use the system blkid then?  IIRC the one
in e2fsprogs is very old and out of date.

--D

> 
> The patch avoids this by probing with -c /dev/null (the legacy blkid
> has no -p).  Reproduced on ext4/bigalloc_1k: unpatched 10 of 65 runs
> fail, patched 120/120 pass.
> 
> 
> >
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> >
> > --D
> 
> 
> Thanks for the review!
> 
> Cheers,
> Baokun
> 
> 
