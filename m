Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E61476CC6
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 21:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283806; cv=none; b=Uq8JUMPVJ85FwV3KqbNNXz5UsERw25RnS+eWk+jRom3ydN3RepilLYRHMHT80z2pWC73iIFX5EDvgDdB4wffUxAC7N/kKt2x7M1CBC3MFjHWQiUZQCp1/Yl2fVYBl8/+9iuLNdShZZJbjuldr8rV9ieYbCPpfHCCQWdxwYX1umE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283806; c=relaxed/simple;
	bh=YAbp9fY4SKBdN6630QGsPwt22LGqgBwdpEJ5OSZgm2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNVc7Gt9W7mlFdH4gHAhnfqDyLAYYcIpKYVZZUzu2s6JCbIOvUwYPm6gULMnA4B2HT7qDksZDqhchdcpJLA/fTxMq0lOVl1A1cAeXcYaSiCpwkNFK72qEbmDbteoXtkcyD6xb++Zgd+8RGF/gidiP4TsrucWncb6kN+s10xuN20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hruFY6D8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hruFY6D8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9CD711F00893;
	Thu, 24 Sep 2026 21:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790283800;
	bh=pEOn3GFU192UQ3mCg5ooGL0sS3iY0MGnhRG0DyA0HXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hruFY6D8JeFKlsDHkReqt6aXc0M0QDYPTj7wzZUAGpjs1hSZo5nQ2OPx+94BXo+n6
	 pWT3UUxX3dJ+sx6NrIDCrsb+qoBRZQncIb36Kg5gi+USeD5SbDsKeaq2xuyaO9tsTi
	 h106QT4q+LHaAvkVFKf6ANcjpJNNyGv96irz1Qh8B62pUaIPbDl8qyukCMiEPsLBWu
	 bvQONArVt/FFxKqhn3FiukIGDTs/Ta473fXCiud7aZTrseU3/UkefW3xhafXKooBvO
	 xCqnm5TggazIOWWR1B7TnOZC7LWkhR6Z/hpf3Y72LEH6zqrCaKmH8Bz8uNAHHMqH1r
	 Jpr2IdcDLw54Q==
Date: Thu, 24 Sep 2026 14:03:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Nandakumar Raghavan <naraghavan@linux.microsoft.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	srivatsa@csail.mit.edu
Subject: Re: [PATCH v3] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
Message-ID: <20260924210320.GG6239@frogsfrogsfrogs>
References: <apCRFu5vpNxRLO8Y@mit.edu>
 <20260910120441.1017866-1-naraghavan@linux.microsoft.com>
 <arC0q5wHTuakmtW9@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <1a5d4f15-3d6b-2476-d0be-493606c17c17@ieee.org>
 <20260924003642.GE6239@frogsfrogsfrogs>
 <a2569834-31a9-4812-4a3b-384199844371@ieee.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2569834-31a9-4812-4a3b-384199844371@ieee.org>

