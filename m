Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F663126CA
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416331; cv=none; b=Vw5FAKb17CzGNBdU7vZEqtXKr5fS4Wz4C5QqBzNe+e9PiAucyO8IIv2HsNNCMbLnGYEmh7fI3r36CSfeRKIo14AKIqQkXt+gpOlI/Wbnm0IdcE7cUoNygNL3IbsVoGwiioxDR2yGZ1iq0pHQYtPsB5OKl6JeoJE5Y8hQFbrjmz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416331; c=relaxed/simple;
	bh=TGyzchCVbQzLtb4vpxDD2GtypC4Nsl5agJc1c/6I9RQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q1RvMIx1H3DkVfmFxXjFZciMI9064ocm0ulhV4AW+VDongknS6NX00qTSQLNxXTFOV6IGjjVcfvuedunnn0UXwd5Z3+Ed5vDseXB6ilSwyZig6SRx7pqcmYQmEzIsaUoEF9UZgofnbFzevh3ZrqqqGqt/00624aPacQFAPyfabw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3zBzbOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3zBzbOO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6BFAB1F000E9;
	Thu, 25 Jun 2026 19:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416329;
	bh=S6GjOj6nmFY2jC8eYqWKgCKoF/hcRcYYnRTO1BzANOw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=k3zBzbOOjpO2r55DMPgSatFetxATC+NabFhCOQvOPxG+KI7lSEhCb1m1E41/1McT7
	 wEFHxwMjTZ/rRY52mIsTQOd0f5C2OC143o3AtOr3uOiT9PhFgt4eseuFO14gVMwPwC
	 LmNi0G/fxRysYHxxLov5KhYvp799JlIRDSfIytfP6eAr+nWNCRVbvVADiHK9jza1fx
	 Pg/I9N4KZ/YHVrUUKt0l+/Kf305BQaT9l+/TkAFAGeUsMlDj9//B+cnW8k06zwcGUx
	 LyK6TnxWSnmpJDR9jfT/AVBWsBuzun/XE4Q96ICRkWBGWpM+YInT5mvD6jxPOTGI+m
	 gkRDbkI2E49ug==
Date: Thu, 25 Jun 2026 12:38:49 -0700
Subject: [PATCH 08/10] fuse4fs: set proc title when in fuse service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606956.1810414.3869961086945742727.stgit@frogsfrogsfrogs>
In-Reply-To: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
References: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When in fuse service mode, set the process title so that we can identify
fuse servers by mount arguments.  When the service ends, amend the title
again to say that we're cleaning up.  This is done to make ps aux a bit
more communicative as to what is going on.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure           |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac        |   13 ++++++
 fuse4fs/Makefile.in |    2 -
 fuse4fs/fuse4fs.c   |   47 ++++++++++++++++++++++
 lib/config.h.in     |    6 +++
 5 files changed, 176 insertions(+), 1 deletion(-)


diff --git a/configure b/configure
index 87960ad2cae3c3..b0531eb58b2b64 100755
--- a/configure
+++ b/configure
@@ -696,6 +696,7 @@ gcc_ranlib
 gcc_ar
 UNI_DIFF_OPTS
 SEM_INIT_LIB
+LIBBSD_LIB
 FUSE4FS_CMT
 FUSE2FS_CMT
 fuse_service_socket_perms
@@ -15022,6 +15023,114 @@ printf "%s\n" "#define HAVE_FUSE_CACHE_READDIR 1" >>confdefs.h
 
 fi
 
