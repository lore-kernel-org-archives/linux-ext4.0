Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9546C3998A6
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2026 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787753123; cv=none; b=LhHfzkeYPc3uOOhBbRP3YH/CqTt1QJHuo/VzBGRYTO3rgTaK3DzQyklwnCr1JqmDrAIwVgfKgLDFwBguA1ESQ4sRqD3/QTTbuWx39x4BneZD/WNj+DP4s2t2Y9Fs2ROnBxe2VccMzrDi46ouw1JIDl6Kk/CrlFf8SXdqD05Ak78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787753123; c=relaxed/simple;
	bh=GOgNlu19mHVyrCBex3zI/df0e0+0PkuN7AGfuh5oEwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rubvj5mPFXWYYX3gs6HmKZ7VLU+rsBVjg0GTUqKfjTghC033Tcf17EZ9C27nLWCFqKi7JHy1X1ix+zjNcpOrKOs9c18dhP1VLskc1dCF+HEpBzvQC+PvDOwM+9dSBopi3xjcxacNMCj9YqyAI/Jm2JMq/9iaPpaPCrxGDY2iV7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=hzyMAOhl; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="hzyMAOhl"
Received: by linux.microsoft.com (Postfix, from userid 1217)
	id D051A20B7166; Wed, 26 Aug 2026 07:04:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D051A20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787753088;
	bh=bOyFYRUACgCklPrdr9mUfT/QKiqPPJaNqmkDE3rGArw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hzyMAOhlARu1A2O/QhQYxjAO1KkBcTtc1H+6OxFz3MTJ8LNlYzFGx8TlngccOjqCL
	 qGLEqXz7WmfIO1znN1VdvDsDo9DO2pzgt83XRQiQJFcjTLsu/eZIX4nLOvWSXncXOu
	 it4v6SbmMqYibWegWnZWIUp5KTcTKCul6iRKpJZQ=
Date: Wed, 26 Aug 2026 07:04:48 -0700
From: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	srivatsa@csail.mit.edu
Subject: Re: [PATCH v2] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
Message-ID: <ao7ygPaBH1AVudFR@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <aoxF8FvVffocUSyI@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
 <20260824224006.GB6038@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260824224006.GB6038@frogsfrogsfrogs>

