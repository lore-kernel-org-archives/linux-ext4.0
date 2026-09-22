Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B89E552955
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092658; cv=none; b=s4aPRd7HSRDDhwGJIPUreYf+reFjd7S//eBGPy0ykh9kbeg5qaSvdqH/tOcS+nJ1IlvRoTDEiaJ/acyboOch3MSVgA55okINGdQZukyAGQI9AEnF2T2wDl2sHnn55ari6dxB/iqPO+iv10ayzwx/QTzOX26WDAqrpKuDa7QtnxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092658; c=relaxed/simple;
	bh=Oth2R5uA2OQWFqOlcPw7fCNt1VAfsHFYhLQIktYv3YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Whv5HF9ktv1PQyH0ZeCxHBjPrE4MLSTIMCjtlEw7t1KbQOTZJClGOna5fJ8m4rdGUm4UH9QvVDyzfHAoL1YD+2/jSuOrNN9VfmrpRTdUazkyLaTpTa/AN8sLQ0Gq4D6Wq330G8F8U46sK1kR8r69uuNUPDk5vokPbPQ/gip9wIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=FAW0xhum; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="FAW0xhum"
Received: from macsyma.thunk.org (pool-108-26-156-67.bstnma.fios.verizon.net [108.26.156.67])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 68MFvIQJ030854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 11:57:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1790092641; bh=W17EuRjsRrgDf5dIH9mzKrl6ZdtS1hulCXAE8MXDe00=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=FAW0xhumfgkV3y6oBa8nWeIUaIMBmQLDWxhGNYVCk7tyin9/XoBrC+L+3TmGzp7a0
	 3nI+jNoHMu7RVXvFLyqegqKP0K8RHy12+Ynizm4KoGJB4THkFlN1JnlgzZuzx1/wJe
	 iqHej0aI/UV3tFiF8cg7wcOLUb47AwC+fCmJ5oLgyb51oNHY7NieYBxvRcAaDO+NsH
	 jPSGHRBsteMwy69DrEild/8+7ydKoX+qxzQGwhDsPEKIaKCGJkUcgxUfN9x68svT4n
	 k3SS6bGtIA2Ij+X+hSmUcbF4g2NQOQH4gI3s2z2gwj9qdmYQS3FHCOdBg0QxDBAP65
	 ClBI17LU0ijZQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 16E2F1C992A4; Tue, 22 Sep 2026 11:56:18 -0400 (EDT)
Date: Tue, 22 Sep 2026 11:56:17 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
        zlang@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, sandeen@redhat.com, dgc@kernel.org
Subject: Re: [PATCH] generic/492: bypass the blkid cache when probing the
 label
Message-ID: <arKZu30pMe0ZavVA@mit.edu>
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

On Tue, Sep 22, 2026 at 03:17:27PM -0500, Baokun Li wrote:
> I checked my environment again though -- it turned out not to be
> xfstests-bld at all.  xfstests-bld never touches e2fsprogs.
> 
> What happened is that I had manually run "make install" of a locally
> patched e2fsprogs in the test VM, which overwrote util-linux's blkid
> and fsck.

What e2fsprogs's configure script will do is that it checks to see if
the blkid libraries are available for building against.  That is, if
you are using Debian or Ubuntu, you need to have the libblkid-dev
package install.  Among other things, this makes the following files
available:

/usr/include/blkid/blkid.h
/usr/lib/x86_64-linux-gnu/libblkid.a
/usr/lib/x86_64-linux-gnu/libblkid.so

... which are the files needed to build against libblkid and then link
against it statically or dynamically.  If these files aren't
available, then e2fsprogs will assume that it needs to build the local
libblkid, which is what is needed when building on Android, MacOS,
NetBSD, Open Solaris, etc.

> Rebuilding e2fsprogs with these options disabled made the test pass:
> 
>     ./configure --disable-libblkid --disable-fsck \
>             --disable-libuuid --disable-uuidd

This works, but this wll also disable those e2fsprogs features that
require those libraries.  So mke2fs will not generate UUID's in the
superblock, e2fsck won't handle LABEL=xyzzy specifiers, etc.
Fortunately xfstests don't depend on these featuers, so this will work.

The way I build with a locally patched e2fsprogs is that I'll build it
using the Debian build tools, which will enforce building with the
necessary prereqsuite packages, and then I'll put the built packages
in the directory test-appliance/debs and then build a fresh test
appliance image.  Or I'll just upload the packages to the VM and then
install it before launching the tests.

> That said, I think the patch is still needed, because
> FS_IOC_SETFSLABEL does not update the block device's mtime:
> 
>     blkid -s LABEL ...    # get A
>     FS_IOC_SETFSLABEL     # set B (device mtime unchanged)
>     blkid -s LABEL ...    # still get A (within 2s)
> 
> The first read writes a cache entry with TIME=now, and the ioctl
> leaves the device mtime untouched, so a second read within the 2s
> window still trusts the cache.

The patch to xfstests might still be appropriate, but it seems to me
that tune2fs should get fixed to update the device mtime (if it can),
and perhaps the kernel should try to update block device inode as well
as part of the FS_IOC_SETFSLABEL ioctl to address potential corner
cases with systemd/udev.

						- Ted
