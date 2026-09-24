Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0D33D47A1
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 02:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790216796; cv=none; b=li+8WoiSVLgmFwik8h5QJzE1IAHwJuoT8O9Wwrue949XrLxMGK2nqcYk2XpQWcnvjk8jEjlJu9xVdJtNS5xm6VaOyNdrvNjI6yva2+1zzjxiaF51wamuhKaDZq6veTmnWJvn0fS1V7RrKPLkk6MotQ8bWalsU2Paw3BuMeY5/HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790216796; c=relaxed/simple;
	bh=PSpuNemmEVccQBew0m90VLs4TbBdovTZObkeg+WCVQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8DuJyzyM6v72oyZHDKL6Vgl/GR/fI8Pl8o42MI3P24u4UFd2mZjtWhJGvJqKtpTXSgx8WeCjyGur436iyphb83ULXoszadp886QABYSQdgrTh3iFXBiBAkMB5l4fkDPHfZuqcuDGtDipkQwCxUmMO/W0286o/qZnci/nTgKLq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=g3J2q0Md; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="g3J2q0Md"
Received: from macsyma.thunk.org (pool-108-26-156-67.bstnma.fios.verizon.net [108.26.156.67])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 68O2Q38S027265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 22:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1790216766; bh=XOPG7Wm5YRPy1BsFIYcUDaWJyTqesRHLONHeV9V4AFI=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=g3J2q0MdxfvwhvfSUgsWQVy7rO/nOPcYkqhxRvG3u4G4H5ecW6nD07GjQ+hzdb3J8
	 dzujBuWWfHqmBUk6FrZO+oTq7DA6ZmsZGjJCIrbVqDP5XPl2lX7G+RsW3a3hBmX/Zn
	 GFuM5Jcqw6fAXWFpNZnVmfJm7Gs9OyTTCn8sQhD960W+HVkU9fhIXip+VbkOzUGlLo
	 OLFEBfq6VHAFHtk7CQw6R0IaqnATlVGj7SeoSvUusqpoBkEPIUmPWDgNzVL1jVA/EC
	 fNeCr672tNsYDcjc+MSyofXJoqz2/U0qy0DhKWdY9rWclmBkSc+S+PrBYA40Mp3rz0
	 wvssWDrTQ/73w==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 4059D1CCDE0A; Wed, 23 Sep 2026 22:25:03 -0400 (EDT)
Date: Wed, 23 Sep 2026 22:25:03 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
        zlang@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, sandeen@redhat.com, dgc@kernel.org
Subject: Re: [PATCH] generic/492: bypass the blkid cache when probing the
 label
Message-ID: <arRIECW5MBX7fwfe@mit.edu>
References: <20260920094137.2749428-1-libaokun@linux.alibaba.com>
 <20260921052719.GB6253@frogsfrogsfrogs>
 <b4a10712-1658-4fba-a037-095fab466270@linux.alibaba.com>
 <20260921234910.GC6253@frogsfrogsfrogs>
 <arHaTLxSEk3yQxU4@mit.edu>
 <74463cb5-14af-47bb-9380-ca75dc5d293a@linux.alibaba.com>
 <arKZu30pMe0ZavVA@mit.edu>
 <8cc9f978-6365-4898-b3db-9f0b232aeb4c@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8cc9f978-6365-4898-b3db-9f0b232aeb4c@linux.alibaba.com>

On Wed, Sep 23, 2026 at 06:02:38PM -0500, Baokun Li wrote:
> >>     ./configure --disable-libblkid --disable-fsck \
> >>             --disable-libuuid --disable-uuidd
> > This works, but this wll also disable those e2fsprogs features that
> > require those libraries.  So mke2fs will not generate UUID's in the
> > superblock, e2fsck won't handle LABEL=xyzzy specifiers, etc.
> > Fortunately xfstests don't depend on these featuers, so this will work.
> 
> Hmm, what I disabled is exactly the set duplicated by util-linux:
> the blkid/uuid libs and UUID/LABEL= handling all live there, so
> the tools just link the system ones -- there is no functional loss.

The fact that you needed the --disable options implies that e2fsprogs
wasn't able to use the util-linux supplied libraries.  If the
configure script determines libblkid and libuuid are available for
linking against, (e.g., libblkid-dev and uuid-dev are installed), the
built-in libblkid and libuuid file systems are disabled.

From the configure script output:

checking for blkid_get_cache in -lblkid... yes
Using system blkid library by default

checking for uuid_generate in -luuid... yes
Using system uuid by default
Disabling uuidd by default

In contrast, if you run the configure script on MacOS, NetBSD, or a
Linux system missing the libuuid / libblkid development files, you
will see:

checking for uuid_generate in -luuid... no
Enabling private uuid library by default
Building uuidd by default

> Also, a thought that just came up: on the blkid side, would it be
> feasible to not trust the cache for mounted devices and always
> re-probe?  The mount / set label / umount / get label (within 2s)
> window would remain, but it would be much smaller.

Maybe.  It's not clear how often people might be trying to query the
blkid data.  Also, figuring out whether or not a device is mounted is
not free.  That would mean that for every blkid query, it would have
to read /proc/mounts to make that determination.  And note that on
some data center servers, there could potentially be hundreds if not
thousands of entries in /proc/mounts, either because you have a huge
number of bind mounts or overlayfs, and/or because you might have a
huge number of read-only iscsi mounts to deliver software packages to
your container based Borg or Kubernetes jobs.

I suppose you could put in the blkid cache a hint as to whether the
file system is mounted, but that in itself could get stale and out of
date.

Cheers,

					- Ted
