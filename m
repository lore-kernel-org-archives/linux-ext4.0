Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37BA4964F
	for <linux-ext4@vger.kernel.org>; Sat, 15 Aug 2026 05:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786771798; cv=none; b=QUd0/8s2IqJH1zUBd4QMze9yLwg5F/E7nvxYt7VJIUqFyDUkILRmeMw4BCJS2ZPnmTkM2Zmp1Q1VdXSBCV28Bm0kEWU3dHtjOZFQ3LC9XGTwc6l/IJE1ntDRZwBwTCZdGWfoRiCM58J3HODh9bAEE4peTgHxObGiX9szRq6utw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786771798; c=relaxed/simple;
	bh=6eJztae0Rz1TZO+2vQyGhygxMnXgaRyNxzVRt1X3HYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YY1z7E6ze6aLviYMEMC5FmvPEMCegPwrPwn5pzofJaXGDSBkgPJAPGu7fSIq5fgxwa/pXRND+vpQgjp7Ghrjppg3a84uenT5hI4L5QfklzZVGWwNGv5Wp6Pd8mN/rkIkHlLN0dDy1MPBpxM6fWWTgcNu27CComeQaoqta/gbhMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=XC3JRoU/; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="XC3JRoU/"
Received: by linux.microsoft.com (Postfix, from userid 1217)
	id 5A9BF20B7128; Fri, 14 Aug 2026 22:29:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5A9BF20B7128
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1786771770;
	bh=JGSVspztnoFzGvE+pUWvFitYn3BxF6J0K8UQo/NxSnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XC3JRoU/2izPVJKrVXSEOven1oThdgweQBm7ub+1qa+t3i83vZL1ym00istvBWoK8
	 R/Kf7x0La3xXCiNX2S6fBFWpRZYDsAQzvTtMPnHLu+HbSC6vL7NyQ6VKBIP6aUhezw
	 8QIsxgsEq0PGcZxM9tg04LGAQGUmYYCTDoW2OGos=
Date: Fri, 14 Aug 2026 22:29:30 -0700
From: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, srivatsa@csail.mit.edu
Subject: Re: [PATCH] e2fsck: take flock(LOCK_EX) on whole-disk device during
 filesystem check
Message-ID: <an/5Oj5mb/S1ekb8@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260720143246.4141501-1-naraghavan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720143246.4141501-1-naraghavan@linux.microsoft.com>

Hi,

Gentle ping on this patch.

I would appreciate any feedback when time permits.