+{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for setproctitle in -lbsd" >&5
+printf %s "checking for setproctitle in -lbsd... " >&6; }
+if test ${ac_cv_lib_bsd_setproctitle+y}
+then :
+  printf %s "(cached) " >&6
+else case e in #(
+  e) ac_check_lib_save_LIBS=$LIBS
+LIBS="-lbsd  $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.
+   The 'extern "C"' is for builds by C++ compilers;
+   although this is not generally supported in C code supporting it here
+   has little cost and some practical benefit (sr 110532).  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char setproctitle (void);
+int
+main (void)
+{
+return setproctitle ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"
+then :
+  ac_cv_lib_bsd_setproctitle=yes
+else case e in #(
+  e) ac_cv_lib_bsd_setproctitle=no ;;
+esac
+fi
+rm -f core conftest.err conftest.$ac_objext conftest.beam \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS ;;
+esac
+fi
+{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_bsd_setproctitle" >&5
+printf "%s\n" "$ac_cv_lib_bsd_setproctitle" >&6; }
+if test "x$ac_cv_lib_bsd_setproctitle" = xyes
+then :
+  LIBBSD_LIB=-lbsd
+fi
+
+{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for setproctitle_init in -lbsd" >&5
+printf %s "checking for setproctitle_init in -lbsd... " >&6; }
+if test ${ac_cv_lib_bsd_setproctitle_init+y}
+then :
+  printf %s "(cached) " >&6
+else case e in #(
+  e) ac_check_lib_save_LIBS=$LIBS
+LIBS="-lbsd  $LIBS"
+cat confdefs.h - <<_ACEOF >conftest.$ac_ext
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.
+   The 'extern "C"' is for builds by C++ compilers;
+   although this is not generally supported in C code supporting it here
+   has little cost and some practical benefit (sr 110532).  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char setproctitle_init (void);
+int
+main (void)
+{
+return setproctitle_init ();
+  ;
+  return 0;
+}
+_ACEOF
+if ac_fn_c_try_link "$LINENO"
+then :
+  ac_cv_lib_bsd_setproctitle_init=yes
+else case e in #(
+  e) ac_cv_lib_bsd_setproctitle_init=no ;;
+esac
+fi
+rm -f core conftest.err conftest.$ac_objext conftest.beam \
+    conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS ;;
+esac
+fi
+{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_bsd_setproctitle_init" >&5
+printf "%s\n" "$ac_cv_lib_bsd_setproctitle_init" >&6; }
+if test "x$ac_cv_lib_bsd_setproctitle_init" = xyes
+then :
+  LIBBSD_LIB=-lbsd
+fi
+
+
+if test "$ac_cv_lib_bsd_setproctitle" = yes ; then
+
+printf "%s\n" "#define HAVE_SETPROCTITLE 1" >>confdefs.h
+
+fi
+if test "$ac_cv_lib_bsd_setproctitle_init" = yes ; then
+
+printf "%s\n" "#define HAVE_SETPROCTITLE_INIT 1" >>confdefs.h
+
+fi
+
 { printf "%s\n" "$as_me:${as_lineno-$LINENO}: checking for PR_SET_IO_FLUSHER" >&5
 printf %s "checking for PR_SET_IO_FLUSHER... " >&6; }
 cat confdefs.h - <<_ACEOF >conftest.$ac_ext
diff --git a/configure.ac b/configure.ac
index 381bb15d920a0f..8a5e95cd4eb866 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1622,6 +1622,19 @@ then
 		  [Define to 1 if fuse supports cache_readdir])
 fi
 
+dnl
+dnl see if setproctitle exists
+dnl
+AC_CHECK_LIB(bsd, setproctitle, [LIBBSD_LIB=-lbsd])
+AC_CHECK_LIB(bsd, setproctitle_init, [LIBBSD_LIB=-lbsd])
+AC_SUBST(LIBBSD_LIB)
+if test "$ac_cv_lib_bsd_setproctitle" = yes ; then
+	AC_DEFINE(HAVE_SETPROCTITLE, 1, [Define to 1 if setproctitle present in libbsd])
+fi
+if test "$ac_cv_lib_bsd_setproctitle_init" = yes ; then
+	AC_DEFINE(HAVE_SETPROCTITLE_INIT, 1, [Define to 1 if setproctitle_init present in libbsd])
+fi
+
 dnl
 dnl see if PR_SET_IO_FLUSHER exists
 dnl
diff --git a/fuse4fs/Makefile.in b/fuse4fs/Makefile.in
index 67b8afd54493b0..bb859369914a36 100644
--- a/fuse4fs/Makefile.in
+++ b/fuse4fs/Makefile.in
@@ -76,7 +76,7 @@ fuse4fs: $(FUSE4FS_OBJS) $(DEPLIBS) $(DEPLIBBLKID) $(DEPLIBUUID) \
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o fuse4fs $(FUSE4FS_OBJS) $(LIBS) \
 		$(LIBFUSE) $(LIBBLKID) $(LIBUUID) $(LIBEXT2FS) $(LIBINTL) \
