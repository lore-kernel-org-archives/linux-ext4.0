Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666892EDD53;
	Tue, 22 Sep 2026 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790088817; cv=none; b=CaHBlxYmJuH7hwcHjnu3yfj5hvg8Pe0cwcn5TyVn7CVW5SNlGIk/aqy5+wVNoJg9kv/KO2HY3u+Jmak1t5NI6a7n4JClejXqisyw8mEv9eUVDNadlMjx90yNEpd/U69zieEGEHfAnLEnQSlyGJT8SGye5KUhfFZvVvAbVgMklA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790088817; c=relaxed/simple;
	bh=3zStg+Of3SIDA6p7npUPWy+g0iFtuiOXyrEBpcSnHLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hb4c0K0pwbBQ9LV8Q5b4vhRV0H8ITdvb+BHGXjNV3z7GmHKzxaJ+NVbgMYd+AY42/gBZXCfZdbb4Klmydwcfzsek4As7soeXCcjRyNT/RVyjMB8zFhjl9Y2IMyopalSFjI5agMt9kwdulXo/ghjJdaCGkwjLtNkp75Uv6Jjlsa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZaz7KBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZaz7KBK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DBB4F1F00893;
	Tue, 22 Sep 2026 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790088816;
	bh=Dy2JhPeTjTCbkklm8rLHvN3UFSIZRPRM35gZ5rMoV+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MZaz7KBKX6mpqgw8T+lwgsl4gL0IoBvFbgRMRYZqvSBmZPWiYJ6HESBSwGjUVWaKt
	 LU8JjwiLdOg3u4n5BmWtDZG+F5eTM/4T6QEV6YoIIBMO4EXQaYzGqwbShyjxzwHwFa
	 OVXalWXaoJlCWwsilexubk7a2XM7ln9MygpsS6j+c4ztVUklshuA/0XeJuZMmYes4m
	 qREKi1tcMbH67D+jynd894r+ujWjJygb27XxnNhfvFUPLB2UFh5PK10oxbZYG9sEs0
	 VP1aacopMEN/kEmSMvquYPrjaarrs6kyk3IdMWu6pTTtpCyL+AbhOlKBppdAJPxtQx
	 0In30ndvgNd5Q==
Date: Tue, 22 Sep 2026 07:53:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: Theodore Tso <tytso@mit.edu>, fstests@vger.kernel.org, zlang@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, dgc@kernel.org
Subject: Re: [PATCH] generic/492: bypass the blkid cache when probing the
 label
Message-ID: <20260922145335.GV6283@frogsfrogsfrogs>
References: <20260920094137.2749428-1-libaokun@linux.alibaba.com>
 <20260921052719.GB6253@frogsfrogsfrogs>
 <b4a10712-1658-4fba-a037-095fab466270@linux.alibaba.com>
 <20260921234910.GC6253@frogsfrogsfrogs>
 <arHaTLxSEk3yQxU4@mit.edu>
 <74463cb5-14af-47bb-9380-ca75dc5d293a@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74463cb5-14af-47bb-9380-ca75dc5d293a@linux.alibaba.com>

On Tue, Sep 22, 2026 at 03:17:27PM +0800, Baokun Li wrote:
> On 2026/9/22 11:43, Theodore Tso wrote:
> > On Mon, Sep 21, 2026 at 04:49:10PM -0500, Darrick J. Wong wrote:
> >>> The difference between the e2fsprogs and util-linux libblkid is the
> >>> time granularity: the former stores seconds only (TIME="%ld",
> >>> bid_time = time(0), compares st_mtime <= bid_time), while the latter
> >>> stores usec (TIME="sec.usec") and has an nsec tie-break in the compare,
> >>> so the same-second case is much easier to hit with the e2fsprogs blkid.
> >> Perhaps xfstests-bld should use the system blkid then?  IIRC the one
> >> in e2fsprogs is very old and out of date.
> > Historically, xfstests-bld was built in environments where libblkid
> > wasn't available.  This included Android's runtime (which uses the
> > bionic libc), and grte (Google Runtime Environment)[1].
> >
> > [1] https://github.com/bazelment/lrte/blob/master/grte/grte-build
> >
> > However, as more and more tests require utilities from util-linux,
> > xfstests-bld was taught to build util-linux.  And if util-linux is
> > being built, then we don't use e2fsprogs-libs any more, which is where
> > libblkid is built.  From build-all:
> >
> > if test -z "$USE_LOCAL_E2FSLIBS" -o -d util-linux; then
> >     SKIP_E2FSLIBS=yes
> > fi
> >
> > I've always built xfstesets-bld with util-linux, even though it is
> > listed as an optional repository.  This is because (a) util-linux is
> > needed for Android and other non-standard Linux environments, and (b)
> > the version of util-linux used by earlier Debian Stable was too old
> > for some of the newer tests in fstests and blktests.
> >
> > If you aren't building xfstests-bld with util-linux, it falls back to
> > building libblkid from e2fsprogs-libs.  HOWEVER, we don't actually
> > blkid, and libblkid is always built statically.  So what seems to be
> > going on is that one of the programs built by xfstests-bld is using
> > the older libblkid, and that results in the blkid cache being writen
> > with a second granularity.
> >
> > I've never noticed this issue because I've always built with
> > util-linux.  The way to solve this is to require building with the
> > system libblkid if util-linux is not being built, and to drop
> > e2fsprogs-libs from xfstests-bld.  Or just build xfstests-bld with
> > util-linux.  :-)
> 
> 
> Thanks for the detailed explanation.
> 
> I checked my environment again though -- it turned out not to be
> xfstests-bld at all.  xfstests-bld never touches e2fsprogs.
> 
> What happened is that I had manually run "make install" of a locally
> patched e2fsprogs in the test VM, which overwrote util-linux's blkid
> and fsck.
> 
> Rebuilding e2fsprogs with these options disabled made the test pass:
> 
>     ./configure --disable-libblkid --disable-fsck \
>             --disable-libuuid --disable-uuidd
> 
> I ran unpatched generic/492 60 times on each side in a VM: 12/60
> failures with the hand-installed strays, 0/60 with util-linux's
> blkid/fsck.
> 
> That said, I think the patch is still needed, because
> FS_IOC_SETFSLABEL does not update the block device's mtime:

Many filesystems /never/ update the bdev mtime, why would they?

>     blkid -s LABEL ...    # get A
>     FS_IOC_SETFSLABEL     # set B (device mtime unchanged)
>     blkid -s LABEL ...    # still get A (within 2s)
> 
> The first read writes a cache entry with TIME=now, and the ioctl
> leaves the device mtime untouched, so a second read within the 2s
> window still trusts the cache.
> 
> I reproduced this with util-linux 2.41.5 too, so
> "blkid -c /dev/null" is what keeps the test deterministic
> regardless of which blkid the image carries.

<nod> That was the problem I thought you were solving here ;)

--D

> 
> Cheers,
> Baokun
> 
> 
