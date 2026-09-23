Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21A1425882
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 19:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790193331; cv=none; b=YArXVSV6b/+Q8ghxQug8uG28ekzbIXq7K4qAsI2VaVLOGSI8l6ZNjpRlYTaKGf2PKmLRcWXDYPJKYkMTaj1+emLmHPlcUFF7tdaCu+YJCEPoeFSb4XL6wY1zYBBD2TTZzx2OgK8o+bXsY2D666+w5W8X5+l9Nf22oEFXk/iRHb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790193331; c=relaxed/simple;
	bh=Pmm84k1yGmGjRQ9H8BhcFV2EirFnG9tqpoFl1CjoHAw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EeDNwrjSS7JvZ7mOquLceIREwza2Wad3imNkPJ30pJpAOq1NzDQaugiBTGyNNUMO3M5WjhC3DmpVq+Y7OFTgSuwvaWlXp1rCbasXQ1MwZSMiUKLqSeMU8QjnOfMvCvABLFR4xwZYU9eyb73yrwOpBJiHXf3qJFkxwk7jp0bmc2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=RXzt/31b; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="RXzt/31b"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910ca5aa7so122333385a.1
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 12:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1790193325; x=1790798125; darn=vger.kernel.org;
        h=content-type:mime-version:user-agent:references:message-id
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5DJ84Cs3U/HP2MlbxlyKl6uHnqSsgATPDUH/9EGd4ls=;
        b=RXzt/31bTqXnw8yrLwPjG/xeo/J0uSz6CDN+Ecf++9CMRw8OD+VGKsAhjuczS0S1g9
         rEOibmkucAiVlmwW1H30Wp+eYxi4qabOMhkkVoCB1H1ciAJUQSl49jai3+2Mj4YGJIZv
         j0CCC8EqXeJduyKzzp5Dwkq56A6oHcQzUeSEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790193325; x=1790798125;
        h=content-type:mime-version:user-agent:references:message-id
         :in-reply-to:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5DJ84Cs3U/HP2MlbxlyKl6uHnqSsgATPDUH/9EGd4ls=;
        b=uh/SnDfRPZoU4FEF1pGGRwJXfIiLpeiyPrEVokE1QKWV2NFVK/9QN5c/zS6ZcwQmRI
         lTBqdziNfnv8MPBY9yC/q/gV7ytFdcQ1trbXqUJY16pww8Rs+kGO810c5VxNNsz0Ykd0
         lKeV6aYOSUbZNzDpRCghrTtFGSyhoVNYu26qFsl0BqxA6D0MICbRxMmQxqX+EIz71a72
         gj8JL0d0icNfhj4xAWko2MmrdAH18MPWmjpIItjL7AaNWQEDt9y2UPrib8bXW1HBU6o2
         WTHr2IHVeROdJDdOvHDsHBvZosJkNNd6LhiA42FmPR9TKmQa+wado3ZCCisYglO7P29A
         o5WQ==
X-Gm-Message-State: AFuF++l82V4eGCcX3xYckGLnvvogYBtNmLip6qKVvCsxpDPbC0+SuATK
	/uGwJSyrrfDOnaXIWSU9oqXQMyE+adZb0AqERhx0LpYksOKEjFtyc3pyHCvA+41oWw==
X-Gm-Gg: AYBFou0G02eKQ2ddIN6PPBom1smwIOrXYTolVefLKRfcrugZjxemT3xGUYcF2A++N6L
	It335XuzxgwV0VIoHLSCN2kaL+ZMqbrU87tap7zNIZmWnUWWrNKRYMfZ7W+kMlovuKLSVCN4zHN
	PJwi7wYMtw4p4Oqb+HJ5mV88IvBhcIEBYlLKQAE+gnEvfkbxCVgG9FNU7zsNxCWY67/F8FwmJAB
	JaemIHEEPQ5u1RRQTcgOevT7UWgXrPCC3eCkiv5Ys7OZ+IpbAxZ8V4yO4S4DvdFRfmir0r+s4+S
	XNEvFHujqySWkIzzNUCRYqmgVaSaoB/15Wrr4dz+FudA7bEjJ/Syj3ecl/dsAojMmtrCrZr922s
	kKMpWYQL8QVN3hPn51qbAS4RROF9fijE6Qh2WhPO5ce32r59W1mm42yBd6lqGW10KKGTHtNocE8
	6NJpkrTWyL86gqDVbF5DZnCQDJ3JpSURH+I0JpYmoeyoxjd/2r0EDtATtYdCCYKSO0