On Mon, Aug 24, 2026 at 03:40:06PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 24, 2026 at 09:15:11AM -0700, Nandakumar Raghavan wrote:
> > During journal replay, e2fsck writes the primary superblock back to disk
> > in multiple I/O operations. The payload lands before the checksum, leaving
> > a transient window where the on-disk superblock has a bad checksum.
> > 
> > If udevd processes a change uevent during this window, libblkid probes the
> > primary superblock, finds a checksum mismatch, and concludes the partition
> > has no recognisable filesystem. udev then fires a remove event, wiping all
> > symlinks in /dev/disk/by-label/ and /dev/disk/by-uuid/. Any mount unit
> > that depends on those symlinks will fail.
> > 
> > udevd already serialises its own partition probes against whole-disk device
> > access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it requeues the
> > event. Take advantage of this protocol by acquiring flock(LOCK_EX) on the
> > whole-disk device before opening the filesystem. This forces udevd to defer
> > all probes on that disk until e2fsck exits and the lock is released, by
> > which point the filesystem is fully consistent.
> > 
> > The whole-disk device is resolved via sysfs (/sys/dev/block/MAJ:MIN/partition)
> > so that the lock covers the same device node that udevd locks. If sysfs
> > resolution fails, a warning is emitted and the lock falls back to the
> > partition device itself.
> > 
> > This mechanism relies on Linux-specific interfaces (sysfs, flock() semantics
> > on block devices) and is compiled out entirely on non-Linux platforms.
> 
> You're clearly implementing the "Locking Block Device Access" protocol
> as documented by systemd:
> https://systemd.io/BLOCK_DEVICE_LOCKING/
> 
> So why not use libsystemd like the example in that posting provides?
> sd_device_get_parent_with_subsystem_devtype is much less gross than
> open-coding the same logic here.
This was on purpose and not something I missed. The sd_device_get_parent_with_subsystem_devtype
requires libsystemd v251+, and e2fsck needs to keep working in contexts where
that dependency isn't available or isn't guaranteed to be new enough - non-systemd distros, older
LTS systems doing root-fs repair before userspace is fully up, embedded/recovery images, etc.
Taking a hard runtime dependency on a versioned libsystemd API for a tool this fundamental felt
like a much bigger cost than by parsing (/sys/dev/block/MAJ:MIN/partition, .../dev), which only
relies on a stable kernel ABI with no library and no version floor. Happy to reconsider if
the project wants to take the dependency, but wanted to flag the tradeoff explicitly rather
than silently pick one side.
> 
> > Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
> > ---
> > 
> > Changes in v2:
> > - Guard the whole feature (function, call site, lock_fd, cleanup) with
> >   #ifdef __linux__ instead of just the function body, so it's fully
> >   absent from non-Linux builds 
> > - Collapse HAVE_SYS_*_H header guards into a single #ifdef __linux__
> > - Reuse a single dev_path[] buffer instead of three separate stack
> >   buffers
> > - Keep translatable warning strings on one line each, even past 80
> >   columns 
> > - Drop the blanket "could not lock" warning that fired even when the
> >   target wasn't a block device at all (e.g. a regular file), which was
> >   causing issues with tests; lock_whole_disk() now only warns/errors
> >   at the point of a genuine failure
> > - No change needed for the Ctrl-C/EINTR concern — traced and confirmed
> >   the existing signal handling already unwinds cleanly
> > 
> >  e2fsck/unix.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 101 insertions(+)
> > 
> > diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> > index 335ca377..cf21752a 100644
> > --- a/e2fsck/unix.c
> > +++ b/e2fsck/unix.c
> > @@ -36,6 +36,11 @@ extern int optind;
> >  #ifdef HAVE_SYS_IOCTL_H
> >  #include <sys/ioctl.h>
> >  #endif
> > +#ifdef __linux__
> > +#include <sys/file.h>
> > +#include <sys/stat.h>
> > +#include <sys/sysmacros.h>
> > +#endif
> >  #ifdef HAVE_MALLOC_H
> >  #include <malloc.h>
> >  #endif
> > @@ -1397,6 +1402,90 @@ err:
> >  	return retval;
> >  }
> >  
> > +#ifdef __linux__
> > +static int lock_whole_disk(e2fsck_t ctx, const char *dev_name)
> > +{
> > +	struct stat st;
> > +	char dev_path[256]; /* reused for each sysfs/device path we build */
> > +	char parent_devnum[32];
> > +	FILE *f;
> > +	unsigned int maj, min;
> > +	int parent_resolved = 0;
> > +	const char *opened_path;
> > +	int fd;
> > +
> > +	if (stat(dev_name, &st) < 0)
> > +		return -1;
> > +
> > +	if (!S_ISBLK(st.st_mode))
> > +		return -1;
> > +
> > +	maj = major(st.st_rdev);
> > +	min = minor(st.st_rdev);
> > +
> > +	/*
> > +	 * If dev_name is a partition (sysfs 'partition' attribute exists),
> > +	 * resolve the parent whole-disk device so the flock covers the same
> > +	 * device node that udevd locks before probing any partition on it.
> > +	 */
> > +	snprintf(dev_path, sizeof(dev_path),
> > +		 "/sys/dev/block/%u:%u/partition", maj, min);
> > +
> > +	if (access(dev_path, F_OK) == 0) {
> > +		snprintf(dev_path, sizeof(dev_path),
> > +			 "/sys/dev/block/%u:%u/../dev", maj, min);
> > +
> > +		f = fopen(dev_path, "r");
> > +		if (f) {
> > +			if (fscanf(f, "%31s", parent_devnum) == 1) {
> > +				unsigned int pmaj, pmin;
> > +				if (sscanf(parent_devnum, "%u:%u",
> > +					   &pmaj, &pmin) == 2) {
> > +					maj = pmaj;
> > +					min = pmin;
> > +					parent_resolved = 1;
> > +				}
> > +			}
> > +			fclose(f);
> > +		}
> > +		if (!parent_resolved)
> > +			log_err(ctx, _("Warning: could not resolve whole-disk device for %s; lock may not prevent udev races\n"), dev_name);
> > +	}
> > +
> > +	snprintf(dev_path, sizeof(dev_path), "/dev/block/%u:%u", maj, min);
> > +
> > +	opened_path = dev_path;
> > +	fd = open(dev_path, O_RDONLY | O_CLOEXEC, 0);
> > +	if (fd < 0) {
> > +		fd = open(dev_name, O_RDONLY | O_CLOEXEC, 0);
> > +		if (fd < 0) {
> > +			com_err(ctx->program_name, errno,
> > +				_("while trying to open %s for locking"), dev_name);
> > +			return -1;
> > +		}
> > +		opened_path = dev_name;
> > +		if (parent_resolved)
> > +			log_err(ctx, _("Warning: %s not found; locking %s instead, lock may not prevent udev races\n"), dev_path, dev_name);
> > +	}
> > +
> > +	while (flock(fd, LOCK_EX) != 0) {
> > +		if (errno == EINTR) {
> > +			if (ctx->flags & E2F_FLAG_CANCEL) {
> > +				close(fd);
> > +				return -1;
> > +			}
> > +			continue;
> > +		}
> > +		com_err(ctx->program_name, errno,
> > +			_("while trying to lock %s"), opened_path);
> > +		close(fd);
> > +		return -1;
> > +	}
> > +
> > +	return fd;
> > +}
> > +#endif /* __linux__ */
> > +
> >  int main (int argc, char *argv[])
> >  {
> >  	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
> > @@ -1413,6 +1502,9 @@ int main (int argc, char *argv[])
> >  	int journal_size;
> >  	int sysval, sys_page_size = 4096;
> >  	int old_bitmaps;
> > +#ifdef __linux__
> > +	int lock_fd = -1;
> > +#endif
> >  	__u32 features[3];
> >  	char *cp;
> >  	enum quota_type qtype;
> > @@ -1488,6 +1580,10 @@ int main (int argc, char *argv[])
> >  
> >  	check_mount(ctx);
> >  
> > +#ifdef __linux__
> > +	lock_fd = lock_whole_disk(ctx, ctx->filesystem_name);
> 
> If the filesystem has an external journal device, doesn't that also need
> locking?
Good point, and no, it doesn't currently - lock_whole_disk() is only called on
ctx->filesystem_name. An external journal device (-O journal_dev) is a separate
block device with its own by-uuid symlinks, and I don't have a strong argument
that it's immune to the same class of race during replay. I'd like to treat
this as a follow-up rather than block on it, since it needs a bit more digging
into whether the external journal's own superblock write pattern actually
creates the same transient-bad-checksum window - but I don't want to just wave
it away either.
> 
> Why isn't this implemented as part of the unixio manager?
Agreed this is architecturally the more correct home for it - mke2fs, tune2fs,
and resize2fs go through the same unix_io manager and do similar multi-step
writes to live block devices, so they're exposed to the same race and get none
of this protection today. I scoped this patch to e2fsck specifically because
that's the most common/severe case in practice and wanted a narrow, reviewable
first fix rather than a bigger refactor touching every tool at once.
I can look at moving this into unix_io_open()/unix_io_close() as a follow-up
so mke2fs/tune2fs/resize2fs pick it up automatically via ext2fs_open()/close() 

> 
> --D
> 
> > +#endif
> > +
> >  	if (!(ctx->options & E2F_OPT_PREEN) &&
> >  	    !(ctx->options & E2F_OPT_NO) &&
> >  	    !(ctx->options & E2F_OPT_YES)) {
> > @@ -2169,6 +2265,11 @@ skip_write:
> >  	ext2fs_close_free(&ctx->fs);
> >  	free(ctx->journal_name);
> >  
> > +#ifdef __linux__
> > +	if (lock_fd >= 0)
> > +		close(lock_fd);
> > +#endif
> > +
> >  	if (ctx->logf)
> >  		fprintf(ctx->logf, "Exit status: %d\n", exit_value);
> >  	e2fsck_free_context(ctx);
> > -- 
> > 2.54.0
> > 
> > 
