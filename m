Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AAA31D375
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2026 22:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787611209; cv=none; b=LZXt8XUIGpQ4Yk6+WlyJhZh8C68NvRtIx7eoDsVO8jAeO4VPYXPmItjWYzOAvSSwOjHfoujhsja0v+VBJAbEajAhMk+Wgg5GWh5GbXIZCQ/Bbi1ftrnqN0oCf6bCRlbcb/3HlYcWmR9xj6yA6UxrfOvDfgF2N8bpoebliacmYLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787611209; c=relaxed/simple;
	bh=Dgsd7JYWfSt/KV4eb+TybxFSX+PRN/EK6bH+QUfxjAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hM7bis22VVmVWzBjt12Ca4oURUFUFiOfUAIakyipBjzrdcDXVYem3kqo3VZo4NJiTtFAC0wYznNYgUEAkrMGGstesL8+I4eGnn8tTFACptgmHON499+d9+LJIcmFWUzDQ9v4KhvxrtHKk0zHE94eNX1v6AsXnw+KL+dLkr3GOdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IflTcmO7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IflTcmO7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7D9611F000E9;
	Mon, 24 Aug 2026 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787611207;
	bh=5oQC2wEcBvfeA+N8xoVn4xBSDjvwaGqa57tlvk283HQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IflTcmO7VX3+qwT4Etr8wGpkWXyBddk74oeKocOBY6AzsYGUMRj2eJ669fxeAlp4D
	 WXrpuQLjwRvqI7ZdeBMZouKvS+1PW5WNK1wjchwUE4IGArDUoAuvqjBYMIMM+Jv73p
	 jvpnixFv1etx6yXel+epJdXt7IosLCPglObNSxRE530lwKtGPG+yN6Lnes3Rerw3Tg
	 1mtnE4WSFt02wuXeWhTJzf8zokwc4sbnKUvUcj3NR3xkwbFi03i+xdUCQsvhfhh5Hf
	 8FfkPKPOATO9y7AozltYjZBIobOkR4opJC4sH+85ISeWHedcgrJ4jJfzy0wLDlq+Co
	 ehyl24EWJXHfQ==
Date: Mon, 24 Aug 2026 15:40:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	srivatsa@csail.mit.edu
Subject: Re: [PATCH v2] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
Message-ID: <20260824224006.GB6038@frogsfrogsfrogs>
References: <aoxF8FvVffocUSyI@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260824161512.1332649-1-naraghavan@linux.microsoft.com>

On Mon, Aug 24, 2026 at 09:15:11AM -0700, Nandakumar Raghavan wrote:
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
> This mechanism relies on Linux-specific interfaces (sysfs, flock() semantics
> on block devices) and is compiled out entirely on non-Linux platforms.

You're clearly implementing the "Locking Block Device Access" protocol
as documented by systemd:
https://systemd.io/BLOCK_DEVICE_LOCKING/

So why not use libsystemd like the example in that posting provides?
sd_device_get_parent_with_subsystem_devtype is much less gross than
open-coding the same logic here.

> Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
> ---
> 
> Changes in v2:
> - Guard the whole feature (function, call site, lock_fd, cleanup) with
>   #ifdef __linux__ instead of just the function body, so it's fully
>   absent from non-Linux builds 
> - Collapse HAVE_SYS_*_H header guards into a single #ifdef __linux__
> - Reuse a single dev_path[] buffer instead of three separate stack
>   buffers
> - Keep translatable warning strings on one line each, even past 80
>   columns 
> - Drop the blanket "could not lock" warning that fired even when the
>   target wasn't a block device at all (e.g. a regular file), which was
>   causing issues with tests; lock_whole_disk() now only warns/errors
>   at the point of a genuine failure
> - No change needed for the Ctrl-C/EINTR concern — traced and confirmed
>   the existing signal handling already unwinds cleanly
> 
>  e2fsck/unix.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 101 insertions(+)
> 
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 335ca377..cf21752a 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -36,6 +36,11 @@ extern int optind;
>  #ifdef HAVE_SYS_IOCTL_H
>  #include <sys/ioctl.h>
>  #endif
> +#ifdef __linux__
> +#include <sys/file.h>
> +#include <sys/stat.h>
> +#include <sys/sysmacros.h>
> +#endif
>  #ifdef HAVE_MALLOC_H
>  #include <malloc.h>
>  #endif
> @@ -1397,6 +1402,90 @@ err:
>  	return retval;
>  }
>  
> +#ifdef __linux__
> +static int lock_whole_disk(e2fsck_t ctx, const char *dev_name)
> +{
> +	struct stat st;
> +	char dev_path[256]; /* reused for each sysfs/device path we build */
> +	char parent_devnum[32];
> +	FILE *f;
> +	unsigned int maj, min;
> +	int parent_resolved = 0;
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
> +	snprintf(dev_path, sizeof(dev_path),
> +		 "/sys/dev/block/%u:%u/partition", maj, min);
> +
> +	if (access(dev_path, F_OK) == 0) {
> +		snprintf(dev_path, sizeof(dev_path),
> +			 "/sys/dev/block/%u:%u/../dev", maj, min);
> +
> +		f = fopen(dev_path, "r");
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
> +			log_err(ctx, _("Warning: could not resolve whole-disk device for %s; lock may not prevent udev races\n"), dev_name);
> +	}
> +
> +	snprintf(dev_path, sizeof(dev_path), "/dev/block/%u:%u", maj, min);
> +
> +	opened_path = dev_path;
> +	fd = open(dev_path, O_RDONLY | O_CLOEXEC, 0);
> +	if (fd < 0) {
> +		fd = open(dev_name, O_RDONLY | O_CLOEXEC, 0);
> +		if (fd < 0) {
> +			com_err(ctx->program_name, errno,
> +				_("while trying to open %s for locking"), dev_name);
> +			return -1;
> +		}
> +		opened_path = dev_name;
> +		if (parent_resolved)
> +			log_err(ctx, _("Warning: %s not found; locking %s instead, lock may not prevent udev races\n"), dev_path, dev_name);
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
> +#endif /* __linux__ */
> +
>  int main (int argc, char *argv[])
>  {
>  	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
> @@ -1413,6 +1502,9 @@ int main (int argc, char *argv[])
>  	int journal_size;
>  	int sysval, sys_page_size = 4096;
>  	int old_bitmaps;
> +#ifdef __linux__
> +	int lock_fd = -1;
> +#endif
>  	__u32 features[3];
>  	char *cp;
>  	enum quota_type qtype;
> @@ -1488,6 +1580,10 @@ int main (int argc, char *argv[])
>  
>  	check_mount(ctx);
>  
> +#ifdef __linux__
> +	lock_fd = lock_whole_disk(ctx, ctx->filesystem_name);

If the filesystem has an external journal device, doesn't that also need
locking?

Why isn't this implemented as part of the unixio manager?

--D

> +#endif
> +
>  	if (!(ctx->options & E2F_OPT_PREEN) &&
>  	    !(ctx->options & E2F_OPT_NO) &&
>  	    !(ctx->options & E2F_OPT_YES)) {
> @@ -2169,6 +2265,11 @@ skip_write:
>  	ext2fs_close_free(&ctx->fs);
>  	free(ctx->journal_name);
>  
> +#ifdef __linux__
> +	if (lock_fd >= 0)
> +		close(lock_fd);
> +#endif
> +
>  	if (ctx->logf)
>  		fprintf(ctx->logf, "Exit status: %d\n", exit_value);
>  	e2fsck_free_context(ctx);
> -- 
> 2.54.0
> 
> 