On Thu, Sep 24, 2026 at 04:19:00PM -0400, Dan Streetman wrote:
> 
> 
> On Wed, 23 Sep 2026, Darrick J. Wong wrote:
> 
> > On Wed, Sep 23, 2026 at 03:55:23PM -0400, Dan Streetman wrote:
> > > 
> > > 
> > > On Sun, 20 Sep 2026, Nandakumar Raghavan wrote:
> > > 
> > > > On Thu, Sep 10, 2026 at 05:04:41AM -0700, Nandakumar Raghavan wrote:
> > > > > During journal replay, e2fsck writes the primary superblock back to disk
> > > > > in multiple I/O operations. The payload lands before the checksum, leaving
> > > > > a transient window where the on-disk superblock has a bad checksum.
> > > > > 
> > > > > If udevd processes a change uevent during this window, libblkid probes the
> > > > > primary superblock, finds a checksum mismatch, and concludes the partition
> > > > > has no recognisable filesystem. udev then fires a remove event, wiping all
> > > > > symlinks in /dev/disk/by-label/ and /dev/disk/by-uuid/. Any mount unit
> > > > > that depends on those symlinks will fail.
> > > > > 
> > > > > udevd already serialises its own partition probes against whole-disk device
> > > > > access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it requeues the
> > > > > event. Take advantage of this protocol by acquiring flock(LOCK_EX) on the
> > > > > whole-disk device before opening the filesystem. This forces udevd to defer
> > > > > all probes on that disk until e2fsck exits and the lock is released, by
> > > > > which point the filesystem is fully consistent.
> > > > > 
> > > > > The whole-disk device is resolved using libsystemd's sd-device API
> > > > > (sd_device_new_from_devnum(), sd_device_get_parent_with_subsystem_devtype())
> > > > > rather than parsing sysfs, so the lock covers the same device node
> > > > > that udevd itself resolves and locks.
> > > > > 
> > > > > This locking is entirely optional at build time where configure checks for
> > > > > sd_device_get_parent_with_subsystem_devtype() via AC_CHECK_LIB, and
> > > > > e2fsck.c only compiles in the locking code when it is found. On platforms
> > > > > without libsystemd there is no udevd to race against in the first place,
> > > > > so nothing is lost by skipping it there.
> > > > > 
> > > > > Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
> > > > > ---
> > > > > 
> > > > > Changes in v3:
> > > > >     - Resolve the parent whole-disk device using libsystemd's sd-device API
> > > > >       (sd_device_new_from_devnum(), sd_device_get_parent_with_subsystem_devtype(),
> > > > >       sd_device_get_devname()) instead of parsing sysfs paths
> > > > >     - Gate the feature on autoconf detecting
> > > > >       sd_device_get_parent_with_subsystem_devtype() via AC_CHECK_LIB; compile it
> > > > >       out entirely when libsystemd is absent, rather than falling back to another
> > > > >       implementation
> > > > >     - Use sd_device_new_from_devnum() rather than the sd_device_new_from_devname()
> > > > >       used by the systemd.io example, since the former has been available in
> > > > >       libsystemd for much longer, keeping the version floor as low as possible
> > > > >     - Keep lock_whole_disk()'s signature unconditional and provide a stub returning
> > > > >       -1 on the #else branch, so main()'s primary code path has no #ifdefs in it
> > > > >     
> > > > > Changes in v2:
> > > > >     - Guard the whole feature (function, call site, lock_fd, cleanup) rather than
> > > > >       just the function body, so it is fully absent from non-Linux builds 
> > > > >     - Collapse the three HAVE_SYS_*_H header guards into a single conditional
> > > > >     - Reuse a single dev_path[] buffer instead of three single-use stack buffers
> > > > >     - Keep translatable warning strings on one line each, even past 80 columns
> > > > >     - Drop the blanket "could not lock" warning that fired even when the target was
> > > > >       not a block device at all (e.g. a regular file), which broke most of
> > > > >       "make check"; lock_whole_disk() now only warns at the point of a genuine failure
> > > > >     - No change needed for the Ctrl-C/EINTR concern: the SIGINT handler is installed
> > > > >       before lock_whole_disk() runs and is not SA_RESTART, so a blocked flock() is
> > > > >       interrupted and the existing E2F_FLAG_CANCEL check unwinds cleanly
> > > > > 
> > > > >  MCONFIG.in         |  1 +
> > > > >  configure          | 71 +++++++++++++++++++++++++++++++++++
> > > > >  configure.ac       | 14 +++++++
> > > > >  e2fsck/Makefile.in |  6 +--
> > > > >  e2fsck/unix.c      | 93 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  lib/config.h.in    |  6 +++
> > > > >  6 files changed, 188 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/MCONFIG.in b/MCONFIG.in
> > > > > index d66e2f3b..d3055955 100644
> > > > > --- a/MCONFIG.in
> > > > > +++ b/MCONFIG.in
> > > > > @@ -137,6 +137,7 @@ LIBE2P = $(LIB)/libe2p@LIB_EXT@
> > > > >  LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
> > > > >  LIBUUID = @LIBUUID@ @SOCKET_LIB@
> > > > >  LIBMAGIC = @MAGIC_LIB@
> > > > > +LIBSYSTEMD = @SYSTEMD_LIB@
> > > > >  LIBFUSE = @FUSE_LIB@
> > > > >  LIBSUPPORT = $(LIBINTL) $(LIB)/libsupport@STATIC_LIB_EXT@
> > > > >  LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
> > > > > diff --git a/configure b/configure
> > > > > index b04b31af..696dd07c 100755
> > > > > --- a/configure
> > > > > +++ b/configure
> > > > > @@ -702,6 +702,7 @@ fuse3_CFLAGS
> > > > >  CLOCK_GETTIME_LIB
> > > > >  ARCHIVE_LIBS
> > > > >  ARCHIVE_CFLAGS
> > > > > +SYSTEMD_LIB
> > > > >  MAGIC_LIB
> > > > >  SOCKET_LIB
> > > > >  SIZEOF_TIME_T
> > > > > @@ -14130,6 +14131,76 @@ if test "$ac_cv_func_dlopen" = yes ; then
> > > > >     MAGIC_LIB=$DLOPEN_LIB
> > > > >  fi
> > > > >  
> > > > > +SYSTEMD_LIB=
> > > > > +{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for sd_device_get_parent_with_subsystem_devtype in -lsystemd" >&5
> > > > > +printf %s "checking for sd_device_get_parent_with_subsystem_devtype in -lsystemd... " >&6; }
> > > > > +if test ${ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype+y}
> > > > > +then :
> > > > > +  printf %s "(cached) " >&6
> > > > > +else case e in #(
> > > > > +  e) ac_check_lib_save_LIBS=$LIBS
> > > > > +LIBS="-lsystemd  $LIBS"
> > > > > +cat confdefs.h - <<_ACEOF >conftest.$ac_ext
> > > > > +/* end confdefs.h.  */
> > > > > +
> > > > > +/* Override any GCC internal prototype to avoid an error.
> > > > > +   Use char because int might match the return type of a GCC
> > > > > +   builtin and then its argument prototype would still apply.
> > > > > +   The 'extern "C"' is for builds by C++ compilers;
> > > > > +   although this is not generally supported in C code supporting it here
> > > > > +   has little cost and some practical benefit (sr 110532).  */
> > > > > +#ifdef __cplusplus
> > > > > +extern "C"
> > > > > +#endif
> > > > > +char sd_device_get_parent_with_subsystem_devtype (void);
> > > > > +int
> > > > > +main (void)
> > > > > +{
> > > > > +return sd_device_get_parent_with_subsystem_devtype ();
> > > > > +  ;
> > > > > +  return 0;
> > > > > +}
> > > > > +_ACEOF
> > > > > +if ac_fn_c_try_link "$LINENO"
> > > > > +then :
> > > > > +  ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype=yes
> > > > > +else case e in #(
> > > > > +  e) ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype=no ;;
> > > > > +esac
> > > > > +fi
> > > > > +rm -f core conftest.err conftest.$ac_objext conftest.beam \
> > > > > +    conftest$ac_exeext conftest.$ac_ext
> > > > > +LIBS=$ac_check_lib_save_LIBS ;;
> > > > > +esac
> > > > > +fi
> > > > > +{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype" >&5
> > > > > +printf "%s\n" "$ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype" >&6; }
> > > > > +if test "x$ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype" = xyes
> > > > > +then :
> > > > > +  SYSTEMD_LIB=-lsystemd
> > > > > +fi
> > > > > +
> > > > > +if test -n "$SYSTEMD_LIB"; then
> > > > > +	       for ac_header in systemd/sd-device.h
> > > > > +do :
> > > > > +  ac_fn_c_check_header_compile "$LINENO" "systemd/sd-device.h" "ac_cv_header_systemd_sd_device_h" "$ac_includes_default"
> > > > > +if test "x$ac_cv_header_systemd_sd_device_h" = xyes
> > > > > +then :
> > > > > +  printf "%s\n" "#define HAVE_SYSTEMD_SD_DEVICE_H 1" >>confdefs.h
> > > > > +
> > > > > +else case e in #(
> > > > > +  e) SYSTEMD_LIB= ;;
> > > > > +esac
> > > > > +fi
> > > > > +
> > > > > +done
> > > > > +fi
> > > > > +if test -n "$SYSTEMD_LIB"; then
> > > > > +
> > > > > +printf "%s\n" "#define HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE 1" >>confdefs.h
> > > > > +
> > > > > +fi
> > > > > +
> > > > >  
> > > > >  # Check whether --with-libarchive was given.
> > > > >  if test ${with_libarchive+y}
> > > > > diff --git a/configure.ac b/configure.ac
> > > > > index 4921f81f..9f585aae 100644
> > > > > --- a/configure.ac
> > > > > +++ b/configure.ac
> > > > > @@ -1309,6 +1309,20 @@ if test "$ac_cv_func_dlopen" = yes ; then
> > > > >  fi
> > > > >  AC_SUBST(MAGIC_LIB)
> > > > >  dnl
> > > > > +dnl See if libsystemd has sd-device APIs for whole-disk BSD locking
> > > > > +dnl
> > > > > +SYSTEMD_LIB=
> > > > > +AC_CHECK_LIB(systemd, sd_device_get_parent_with_subsystem_devtype,
> > > > > +	[SYSTEMD_LIB=-lsystemd])
> > > > > +if test -n "$SYSTEMD_LIB"; then
> > > > > +	AC_CHECK_HEADERS([systemd/sd-device.h], , [SYSTEMD_LIB=])
> > > > > +fi
> > > > > +if test -n "$SYSTEMD_LIB"; then
> > > > > +	AC_DEFINE(HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE, 1,
> > > > > +		[Define to 1 if libsystemd has sd-device APIs for whole-disk locking])
> > > > > +fi
> > > > > +AC_SUBST(SYSTEMD_LIB)
> > > > > +dnl
> > > > >  dnl libarchive
> > > > >  dnl
> > > > >  AC_ARG_WITH([libarchive],
> > > > > diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
> > > > > index fbb7b156..a050eafe 100644
> > > > > --- a/e2fsck/Makefile.in
> > > > > +++ b/e2fsck/Makefile.in
> > > > > @@ -17,20 +17,20 @@ MANPAGES=	e2fsck.8
> > > > >  FMANPAGES=	e2fsck.conf.5
> > > > >  
> > > > >  LIBS= $(LIBSUPPORT) $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBBLKID) $(LIBUUID) \
> > > > > -	$(LIBINTL) $(LIBE2P) $(LIBMAGIC) $(SYSLIBS)
> > > > > +	$(LIBINTL) $(LIBE2P) $(LIBMAGIC) $(LIBSYSTEMD) $(SYSLIBS)
> > > > >  DEPLIBS= $(DEPLIBSUPPORT) $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBBLKID) \
> > > > >  	 $(DEPLIBUUID) $(DEPLIBE2P)
> > > > >  
> > > > >  STATIC_LIBS= $(STATIC_LIBSUPPORT) $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) \
> > > > >  	     $(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL) $(STATIC_LIBE2P) \
> > > > > -	     $(LIBMAGIC) $(SYSLIBS)
> > > > > +	     $(LIBMAGIC) $(LIBSYSTEMD) $(SYSLIBS)
> > > > >  STATIC_DEPLIBS= $(DEPSTATIC_LIBSUPPORT) $(STATIC_LIBEXT2FS) \
> > > > >  		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBBLKID) \
> > > > >  		$(DEPSTATIC_LIBUUID) $(DEPSTATIC_LIBE2P)
> > > > >  
> > > > >  PROFILED_LIBS= $(PROFILED_LIBSUPPORT) $(PROFILED_LIBEXT2FS) \
> > > > >  	       $(PROFILED_LIBCOM_ERR) $(PROFILED_LIBBLKID) $(PROFILED_LIBUUID) \
> > > > > -	       $(PROFILED_LIBE2P) $(LIBINTL) $(LIBMAGIC) $(SYSLIBS)
> > > > > +	       $(PROFILED_LIBE2P) $(LIBINTL) $(LIBMAGIC) $(LIBSYSTEMD) $(SYSLIBS)
> > > > >  PROFILED_DEPLIBS= $(DEPPROFILED_LIBSUPPORT) $(PROFILED_LIBEXT2FS) \
> > > > >  		  $(DEPPROFILED_LIBCOM_ERR) $(DEPPROFILED_LIBBLKID) \
> > > > >  		  $(DEPPROFILED_LIBUUID) $(DEPPROFILED_LIBE2P)
> > > > > diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> > > > > index 335ca377..51bc41eb 100644
> > > > > --- a/e2fsck/unix.c
> > > > > +++ b/e2fsck/unix.c
> > > > > @@ -36,6 +36,11 @@ extern int optind;
> > > > >  #ifdef HAVE_SYS_IOCTL_H
> > > > >  #include <sys/ioctl.h>
> > > > >  #endif
> > > > > +#ifdef HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE
> > > > > +#include <sys/file.h>
> > > > > +#include <sys/stat.h>
> > > > > +#include <systemd/sd-device.h>
> > > > > +#endif
> > > > >  #ifdef HAVE_MALLOC_H
> > > > >  #include <malloc.h>
> > > > >  #endif
> > > > > @@ -1397,6 +1402,88 @@ err:
> > > > >  	return retval;
> > > > >  }
> > > > >  
> > > > > +static int lock_whole_disk(e2fsck_t ctx, const char *dev_name)
> > > > > +{
> > > > > +#ifdef HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE
> > > > > +	struct stat st;
> > > > > +	sd_device *dev = NULL, *whole_dev;
> > > > > +	const char *subsystem, *devtype, *whole_disk_devname;
> > > > > +	int r, fd;
> > > > > +
> > > > > +	if (stat(dev_name, &st) < 0)
> > > > > +		return -1;
> > > > > +
> > > > > +	if (!S_ISBLK(st.st_mode))
> > > > > +		return -1;
> > > > > +
> > > > > +	r = sd_device_new_from_devnum(&dev, 'b', st.st_rdev);
> > > > > +	if (r < 0)
> > > > > +		return -1;
> > > > > +
> > > > > +	r = sd_device_get_subsystem(dev, &subsystem);
> > > > > +	if (r < 0 || strcmp(subsystem, "block") != 0) {
> > > > > +		sd_device_unref(dev);
> > > > > +		return -1;
> > > > > +	}
> > > > > +
> > > > > +	r = sd_device_get_devtype(dev, &devtype);
> > > > > +	if (r < 0) {
> > > > > +		sd_device_unref(dev);
> > > > > +		return -1;
> > > > > +	}
> > > > > +
> > > > > +	/*
> > > > > +	 * If dev_name is a partition, resolve the parent whole-disk device
> > > > > +	 * so the flock covers the same device node that udevd locks before
> > > > > +	 * probing any partition on it.
> > > > > +	 */
> > > > > +	if (strcmp(devtype, "disk") == 0)
> > > > > +		whole_dev = dev;
> > > > > +	else {
> > > > > +		r = sd_device_get_parent_with_subsystem_devtype(dev, "block",
> > > > > +								 "disk", &whole_dev);
> > > > > +		if (r < 0) {
> > > > > +			log_err(ctx, _("Warning: could not resolve whole-disk device for %s; lock may not prevent udev races\n"), dev_name);
> > > > > +			sd_device_unref(dev);
> > > > > +			return -1;
> > > > > +		}
> > > > > +	}
> > > > > +
> > > > > +	r = sd_device_get_devname(whole_dev, &whole_disk_devname);
> > > > > +	if (r < 0) {
> > > > > +		sd_device_unref(dev);
> > > > > +		return -1;
> > > > > +	}
> > > > > +
> > > > > +	fd = open(whole_disk_devname, O_RDONLY | O_CLOEXEC, 0);
> > > > > +	if (fd < 0) {
> > > > > +		com_err(ctx->program_name, errno,
> > > > > +			_("while trying to open %s for locking"), whole_disk_devname);
> > > > > +		sd_device_unref(dev);
> > > > > +		return -1;
> > > > > +	}
> > > > > +	sd_device_unref(dev);
> > > > > +
> > > > > +	while (flock(fd, LOCK_EX) != 0) {
> > > > > +		if (errno == EINTR) {
> > > > > +			if (ctx->flags & E2F_FLAG_CANCEL) {
> > > > > +				close(fd);
> > > > > +				return -1;
> > > > > +			}
> > > > > +			continue;
> > > > > +		}
> > > > > +		com_err(ctx->program_name, errno,
> > > > > +			_("while trying to lock %s"), whole_disk_devname);
> > > > > +		close(fd);
> > > > > +		return -1;
> > > > > +	}
> > > > > +
> > > > > +	return fd;
> > > > > +#else
> > > > > +	return -1;
> > > > > +#endif /* HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE */
> > > > > +}
> > > > > +
> > > > >  int main (int argc, char *argv[])
> > > > >  {
> > > > >  	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
> > > > > @@ -1413,6 +1500,7 @@ int main (int argc, char *argv[])
> > > > >  	int journal_size;
> > > > >  	int sysval, sys_page_size = 4096;
> > > > >  	int old_bitmaps;
> > > > > +	int lock_fd = -1;
> > > > >  	__u32 features[3];
> > > > >  	char *cp;
> > > > >  	enum quota_type qtype;
> > > > > @@ -1488,6 +1576,8 @@ int main (int argc, char *argv[])
> > > > >  
> > > > >  	check_mount(ctx);
> > > > >  
> > > > > +	lock_fd = lock_whole_disk(ctx, ctx->filesystem_name);
> > > > > +
> > > > >  	if (!(ctx->options & E2F_OPT_PREEN) &&
> > > > >  	    !(ctx->options & E2F_OPT_NO) &&
> > > > >  	    !(ctx->options & E2F_OPT_YES)) {
> > > > > @@ -2169,6 +2259,9 @@ skip_write:
> > > > >  	ext2fs_close_free(&ctx->fs);
> > > > >  	free(ctx->journal_name);
> > > > >  
> > > > > +	if (lock_fd >= 0)
> > > > > +		close(lock_fd);
> > > > > +
> > > > >  	if (ctx->logf)
> > > > >  		fprintf(ctx->logf, "Exit status: %d\n", exit_value);
> > > > >  	e2fsck_free_context(ctx);
> > > > > diff --git a/lib/config.h.in b/lib/config.h.in
> > > > > index f129abfe..bc3ae4aa 100644
> > > > > --- a/lib/config.h.in
> > > > > +++ b/lib/config.h.in
> > > > > @@ -352,6 +352,9 @@
> > > > >  /* Define to 1 if if struct sockaddr contains sa_len */
> > > > >  #undef HAVE_SA_LEN
> > > > >  
> > > > > +/* Define to 1 if libsystemd has sd-device APIs for whole-disk locking */
> > > > > +#undef HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE
> > > > > +
> > > > >  /* Define to 1 if you have the 'secure_getenv' function. */
> > > > >  #undef HAVE_SECURE_GETENV
> > > > >  
> > > > > @@ -430,6 +433,9 @@
> > > > >  /* Define to 1 if you have the 'sysconf' function. */
> > > > >  #undef HAVE_SYSCONF
> > > > >  
> > > > > +/* Define to 1 if you have the <systemd/sd-device.h> header file. */
> > > > > +#undef HAVE_SYSTEMD_SD_DEVICE_H
> > > > > +
> > > > >  /* Define to 1 if you have the <sys/acl.h> header file. */
> > > > >  #undef HAVE_SYS_ACL_H
> > > > >  
> > > > > -- 
> > > > > 2.55.0
> > > > 
> > > > Hi,
> > > > 
> > > > Gentle ping on this patch.
> > > > 
> > > > I would appreciate any feedback.
> > > > 
> > > 
> > > Can you clarify why this should go into only fsck.ext4? Doesn't this
> > > problem exist for other filesystems too?
> > > 
> > > I sent an earlier email as well with links to:
> > > 
> > > 1) fsck used to lock the device, but it surfaced a bug in udevd
> > > https://bugs.freedesktop.org/show_bug.cgi?id=79576
> > > 
> > > 2) because of the bug, fsck stopped locking the device
> > > https://github.com/util-linux/util-linux/commit/3bbdae633f4a1dda5f95ee6c61f18a1c8ef12250
> > > 
> > > 3) the systemd-udevd bug was fixed
> > > https://github.com/systemd/systemd/commit/5d354e525a5
> > > 
> > > To me, it makes more sense for the locking that already exists in fsck
> > > to get updated (or reverted) to lock the entire device, using the
> > > existing -l param (or maybe a new param like --lock-device,
> > > --udevd-lock, etc., if util-linux maintainers don't want to change -l
> > > behavior).
> > > 
> > > Do you see an issue with doing the locking there instead of here in
> > > fsck.ext4?
> > 
> > /sbin/fsck (aka the dispatch wrapper program) doesn't necessarily know
> > which block device(s) are going to be opened by a the fsck.$FSTYP
> > program that it creates.  It might be able to infer that by opening any
> > parameter and performing the udev locking protocol after checking if
> > what it opened is a block device, but that wouldn't work for (say) a
> > fsck.XXX program for a multi-device filesystem wherein you only need to
> > specify one device and it will find the others.
> 
> I'm not following how you would have an ext4 filesystem on multiple
> devices/partitions, unless you are talking about md or dm, in which
> case it's irrelevant for the purposes of systemd-udevd because md/dm
> create a single logical device (e.g. /dev/md127) that is what udevd
> (and fsck.ext4) actually cares about.

