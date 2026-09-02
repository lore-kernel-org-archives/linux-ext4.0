Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 589D748095E
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 12:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788351483; cv=none; b=m19QYDg8jKNxxn2w2oPRFVXM13Ffg5AXk5eZHeJbBhQPnVlsD9g+/Wrrvc2jdLQvWDW6y/OHMCWmMHWApSkT37NqYQ2a9tiymIx5lOoSIf8YYZAmOlsm0GVO+fzBjO2rTdOwebQpY7sVaRLqK5TQ9SdURnvSq9MIx9QSnBDPHWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788351483; c=relaxed/simple;
	bh=G/wGXdxARiKPGWOyHmlw30tmCGTrLvSdKQ9wLPDVTqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8y6VHiJkWHuV7n/xO8gFMfYRRKcgSsQvW9j74b3IuCF7OXYHvXLUu0vn3lUg8z7/1j7VIyGlqir1rSonGgGmdyKvH/4ako457DZ8op57PG8OFEMqiiXKmgGIlxEPOkWGplWA6XVVfsH9kRz04xzQJhdA60juydMvoGdbY5cOr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rzwYOOrq; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rzwYOOrq"
Received: by linux.microsoft.com (Postfix, from userid 1217)
	id BA73420B7129; Wed,  2 Sep 2026 05:17:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BA73420B7129
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788351444;
	bh=3yuaEQ7kcPQDCxHltohGtYN2SW0Yvj/QivdmyZvRGA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rzwYOOrqrMknI4nHCQ19+aU3DvSoUi5qd+PeN9KApSKiLqffatpS5OTjUBxV5H0zT
	 rtjPBQalsOpzJTNcWW81lBwaeMoJcZNLcBxwhJjanXI12YeLGFoLLj1lfW6Lgg2byP
	 JuS5LYTSwJUehx0NrQEmWAQ0XSFHYYqU8drurP4I=
Date: Wed, 2 Sep 2026 05:17:24 -0700
From: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
To: Theodore Tso <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
	adilger@dilger.ca, srivatsa@csail.mit.edu
Subject: Re: [PATCH v2] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
Message-ID: <apgT1ECUXEF7FtPW@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <aoxF8FvVffocUSyI@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
 <20260824224006.GB6038@frogsfrogsfrogs>
 <ao7ygPaBH1AVudFR@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <apCRFu5vpNxRLO8Y@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apCRFu5vpNxRLO8Y@mit.edu>

On Thu, Aug 27, 2026 at 05:01:09PM -0400, Theodore Tso wrote:
> On Wed, Aug 26, 2026 at 07:04:48AM -0500, Nandakumar Raghavan wrote:
> > This was on purpose and not something I missed. The sd_device_get_parent_with_subsystem_devtype
> > requires libsystemd v251+, and e2fsck needs to keep working in contexts where
> > that dependency isn't available or isn't guaranteed to be new enough - non-systemd distros, older
> > LTS systems doing root-fs repair before userspace is fully up, embedded/recovery images, etc.
> 
> Cqn you name any other OS that has implemented
> 
> 	https://systemd.io/BLOCK_DEVICE_LOCKING/
> 
> *other* than systemd?  So for non-systemd distros, who cares if we
> don't have the functionality?  So what we could do is to use autoconf
> with something like this:
> 
> AC_CHECK_LIB(libsystemd, sd_device_get_parent_with_subsystem_devtype,
> 	AC_DEFINE(HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE, 1,
> 		[Define to 1 if libsystemd has sd_device_get_parent_with_subsystem_devtype]))
> 
> We would only do the flock(LOCK_EX) if and only if the function is
> present.  If it isn't, say on MacOS, FreeBSD, or RHEL 7 we won't play
> the systemd locking game --- which is fine, because it doesn't matter
> on those platforms.
> 
> If you care about running e2fsck built on RHEL 8 on RHEL 7, that's an
> easy problem to solve.  A executable linked using shared libraries
> won't work already since the shared libraries on RHEL 8 are too new.
> But we have a solution already, which is to use e2fsck.static, which
> is statically linked.
> 
> > Taking a hard runtime dependency on a versioned libsystemd API for a tool this fundamental felt
> > like a much bigger cost than by parsing (/sys/dev/block/MAJ:MIN/partition, .../dev), which only
> > relies on a stable kernel ABI with no library and no version floor. Happy to reconsider if
> > the project wants to take the dependency, but wanted to flag the tradeoff explicitly rather
> > than silently pick one side.
> 
> If we really cared about taking a binary built on a system with
> libsystemd. and running on a system without libsystemd, another
> solution that we've used is dlopen.
> 
> For an example of that's done, see misc/create_inode_libarchve.c and
> the associated autoconf tests in configure.ac in the e2fsprogs
> sources.  This is how "mke2fs -d embed_rootfs.tar.gz -t ext4 embed.img
> 1G" is handled without needing a hard dependency on libarchive being
> installed.  If it's not installed then you'll just get the error
> message "you need libarchive to be able to process tarballs".
> 
> I don't think the dlopen() approach is needed here, though.
> 
> Cheers,
> 
> 					- Ted
Thank you, Ted for the comments. I agree on all points. I will rework this to use AC_CHECK_LIB as
you described, switch to the sd-device API when libsystemd is present, and
drop the whole locking feature cleanly when it isn't. 
Patch v3 to follow.