-		$(CLOCK_GETTIME_LIB) $(SYSLIBS) $(LIBS_E2P)
+		$(CLOCK_GETTIME_LIB) $(SYSLIBS) $(LIBS_E2P) @LIBBSD_LIB@
 
 %.socket: %.socket.in $(DEP_SUBSTITUTE)
 	$(E) "	SUBST $@"
diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 97e668fadc2398..5fa51569a1167f 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -45,6 +45,9 @@
 #ifdef HAVE_FUSE4FS_SERVICE
 # include <sys/mount.h>
 # include <fuse_service.h>
+# ifdef HAVE_SETPROCTITLE
+#  include <bsd/unistd.h>
+# endif
 #endif
 #ifdef __SET_FOB_FOR_FUSE
 # undef _FILE_OFFSET_BITS
@@ -295,6 +298,9 @@ struct fuse4fs {
 	struct cache inodes;
 #ifdef HAVE_FUSE4FS_SERVICE
 	struct fuse_service *service;
+# ifdef HAVE_SETPROCTITLE
+	char *svc_cmdline;
+# endif
 	int bdev_fd;
 #endif
 };
@@ -1291,6 +1297,35 @@ static errcode_t fuse4fs_check_support(struct fuse4fs *ff)
 	return 0;
 }
 
+#if defined(HAVE_FUSE4FS_SERVICE) && defined(HAVE_SETPROCTITLE)
+static void fuse4fs_service_set_proc_cmdline(struct fuse4fs *ff, int argc,
+					     char *argv[],
+					     struct fuse_args *args)
+{
+#ifdef HAVE_SETPROCTITLE_INIT
+	setproctitle_init(argc, argv, environ);
+#endif
+
+	ff->svc_cmdline = fuse_service_cmdline(argc, (const char * const *)argv, args);
+	if (!ff->svc_cmdline)
+		return;
+
+	setproctitle("-%s", ff->svc_cmdline);
+}
+
+static void fuse4fs_service_finish_proc_cmdline(struct fuse4fs *ff)
+{
+	if (!ff->svc_cmdline)
+		return;
+
+	setproctitle("-%s [cleaning up]", ff->svc_cmdline);
+	free(ff->svc_cmdline);
+}
+#else
+# define fuse4fs_service_set_proc_cmdline(...)		((void)0)
+# define fuse4fs_service_finish_proc_cmdline(...)	((void)0)
+#endif
+
 #ifdef HAVE_FUSE4FS_SERVICE
 static int fuse4fs_service_connect(struct fuse4fs *ff, struct fuse_args *args)
 {
@@ -1324,6 +1359,8 @@ static int fuse4fs_service_exit(struct fuse4fs *ff, int exitcode)
 	if (!fuse4fs_is_service(ff))
 		return exitcode;
 
+	fuse4fs_service_finish_proc_cmdline(ff);
+
 	fuse_service_send_goodbye(ff->service, exitcode);
 	fuse_service_release(ff->service);
 	close(ff->bdev_fd);
@@ -6395,6 +6432,16 @@ int main(int argc, char *argv[])
 		goto out_exit;
 	}
 
+	/*
+	 * For fuse services, make the /proc title include the arguments that
+	 * we got from the mount helper.  Do this before parsing argc/argv
+	 * because that may overwrite the argv area.  Note that the procfs
+	 * listing might not reflect the options that actually get enabled,
+	 * just like regular fuse4fs.
+	 */
+	if (fuse4fs_is_service(&fctx))
+		fuse4fs_service_set_proc_cmdline(&fctx, argc, argv, &args);
+
 	ret = fuse_opt_parse(&args, &fctx, fuse4fs_opts, fuse4fs_opt_proc);
 	if (ret)
 		goto out_exit;
diff --git a/lib/config.h.in b/lib/config.h.in
index 15b99c6d28c59e..0973413b5c11e2 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -379,6 +379,12 @@
 /* Define to 1 if you have the 'setmntent' function. */
 #undef HAVE_SETMNTENT
 
+/* Define to 1 if setproctitle present in libbsd */
+#undef HAVE_SETPROCTITLE
+
+/* Define to 1 if setproctitle_init present in libbsd */
+#undef HAVE_SETPROCTITLE_INIT
+
 /* Define to 1 if you have the 'setresgid' function. */
 #undef HAVE_SETRESGID
 