Many Linux filesystems can attach to multiple block devices and store
data on them: XFS, btrfs, and bcachefs.  ext4 doesn't store any of its
own data on the journal device, but it still has to open the journal
device.

> If I'm completely missing what you mean, can you give an example of
> what you're talking about?

ext4 supports having a separate blockdev for a journal:

# mkfs.ext4 -O journal_dev /dev/sdb
mke2fs 1.47.2 (1-Jan-2025)
Discarding device blocks: done                            
Creating filesystem with 2579968 4k blocks and 0 inodes
Filesystem UUID: e11a1211-fdd7-408a-b342-a131692c2356
Superblock backups stored on blocks: 

Zeroing journal device:                
# mkfs.ext4 -J device=/dev/sdb -F /dev/sda
mke2fs 1.47.2 (1-Jan-2025)
Using journal device's blocksize: 4096
Discarding device blocks: done                            
Creating filesystem with 2579968 4k blocks and 645904 inodes
Filesystem UUID: a1789ae9-76e7-47e3-9972-5be0b8505517
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done                            
Writing inode tables: done                            
Adding journal to device /dev/sdb: done
Writing superblocks and filesystem accounting information: done 

# blkid /dev/sd[ab]
/dev/sda: UUID="a1789ae9-76e7-47e3-9972-5be0b8505517" EXT_JOURNAL="e11a1211-fdd7-408a-b342-a131692c2356" BLOCK_SIZE="4096" TYPE="ext4"
/dev/sdb: UUID="e11a1211-fdd7-408a-b342-a131692c2356" BLOCK_SIZE="4096" LOGUUID="e11a1211-fdd7-408a-b342-a131692c2356" TYPE="jbd"

