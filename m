Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316B1241686
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 21:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787864860; cv=none; b=RrjbUrnNDPHMDxXCf32rT235QaF5W3m++ztXpAXFQ8QuqH8oc1hynbYGyLyHhMv+93PQ2GW3h3OAwKDyFXsfDmZAm5xPpn1OjByFn06DRXEySovThjmHrAxoauvSwsvFxqR5ec2LGVARdd7HKG4NVPy9oMqFksCdtJWwhGtlrHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787864860; c=relaxed/simple;
	bh=dDgbXlamxMrcMKbLL1wIkfulHYJQbiZgtzoV9+bZzNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QisnOV4z2USdiFdi3VlIRCn1l6ped0A3O8PfGqmhfv6Hb+wPg8IaOphrrmB+W9Ed7+5v8hJ8AGuAeSTc9kiauXxRYtHQ1KcP2WbMB6bVzq7MBUBjIXLOws3VEeNN1t+tMWpT1I3f1FX6UZkXbX1TcpNHI8JroeVvfSNHRb8JMck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=HbKYxiMb; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="HbKYxiMb"
Received: from macsyma.thunk.org (pool-173-48-113-140.bstnma.fios.verizon.net [173.48.113.140])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 67RL2Auk008885
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 17:02:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1787864532; bh=NCkniQ2q1y2l3Mb87PIJtW31rZ0rkcocWHTWit1jWEc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=HbKYxiMbYjvuky7m1RlWY0+KJc+Pd9/nHl+SqtkYMkby1iZX9oUkI0WVmlzQQCLq3
	 9GbR9l5SY6/+i5ElyGW5SctmAR+kaeWClK+XVySL8mJ0Ni1bD69+9p1oeR9Z+/khN1
	 9i3HqxhrtyzJSOtV8OzGSokqdxG3Wc24cn1MaLBF+uvfvKsXFbl+HSZvyUmrbbolPP
	 YJ11TSG67UtKVUfYM2LOZurEiX8rtM2ozTZXLPpKs8ibdKiRlyrd84nrPkvmLEbShl
	 BBFju3TiZ8HBU4/mfKmIxMSIUSg808vedaIVoIV+vBuL44eUSw0fZxzaRGQHh0IjgS
	 LPK/PwLD3fSCQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id ECF57123286B; Thu, 27 Aug 2026 17:01:09 -0400 (EDT)
Date: Thu, 27 Aug 2026 17:01:09 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
        adilger@dilger.ca, srivatsa@csail.mit.edu
Subject: Re: [PATCH v2] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
Message-ID: <apCRFu5vpNxRLO8Y@mit.edu>
References: <aoxF8FvVffocUSyI@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
 <20260824224006.GB6038@frogsfrogsfrogs>
 <ao7ygPaBH1AVudFR@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao7ygPaBH1AVudFR@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

On Wed, Aug 26, 2026 at 07:04:48AM -0500, Nandakumar Raghavan wrote:
> This was on purpose and not something I missed. The sd_device_get_parent_with_subsystem_devtype
> requires libsystemd v251+, and e2fsck needs to keep working in contexts where
> that dependency isn't available or isn't guaranteed to be new enough - non-systemd distros, older
> LTS systems doing root-fs repair before userspace is fully up, embedded/recovery images, etc.

Cqn you name any other OS that has implemented

	https://systemd.io/BLOCK_DEVICE_LOCKING/

*other* than systemd?  So for non-systemd distros, who cares if we
don't have the functionality?  So what we could do is to use autoconf
with something like this:

AC_CHECK_LIB(libsystemd, sd_device_get_parent_with_subsystem_devtype,
	AC_DEFINE(HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE, 1,
		[Define to 1 if libsystemd has sd_device_get_parent_with_subsystem_devtype]))

We would only do the flock(LOCK_EX) if and only if the function is
present.  If it isn't, say on MacOS, FreeBSD, or RHEL 7 we won't play
the systemd locking game --- which is fine, because it doesn't matter
on those platforms.

If you care about running e2fsck built on RHEL 8 on RHEL 7, that's an
easy problem to solve.  A executable linked using shared libraries
won't work already since the shared libraries on RHEL 8 are too new.
But we have a solution already, which is to use e2fsck.static, which
is statically linked.

> Taking a hard runtime dependency on a versioned libsystemd API for a tool this fundamental felt
> like a much bigger cost than by parsing (/sys/dev/block/MAJ:MIN/partition, .../dev), which only
> relies on a stable kernel ABI with no library and no version floor. Happy to reconsider if
> the project wants to take the dependency, but wanted to flag the tradeoff explicitly rather
> than silently pick one side.

If we really cared about taking a binary built on a system with
libsystemd. and running on a system without libsystemd, another
solution that we've used is dlopen.

For an example of that's done, see misc/create_inode_libarchve.c and
the associated autoconf tests in configure.ac in the e2fsprogs
sources.  This is how "mke2fs -d embed_rootfs.tar.gz -t ext4 embed.img
1G" is handled without needing a hard dependency on libarchive being
installed.  If it's not installed then you'll just get the error
message "you need libarchive to be able to process tarballs".

I don't think the dlopen() approach is needed here, though.

Cheers,

					- Ted