On Mon, Jul 20, 2026 at 02:32:46PM +0000, Nandakumar Raghavan wrote:
> During journal replay, e2fsck writes the primary superblock back to disk
> in multiple I/O operations. The payload lands before the checksum, leaving
> a transient window where the on-disk superblock has a bad checksum.
> 
> If udevd processes a change uevent during this window, libblkid probes the
> primary superblock, finds a checksum mismatch, and concludes the partition
> has no recognisable filesystem. udev then fires a remove event, wiping all
> symlinks in /dev/disk/by-label/ and /dev/disk/by-uuid/. Any mount unit
> that depends on those symlinks will fail.
> 
> udevd already serialises its own partition probes against whole-disk device
> access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it requeues the
> event. Take advantage of this protocol by acquiring flock(LOCK_EX) on the
> whole-disk device before opening the filesystem. This forces udevd to defer
> all probes on that disk until e2fsck exits and the lock is released, by
> which point the filesystem is fully consistent.
> 
> The whole-disk device is resolved via sysfs (/sys/dev/block/MAJ:MIN/partition)
> so that the lock covers the same device node that udevd locks. If sysfs
> resolution fails, a warning is emitted and the lock falls back to the
> partition device itself.
> 
> Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
> ---
>  e2fsck/unix.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 105 insertions(+)
> 
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 335ca377..12a9f50a 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -36,6 +36,15 @@ extern int optind;
>  #ifdef HAVE_SYS_IOCTL_H
>  #include <sys/ioctl.h>
>  #endif
> +#ifdef HAVE_SYS_FILE_H
> +#include <sys/file.h>
> +#endif
> +#ifdef HAVE_SYS_STAT_H
> +#include <sys/stat.h>
> +#endif
> +#ifdef HAVE_SYS_SYSMACROS_H
> +#include <sys/sysmacros.h>
> +#endif
>  #ifdef HAVE_MALLOC_H
>  #include <malloc.h>
>  #endif
> @@ -1397,6 +1406,92 @@ err:
>  	return retval;
>  }
>  
> +static int lock_whole_disk(e2fsck_t ctx, const char *dev_name)
> +{
> +	struct stat st;
> +	char partition_attr[256];  /* sysfs 'partition' attribute path */
> +	char parent_dev_path[256]; /* sysfs '../dev' of the parent disk */
> +	char parent_devnum[32];
> +	FILE *f;
> +	unsigned int maj, min;
> +	int parent_resolved = 0;
> +	char lock_path[256];
> +	const char *opened_path;
> +	int fd;
> +
> +	if (stat(dev_name, &st) < 0)
> +		return -1;
> +
> +	if (!S_ISBLK(st.st_mode))
> +		return -1;
> +
> +	maj = major(st.st_rdev);
> +	min = minor(st.st_rdev);
> +
> +	/*
> +	 * If dev_name is a partition (sysfs 'partition' attribute exists),
> +	 * resolve the parent whole-disk device so the flock covers the same
> +	 * device node that udevd locks before probing any partition on it.
> +	 */
> +	snprintf(partition_attr, sizeof(partition_attr),
> +		 "/sys/dev/block/%u:%u/partition", maj, min);
> +
> +	if (access(partition_attr, F_OK) == 0) {
> +		snprintf(parent_dev_path, sizeof(parent_dev_path),
> +			 "/sys/dev/block/%u:%u/../dev", maj, min);
> +
> +		f = fopen(parent_dev_path, "r");
> +		if (f) {
> +			if (fscanf(f, "%31s", parent_devnum) == 1) {
> +				unsigned int pmaj, pmin;
> +				if (sscanf(parent_devnum, "%u:%u",
> +					   &pmaj, &pmin) == 2) {
> +					maj = pmaj;
> +					min = pmin;
> +					parent_resolved = 1;
> +				}
> +			}
> +			fclose(f);
> +		}
> +		if (!parent_resolved)
> +			log_err(ctx, _("Warning: could not resolve whole-disk "
> +				       "device for %s; lock may not prevent "
> +				       "udev races\n"), dev_name);
> +	}
> +
> +	snprintf(lock_path, sizeof(lock_path),
> +		 "/dev/block/%u:%u", maj, min);
> +
> +	opened_path = lock_path;
> +	fd = open(lock_path, O_RDONLY | O_CLOEXEC, 0);
> +	if (fd < 0) {
> +		fd = open(dev_name, O_RDONLY | O_CLOEXEC, 0);
> +		if (fd < 0)
> +			return -1;
> +		opened_path = dev_name;
> +		if (parent_resolved)
> +			log_err(ctx, _("Warning: %s not found; locking %s "
> +				       "instead, lock may not prevent "
> +				       "udev races\n"), lock_path, dev_name);
> +	}
> +
> +	while (flock(fd, LOCK_EX) != 0) {
> +		if (errno == EINTR) {
> +			if (ctx->flags & E2F_FLAG_CANCEL) {
> +				close(fd);
> +				return -1;
> +			}
> +			continue;
> +		}
> +		com_err(ctx->program_name, errno,
> +			_("while trying to lock %s"), opened_path);
> +		close(fd);
> +		return -1;
> +	}
> +
> +	return fd;
> +}
> +
>  int main (int argc, char *argv[])
>  {
>  	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
> @@ -1413,6 +1508,7 @@ int main (int argc, char *argv[])
>  	int journal_size;
>  	int sysval, sys_page_size = 4096;
>  	int old_bitmaps;
> +	int lock_fd = -1;
>  	__u32 features[3];
>  	char *cp;
>  	enum quota_type qtype;
> @@ -1488,6 +1584,12 @@ int main (int argc, char *argv[])
>  
>  	check_mount(ctx);
>  
> +	lock_fd = lock_whole_disk(ctx, ctx->filesystem_name);
> +	if (lock_fd < 0)
> +		log_err(ctx, _("Warning: could not lock %s; "
> +			       "proceeding without block device lock\n"),
> +			ctx->filesystem_name);
> +
>  	if (!(ctx->options & E2F_OPT_PREEN) &&
>  	    !(ctx->options & E2F_OPT_NO) &&
>  	    !(ctx->options & E2F_OPT_YES)) {
> @@ -2169,6 +2271,9 @@ skip_write:
>  	ext2fs_close_free(&ctx->fs);
>  	free(ctx->journal_name);
>  
> +	if (lock_fd >= 0)
> +		close(lock_fd);
> +
>  	if (ctx->logf)
>  		fprintf(ctx->logf, "Exit status: %d\n", exit_value);
>  	e2fsck_free_context(ctx);
> -- 
> 2.54.0