Note that you don't have to pass the journal to e2fsck:

# e2fsck -fn /dev/sda
e2fsck 1.47.5~WIP-2026-03-08 (8-Mar-2026)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sda: 12/645904 files (0.0% non-contiguous), 50288/2579968 blocks

> > That said, this patchset also doesn't handle multi-device ext4
> > filesystems (i.e. external jbd2 journal device) because the author
> 
> I don't think an external journal is relevant for the purposes of udevd
> locking, is it?

Yes it is, e2fsck could need to replay the journal contents, and
presumably you want the same protection for the secondary devices as the
primary.

--D

> > doesn't want to do that.  In their defense, the udev flock()ing protocol
> > requires one to determine if an opened block device is a partition; if
> > it is, then it requires opening and locking the parent bdev (e.g. sdf1
> > -> sdf) instead of locking the original device.  This makes it way more
> > complicated for multi-device filesystems because now the client has to
> > detect multiple partitions coming from the same underlying device and
> > handle that appropriately.  I don't know why the protocol designers made
> > that choice.
> > 
> > I can run "trace-cmd record -e 'flock*'" to observe the locking
> > interactions with scsi disk partitions, but for whatever reason I don't
> > see any flocking going on if I use kpartx to create the partitions with
> > device-mapper.  No idea why that is.
> > 
> > --D
> > 
> 
