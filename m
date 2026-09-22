Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9533D3336
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 03:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790048873; cv=none; b=a5su75A9JgDiTN0FoQNxx+kCcd9hywr1KV51nwW4wmeFgq275l/ZbwF2i/K5DUGFb1e4S6AAjkNmjKwH5sP4V/5pyfOl9qB+yrTEC7bIGOTUsmq1zCKkov0fpQD3eu6+4n6fX6p/Yz/2EtZ6SW7KPHVg+eH9vlWRDLfynnz2XjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790048873; c=relaxed/simple;
	bh=BvTbZzUJgxXAynlaurlQmfP5rEK52IWNgDP+DS9uOZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r18yRR9inoucP28T6SDcmTlkxTvb/RlXbckbn6MUSJMZN2QFiwc/T7a8jFctfz8U2osKwQmQOAEY5++rdfjGXgzwViPraWEyaiERQrIMuWwDLl24wyPmD3ximQ7Fs+LHKlJxm4MnsZjqZmqZSFRbc1UqyjeSUXcrpaeDO6Rrmys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=C+6mZh+d; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="C+6mZh+d"
Received: from macsyma.thunk.org (pool-108-26-156-67.bstnma.fios.verizon.net [108.26.156.67])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 68M3iHHV013743
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 23:44:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1790048660; bh=aaZjQCWBhAPpfjq9NOdT2vH7DRz/WSK6FD7H/vAgio8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=C+6mZh+dphwxOhFVsiyqQAQUn58wMxjYZhrAb5ZSFSzzSuZD0pf5oTc1EuHhavnIQ
	 YaWh0rfAUVYP20cm0ExY6re6mWLVFTjlaLYLH6jRd5GMxxmGreNHqwQ/VjWr+aeWGD
	 bx9sT7F5v7aFX291ImkUhkcYq/N+0RpQl7VuNfKvMVUNPw8rjml3dOcMijcyNgsNtK
	 UKUBtnYSMMcEhIlbpJWZ29FLZQ8M4QnWQ8OYuhh2RrzgiEweLyul8fAvMab/I8/AX8
	 9LTHn4uXFTHNuThe9MDhQHCB5gPgzjvyP/Wku0XvD1GeHrIeHP/joaByqjRrwvMPH9
	 +KALpNax6fhlQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 274911C81F3E; Mon, 21 Sep 2026 23:43:17 -0400 (EDT)
Date: Mon, 21 Sep 2026 23:43:17 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Baokun Li <libaokun@linux.alibaba.com>, fstests@vger.kernel.org,
        zlang@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, sandeen@redhat.com, dgc@kernel.org
Subject: Re: [PATCH] generic/492: bypass the blkid cache when probing the
 label
Message-ID: <arHaTLxSEk3yQxU4@mit.edu>
References: <20260920094137.2749428-1-libaokun@linux.alibaba.com>
 <20260921052719.GB6253@frogsfrogsfrogs>
 <b4a10712-1658-4fba-a037-095fab466270@linux.alibaba.com>
 <20260921234910.GC6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921234910.GC6253@frogsfrogsfrogs>

On Mon, Sep 21, 2026 at 04:49:10PM -0500, Darrick J. Wong wrote:
> > The difference between the e2fsprogs and util-linux libblkid is the
> > time granularity: the former stores seconds only (TIME="%ld",
> > bid_time = time(0), compares st_mtime <= bid_time), while the latter
> > stores usec (TIME="sec.usec") and has an nsec tie-break in the compare,
> > so the same-second case is much easier to hit with the e2fsprogs blkid.
> 
> Perhaps xfstests-bld should use the system blkid then?  IIRC the one
> in e2fsprogs is very old and out of date.

Historically, xfstests-bld was built in environments where libblkid
wasn't available.  This included Android's runtime (which uses the
bionic libc), and grte (Google Runtime Environment)[1].

[1] https://github.com/bazelment/lrte/blob/master/grte/grte-build

However, as more and more tests require utilities from util-linux,
xfstests-bld was taught to build util-linux.  And if util-linux is
being built, then we don't use e2fsprogs-libs any more, which is where
libblkid is built.  From build-all:

if test -z "$USE_LOCAL_E2FSLIBS" -o -d util-linux; then
    SKIP_E2FSLIBS=yes
fi

I've always built xfstesets-bld with util-linux, even though it is
listed as an optional repository.  This is because (a) util-linux is
needed for Android and other non-standard Linux environments, and (b)
the version of util-linux used by earlier Debian Stable was too old
for some of the newer tests in fstests and blktests.

If you aren't building xfstests-bld with util-linux, it falls back to
building libblkid from e2fsprogs-libs.  HOWEVER, we don't actually
blkid, and libblkid is always built statically.  So what seems to be
going on is that one of the programs built by xfstests-bld is using
the older libblkid, and that results in the blkid cache being writen
with a second granularity.

I've never noticed this issue because I've always built with
util-linux.  The way to solve this is to require building with the
system libblkid if util-linux is not being built, and to drop
e2fsprogs-libs from xfstests-bld.  Or just build xfstests-bld with
util-linux.  :-)

Cheers,

					- Ted