X-Received: by 2002:a05:620a:271b:b0:939:f513:cc3b with SMTP id af79cd13be357-93c3479e324mr32956485a.42.1790193325049;
        Wed, 23 Sep 2026 12:55:25 -0700 (PDT)
Received: from thrain ([2600:1700:7c0:543f:98a7:54ff:fe4d:e97d])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9141e2c88b2sm1855596d6.44.2026.09.23.12.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 12:55:24 -0700 (PDT)
Date: Wed, 23 Sep 2026 15:55:23 -0400 (EDT)
From: Dan Streetman <ddstreet@ieee.org>
To: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, 
    djwong@kernel.org, srivatsa@csail.mit.edu
Subject: Re: [PATCH v3] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
In-Reply-To: <arC0q5wHTuakmtW9@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Message-ID: <1a5d4f15-3d6b-2476-d0be-493606c17c17@ieee.org>
References: <apCRFu5vpNxRLO8Y@mit.edu> <20260910120441.1017866-1-naraghavan@linux.microsoft.com> <arC0q5wHTuakmtW9@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
User-Agent: Alpine 2.26 (DEB 649 2022-06-02)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII



On Sun, 20 Sep 2026, Nandakumar Raghavan wrote:

> On Thu, Sep 10, 2026 at 05:04:41AM -0700, Nandakumar Raghavan wrote:
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
> > The whole-disk device is resolved using libsystemd's sd-device API
> > (sd_device_new_from_devnum(), sd_device_get_parent_with_subsystem_devtype())
> > rather than parsing sysfs, so the lock covers the same device node
> > that udevd itself resolves and locks.
> > 
> > This locking is entirely optional at build time where configure checks for
> > sd_device_get_parent_with_subsystem_devtype() via AC_CHECK_LIB, and
> > e2fsck.c only compiles in the locking code when it is found. On platforms
> > without libsystemd there is no udevd to race against in the first place,
> > so nothing is lost by skipping it there.
> > 
> > Signed-off-by: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
> > ---
> > 
> > Changes in v3:
> >     - Resolve the parent whole-disk device using libsystemd's sd-device API
> >       (sd_device_new_from_devnum(), sd_device_get_parent_with_subsystem_devtype(),
> >       sd_device_get_devname()) instead of parsing sysfs paths
> >     - Gate the feature on autoconf detecting
> >       sd_device_get_parent_with_subsystem_devtype() via AC_CHECK_LIB; compile it
> >       out entirely when libsystemd is absent, rather than falling back to another
> >       implementation
> >     - Use sd_device_new_from_devnum() rather than the sd_device_new_from_devname()
> >       used by the systemd.io example, since the former has been available in
> >       libsystemd for much longer, keeping the version floor as low as possible
> >     - Keep lock_whole_disk()'s signature unconditional and provide a stub returning
> >       -1 on the #else branch, so main()'s primary code path has no #ifdefs in it
> >     
> > Changes in v2:
> >     - Guard the whole feature (function, call site, lock_fd, cleanup) rather than
> >       just the function body, so it is fully absent from non-Linux builds 
> >     - Collapse the three HAVE_SYS_*_H header guards into a single conditional
> >     - Reuse a single dev_path[] buffer instead of three single-use stack buffers
> >     - Keep translatable warning strings on one line each, even past 80 columns
> >     - Drop the blanket "could not lock" warning that fired even when the target was
> >       not a block device at all (e.g. a regular file), which broke most of
> >       "make check"; lock_whole_disk() now only warns at the point of a genuine failure
> >     - No change needed for the Ctrl-C/EINTR concern: the SIGINT handler is installed
> >       before lock_whole_disk() runs and is not SA_RESTART, so a blocked flock() is
> >       interrupted and the existing E2F_FLAG_CANCEL check unwinds cleanly
> > 
> >  MCONFIG.in         |  1 +
> >  configure          | 71 +++++++++++++++++++++++++++++++++++
> >  configure.ac       | 14 +++++++
> >  e2fsck/Makefile.in |  6 +--
> >  e2fsck/unix.c      | 93 ++++++++++++++++++++++++++++++++++++++++++++++
> >  lib/config.h.in    |  6 +++
> >  6 files changed, 188 insertions(+), 3 deletions(-)
> > 
> > diff --git a/MCONFIG.in b/MCONFIG.in
> > index d66e2f3b..d3055955 100644
> > --- a/MCONFIG.in
> > +++ b/MCONFIG.in
> > @@ -137,6 +137,7 @@ LIBE2P = $(LIB)/libe2p@LIB_EXT@
> >  LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
> >  LIBUUID = @LIBUUID@ @SOCKET_LIB@
> >  LIBMAGIC = @MAGIC_LIB@
> > +LIBSYSTEMD = @SYSTEMD_LIB@
> >  LIBFUSE = @FUSE_LIB@
> >  LIBSUPPORT = $(LIBINTL) $(LIB)/libsupport@STATIC_LIB_EXT@
> >  LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
> > diff --git a/configure b/configure
> > index b04b31af..696dd07c 100755
> > --- a/configure
> > +++ b/configure
> > @@ -702,6 +702,7 @@ fuse3_CFLAGS
> >  CLOCK_GETTIME_LIB
> >  ARCHIVE_LIBS
> >  ARCHIVE_CFLAGS
> > +SYSTEMD_LIB
> >  MAGIC_LIB
> >  SOCKET_LIB
> >  SIZEOF_TIME_T
> > @@ -14130,6 +14131,76 @@ if test "$ac_cv_func_dlopen" = yes ; then
> >     MAGIC_LIB=$DLOPEN_LIB
> >  fi
> >  
> > +SYSTEMD_LIB=
> > +{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for sd_device_get_parent_with_subsystem_devtype in -lsystemd" >&5
> > +printf %s "checking for sd_device_get_parent_with_subsystem_devtype in -lsystemd... " >&6; }
> > +if test ${ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype+y}
> > +then :
> > +  printf %s "(cached) " >&6
> > +else case e in #(
> > +  e) ac_check_lib_save_LIBS=$LIBS
> > +LIBS="-lsystemd  $LIBS"
> > +cat confdefs.h - <<_ACEOF >conftest.$ac_ext
> > +/* end confdefs.h.  */
> > +
> > +/* Override any GCC internal prototype to avoid an error.
> > +   Use char because int might match the return type of a GCC
> > +   builtin and then its argument prototype would still apply.
> > +   The 'extern "C"' is for builds by C++ compilers;
> > +   although this is not generally supported in C code supporting it here
> > +   has little cost and some practical benefit (sr 110532).  */
> > +#ifdef __cplusplus
> > +extern "C"
> > +#endif
> > +char sd_device_get_parent_with_subsystem_devtype (void);
> > +int
> > +main (void)
> > +{
> > +return sd_device_get_parent_with_subsystem_devtype ();
> > +  ;
> > +  return 0;
> > +}
> > +_ACEOF
> > +if ac_fn_c_try_link "$LINENO"
> > +then :
> > +  ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype=yes
> > +else case e in #(
> > +  e) ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype=no ;;
> > +esac
> > +fi
> > +rm -f core conftest.err conftest.$ac_objext conftest.beam \
> > +    conftest$ac_exeext conftest.$ac_ext
> > +LIBS=$ac_check_lib_save_LIBS ;;
> > +esac
> > +fi
> > +{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype" >&5
> > +printf "%s\n" "$ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype" >&6; }
> > +if test "x$ac_cv_lib_systemd_sd_device_get_parent_with_subsystem_devtype" = xyes
> > +then :
> > +  SYSTEMD_LIB=-lsystemd
> > +fi
> > +
> > +if test -n "$SYSTEMD_LIB"; then
> > +	       for ac_header in systemd/sd-device.h
> > +do :
> > +  ac_fn_c_check_header_compile "$LINENO" "systemd/sd-device.h" "ac_cv_header_systemd_sd_device_h" "$ac_includes_default"
> > +if test "x$ac_cv_header_systemd_sd_device_h" = xyes
> > +then :
> > +  printf "%s\n" "#define HAVE_SYSTEMD_SD_DEVICE_H 1" >>confdefs.h
> > +
> > +else case e in #(
> > +  e) SYSTEMD_LIB= ;;
> > +esac
> > +fi
> > +
> > +done
> > +fi
> > +if test -n "$SYSTEMD_LIB"; then
> > +
> > +printf "%s\n" "#define HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE 1" >>confdefs.h
> > +
> > +fi
> > +
> >  
> >  # Check whether --with-libarchive was given.
> >  if test ${with_libarchive+y}
> > diff --git a/configure.ac b/configure.ac
> > index 4921f81f..9f585aae 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -1309,6 +1309,20 @@ if test "$ac_cv_func_dlopen" = yes ; then
> >  fi
> >  AC_SUBST(MAGIC_LIB)
> >  dnl
> > +dnl See if libsystemd has sd-device APIs for whole-disk BSD locking
> > +dnl
> > +SYSTEMD_LIB=
> > +AC_CHECK_LIB(systemd, sd_device_get_parent_with_subsystem_devtype,
> > +	[SYSTEMD_LIB=-lsystemd])
> > +if test -n "$SYSTEMD_LIB"; then
> > +	AC_CHECK_HEADERS([systemd/sd-device.h], , [SYSTEMD_LIB=])
> > +fi
> > +if test -n "$SYSTEMD_LIB"; then
> > +	AC_DEFINE(HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE, 1,
> > +		[Define to 1 if libsystemd has sd-device APIs for whole-disk locking])
> > +fi
> > +AC_SUBST(SYSTEMD_LIB)
> > +dnl
> >  dnl libarchive
> >  dnl
> >  AC_ARG_WITH([libarchive],
> > diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
> > index fbb7b156..a050eafe 100644
> > --- a/e2fsck/Makefile.in
> > +++ b/e2fsck/Makefile.in
> > @@ -17,20 +17,20 @@ MANPAGES=	e2fsck.8
> >  FMANPAGES=	e2fsck.conf.5
> >  
> >  LIBS= $(LIBSUPPORT) $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBBLKID) $(LIBUUID) \
> > -	$(LIBINTL) $(LIBE2P) $(LIBMAGIC) $(SYSLIBS)
> > +	$(LIBINTL) $(LIBE2P) $(LIBMAGIC) $(LIBSYSTEMD) $(SYSLIBS)
> >  DEPLIBS= $(DEPLIBSUPPORT) $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBBLKID) \
> >  	 $(DEPLIBUUID) $(DEPLIBE2P)
> >  
> >  STATIC_LIBS= $(STATIC_LIBSUPPORT) $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) \
> >  	     $(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL) $(STATIC_LIBE2P) \
> > -	     $(LIBMAGIC) $(SYSLIBS)
> > +	     $(LIBMAGIC) $(LIBSYSTEMD) $(SYSLIBS)
> >  STATIC_DEPLIBS= $(DEPSTATIC_LIBSUPPORT) $(STATIC_LIBEXT2FS) \
> >  		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBBLKID) \
> >  		$(DEPSTATIC_LIBUUID) $(DEPSTATIC_LIBE2P)
> >  
> >  PROFILED_LIBS= $(PROFILED_LIBSUPPORT) $(PROFILED_LIBEXT2FS) \
> >  	       $(PROFILED_LIBCOM_ERR) $(PROFILED_LIBBLKID) $(PROFILED_LIBUUID) \
> > -	       $(PROFILED_LIBE2P) $(LIBINTL) $(LIBMAGIC) $(SYSLIBS)
> > +	       $(PROFILED_LIBE2P) $(LIBINTL) $(LIBMAGIC) $(LIBSYSTEMD) $(SYSLIBS)
> >  PROFILED_DEPLIBS= $(DEPPROFILED_LIBSUPPORT) $(PROFILED_LIBEXT2FS) \
> >  		  $(DEPPROFILED_LIBCOM_ERR) $(DEPPROFILED_LIBBLKID) \
> >  		  $(DEPPROFILED_LIBUUID) $(DEPPROFILED_LIBE2P)
> > diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> > index 335ca377..51bc41eb 100644
> > --- a/e2fsck/unix.c
> > +++ b/e2fsck/unix.c
> > @@ -36,6 +36,11 @@ extern int optind;
> >  #ifdef HAVE_SYS_IOCTL_H
> >  #include <sys/ioctl.h>
> >  #endif
> > +#ifdef HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE
> > +#include <sys/file.h>
> > +#include <sys/stat.h>
> > +#include <systemd/sd-device.h>
> > +#endif
> >  #ifdef HAVE_MALLOC_H
> >  #include <malloc.h>
> >  #endif
> > @@ -1397,6 +1402,88 @@ err:
> >  	return retval;
> >  }
> >  
> > +static int lock_whole_disk(e2fsck_t ctx, const char *dev_name)
> > +{
> > +#ifdef HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE
> > +	struct stat st;
> > +	sd_device *dev = NULL, *whole_dev;
> > +	const char *subsystem, *devtype, *whole_disk_devname;
> > +	int r, fd;
> > +
> > +	if (stat(dev_name, &st) < 0)
> > +		return -1;
> > +
> > +	if (!S_ISBLK(st.st_mode))
> > +		return -1;
> > +
> > +	r = sd_device_new_from_devnum(&dev, 'b', st.st_rdev);
> > +	if (r < 0)
> > +		return -1;
> > +
> > +	r = sd_device_get_subsystem(dev, &subsystem);
> > +	if (r < 0 || strcmp(subsystem, "block") != 0) {
> > +		sd_device_unref(dev);
> > +		return -1;
> > +	}
> > +
> > +	r = sd_device_get_devtype(dev, &devtype);
> > +	if (r < 0) {
> > +		sd_device_unref(dev);
> > +		return -1;
> > +	}
> > +
> > +	/*
> > +	 * If dev_name is a partition, resolve the parent whole-disk device
> > +	 * so the flock covers the same device node that udevd locks before
> > +	 * probing any partition on it.
> > +	 */
> > +	if (strcmp(devtype, "disk") == 0)
> > +		whole_dev = dev;
> > +	else {
> > +		r = sd_device_get_parent_with_subsystem_devtype(dev, "block",
> > +								 "disk", &whole_dev);
> > +		if (r < 0) {
> > +			log_err(ctx, _("Warning: could not resolve whole-disk device for %s; lock may not prevent udev races\n"), dev_name);
> > +			sd_device_unref(dev);
> > +			return -1;
> > +		}
> > +	}
> > +
> > +	r = sd_device_get_devname(whole_dev, &whole_disk_devname);
> > +	if (r < 0) {
> > +		sd_device_unref(dev);
> > +		return -1;
> > +	}
> > +
> > +	fd = open(whole_disk_devname, O_RDONLY | O_CLOEXEC, 0);
> > +	if (fd < 0) {
> > +		com_err(ctx->program_name, errno,
> > +			_("while trying to open %s for locking"), whole_disk_devname);
> > +		sd_device_unref(dev);
> > +		return -1;
> > +	}
> > +	sd_device_unref(dev);
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
> > +			_("while trying to lock %s"), whole_disk_devname);
> > +		close(fd);
> > +		return -1;
> > +	}
> > +
> > +	return fd;
> > +#else
> > +	return -1;
> > +#endif /* HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE */
> > +}
> > +
> >  int main (int argc, char *argv[])
> >  {
> >  	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
> > @@ -1413,6 +1500,7 @@ int main (int argc, char *argv[])
> >  	int journal_size;
> >  	int sysval, sys_page_size = 4096;
> >  	int old_bitmaps;
> > +	int lock_fd = -1;
> >  	__u32 features[3];
> >  	char *cp;
> >  	enum quota_type qtype;
> > @@ -1488,6 +1576,8 @@ int main (int argc, char *argv[])
> >  
> >  	check_mount(ctx);
> >  
> > +	lock_fd = lock_whole_disk(ctx, ctx->filesystem_name);
> > +
> >  	if (!(ctx->options & E2F_OPT_PREEN) &&
> >  	    !(ctx->options & E2F_OPT_NO) &&
> >  	    !(ctx->options & E2F_OPT_YES)) {
> > @@ -2169,6 +2259,9 @@ skip_write:
> >  	ext2fs_close_free(&ctx->fs);
> >  	free(ctx->journal_name);
> >  
> > +	if (lock_fd >= 0)
> > +		close(lock_fd);
> > +
> >  	if (ctx->logf)
> >  		fprintf(ctx->logf, "Exit status: %d\n", exit_value);
> >  	e2fsck_free_context(ctx);
> > diff --git a/lib/config.h.in b/lib/config.h.in
> > index f129abfe..bc3ae4aa 100644
> > --- a/lib/config.h.in
> > +++ b/lib/config.h.in
> > @@ -352,6 +352,9 @@
> >  /* Define to 1 if if struct sockaddr contains sa_len */
> >  #undef HAVE_SA_LEN
> >  
> > +/* Define to 1 if libsystemd has sd-device APIs for whole-disk locking */
> > +#undef HAVE_SD_DEVICE_GET_PARENT_WITH_SUBSYSTEM_DEVTYPE
> > +
> >  /* Define to 1 if you have the 'secure_getenv' function. */
> >  #undef HAVE_SECURE_GETENV
> >  
> > @@ -430,6 +433,9 @@
> >  /* Define to 1 if you have the 'sysconf' function. */
> >  #undef HAVE_SYSCONF
> >  
> > +/* Define to 1 if you have the <systemd/sd-device.h> header file. */
> > +#undef HAVE_SYSTEMD_SD_DEVICE_H
> > +
> >  /* Define to 1 if you have the <sys/acl.h> header file. */
> >  #undef HAVE_SYS_ACL_H
> >  
> > -- 
> > 2.55.0
> 
> Hi,
> 
> Gentle ping on this patch.
> 
> I would appreciate any feedback.
> 

Can you clarify why this should go into only fsck.ext4? Doesn't this
problem exist for other filesystems too?

I sent an earlier email as well with links to:

1) fsck used to lock the device, but it surfaced a bug in udevd
https://bugs.freedesktop.org/show_bug.cgi?id=79576

2) because of the bug, fsck stopped locking the device
https://github.com/util-linux/util-linux/commit/3bbdae633f4a1dda5f95ee6c61f18a1c8ef12250

3) the systemd-udevd bug was fixed
https://github.com/systemd/systemd/commit/5d354e525a5

To me, it makes more sense for the locking that already exists in fsck
to get updated (or reverted) to lock the entire device, using the
existing -l param (or maybe a new param like --lock-device,
--udevd-lock, etc., if util-linux maintainers don't want to change -l
behavior).

Do you see an issue with doing the locking there instead of here in
fsck.ext4?
