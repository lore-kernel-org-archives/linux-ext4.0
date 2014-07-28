From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 24/37] e2fsck: read-ahead metadata during passes 1, 2,
 and 4
Date: Mon, 28 Jul 2014 15:25:56 -0700
Message-ID: <20140728222556.GR8628@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231458.31890.5698.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40688 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaG1W0G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 18:26:06 -0400
Content-Disposition: inline
In-Reply-To: <20140501231458.31890.5698.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2014 at 04:14:59PM -0700, Darrick J. Wong wrote:
> e2fsck pass1 is modified to use the block group data prefetch function
> to try to fetch the inode tables into the pagecache before it is
> needed.  In order to avoid cache thrashing, we limit ourselves to
> prefetching at most half the available memory.
> 
> pass2 is modified to use the dirblock prefetching function to prefetch
> the list of directory blocks that are assembled in pass1.  So long as
> we don't anticipate rehashing the dirs (pass 3a), we can release the
> dirblocks as soon as we're done checking them.
> 
> pass4 is modified to prefetch the block and inode bitmaps in
> anticipation of pass 5, because pass4 is entirely CPU bound.
> 
> In general, these mechanisms can halve fsck time, if the host system
> has sufficient memory and the storage system can provide a lot of
> IOPs.  SSDs and multi-spindle RAIDs see the most speedup; single disks
> experience a modest speedup, and single-spindle USB mass storage
> devices see hardly any benefit.
> 
> By default, readahead will try to fill half the physical memory in the
> system.  The -E readahead_mem_kb= option can be given to specify the
> amount of memory to use for readahead, or zero to disable it entirely;
> or an option can be given in e2fsck.conf.

Ted wondered how much speed we gain from using pthreads to spawn the readahead
calls, instead of leaving the main thread in charge of scheduling its own
readahead.  From what I can tell, the extra thread reduces run time by about 2%
(as compared to the no-readahead-at-all run times) on a spinning RAID1 I have.
For SSDs I couldn't see much of a difference, so I guess I can drop the pthread
part.

>From what I can tell, a ^flexbg FS with a lot of directory blocks stands to
gain the most from pthreads.  However, I don't think it'll make much difference
either way.

--D
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  MCONFIG.in              |    1 
>  configure               |   49 +++++++++++++++++
>  configure.in            |    6 ++
>  e2fsck/Makefile.in      |    4 +
>  e2fsck/e2fsck.8.in      |    5 ++
>  e2fsck/e2fsck.c         |  136 +++++++++++++++++++++++++++++++++++++++++++++++
>  e2fsck/e2fsck.conf.5.in |   13 ++++
>  e2fsck/e2fsck.h         |   25 +++++++++
>  e2fsck/pass1.c          |  106 ++++++++++++++++++++++++++++++++++++-
>  e2fsck/pass2.c          |   95 ++++++++++++++++++++++++++++++++-
>  e2fsck/pass4.c          |   22 ++++++++
>  e2fsck/prof_err.et      |    1 
>  e2fsck/rehash.c         |   10 +++
>  e2fsck/unix.c           |   35 ++++++++++++
>  e2fsck/util.c           |   51 ++++++++++++++++++
>  lib/config.h.in         |    9 +++
>  16 files changed, 563 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/MCONFIG.in b/MCONFIG.in
> index 7e520be..352c133 100644
> --- a/MCONFIG.in
> +++ b/MCONFIG.in
> @@ -116,6 +116,7 @@ LIBUUID = @LIBUUID@ @SOCKET_LIB@
>  LIBQUOTA = @STATIC_LIBQUOTA@
>  LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
>  LIBINTL = @LIBINTL@
> +LIBPTHREADS = @PTHREADS_LIB@
>  SYSLIBS = @LIBS@
>  DEPLIBSS = $(LIB)/libss@LIB_EXT@
>  DEPLIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@
> diff --git a/configure b/configure
> index 7b0a0d1..5b89229 100755
> --- a/configure
> +++ b/configure
> @@ -639,6 +639,7 @@ CYGWIN_CMT
>  LINUX_CMT
>  UNI_DIFF_OPTS
>  SEM_INIT_LIB
> +PTHREADS_LIB
>  SOCKET_LIB
>  SIZEOF_OFF_T
>  SIZEOF_LONG_LONG
> @@ -10474,7 +10475,7 @@ fi
>  done
>  
>  fi
> -for ac_header in  	dirent.h 	errno.h 	execinfo.h 	getopt.h 	malloc.h 	mntent.h 	paths.h 	semaphore.h 	setjmp.h 	signal.h 	stdarg.h 	stdint.h 	stdlib.h 	termios.h 	termio.h 	unistd.h 	utime.h 	linux/falloc.h 	linux/fd.h 	linux/major.h 	linux/loop.h 	net/if_dl.h 	netinet/in.h 	sys/disklabel.h 	sys/file.h 	sys/ioctl.h 	sys/mkdev.h 	sys/mman.h 	sys/prctl.h 	sys/queue.h 	sys/resource.h 	sys/select.h 	sys/socket.h 	sys/sockio.h 	sys/stat.h 	sys/syscall.h 	sys/sysmacros.h 	sys/time.h 	sys/types.h 	sys/un.h 	sys/wait.h
> +for ac_header in  	dirent.h 	errno.h 	execinfo.h 	getopt.h 	malloc.h 	mntent.h 	paths.h 	semaphore.h 	setjmp.h 	signal.h 	stdarg.h 	stdint.h 	stdlib.h 	termios.h 	termio.h 	unistd.h 	utime.h 	linux/falloc.h 	linux/fd.h 	linux/major.h 	linux/loop.h 	net/if_dl.h 	netinet/in.h 	sys/disklabel.h 	sys/file.h 	sys/ioctl.h 	sys/mkdev.h 	sys/mman.h 	sys/prctl.h 	sys/queue.h 	sys/resource.h 	sys/select.h 	sys/socket.h 	sys/sockio.h 	sys/stat.h 	sys/syscall.h 	sys/sysctl.h 	sys/sysmacros.h 	sys/time.h 	sys/types.h 	sys/un.h 	sys/wait.h
>  do :
>    as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
>  ac_fn_c_check_header_mongrel "$LINENO" "$ac_header" "$as_ac_Header" "$ac_includes_default"
> @@ -11235,6 +11236,52 @@ if test $ac_cv_have_optreset = yes; then
>  $as_echo "#define HAVE_OPTRESET 1" >>confdefs.h
>  
>  fi
> +PTHREADS_LIB='-lpthread'
> +{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for pthread_create in -lpthread" >&5
> +$as_echo_n "checking for pthread_create in -lpthread... " >&6; }
> +if ${ac_cv_lib_pthread_pthread_create+:} false; then :
> +  $as_echo_n "(cached) " >&6
> +else
> +  ac_check_lib_save_LIBS=$LIBS
> +LIBS="-lpthread  $LIBS"
> +cat confdefs.h - <<_ACEOF >conftest.$ac_ext
> +/* end confdefs.h.  */
> +
> +/* Override any GCC internal prototype to avoid an error.
> +   Use char because int might match the return type of a GCC
> +   builtin and then its argument prototype would still apply.  */
> +#ifdef __cplusplus
> +extern "C"
> +#endif
> +char pthread_create ();
> +int
> +main ()
> +{
> +return pthread_create ();
> +  ;
> +  return 0;
> +}
> +_ACEOF
> +if ac_fn_c_try_link "$LINENO"; then :
> +  ac_cv_lib_pthread_pthread_create=yes
> +else
> +  ac_cv_lib_pthread_pthread_create=no
> +fi
> +rm -f core conftest.err conftest.$ac_objext \
> +    conftest$ac_exeext conftest.$ac_ext
> +LIBS=$ac_check_lib_save_LIBS
> +fi
> +{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_pthread_pthread_create" >&5
> +$as_echo "$ac_cv_lib_pthread_pthread_create" >&6; }
> +if test "x$ac_cv_lib_pthread_pthread_create" = xyes; then :
> +  cat >>confdefs.h <<_ACEOF
> +#define HAVE_LIBPTHREAD 1
> +_ACEOF
> +
> +  LIBS="-lpthread $LIBS"
> +
> +fi
> +
>  
>  SEM_INIT_LIB=''
>  ac_fn_c_check_func "$LINENO" "sem_init" "ac_cv_func_sem_init"
> diff --git a/configure.in b/configure.in
> index f28bd46..d2cfe41 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -961,6 +961,7 @@ AC_CHECK_HEADERS(m4_flatten([
>  	sys/sockio.h
>  	sys/stat.h
>  	sys/syscall.h
> +	sys/sysctl.h
>  	sys/sysmacros.h
>  	sys/time.h
>  	sys/types.h
> @@ -1173,6 +1174,11 @@ if test $ac_cv_have_optreset = yes; then
>    AC_DEFINE(HAVE_OPTRESET, 1, [Define to 1 if optreset for getopt is present])
>  fi
>  dnl
> +dnl Test for pthread_create in -lpthread
> +dnl
> +PTHREADS_LIB='-lpthread'
> +AC_CHECK_LIB(pthread, pthread_create, AC_SUBST(PTHREADS_LIB))
> +dnl
>  dnl Test for sem_init, and which library it might require:
>  dnl
>  AH_TEMPLATE([HAVE_SEM_INIT], [Define to 1 if sem_init() exists])
> diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
> index 2e08982..548df9c 100644
> --- a/e2fsck/Makefile.in
> +++ b/e2fsck/Makefile.in
> @@ -16,13 +16,13 @@ MANPAGES=	e2fsck.8
>  FMANPAGES=	e2fsck.conf.5
>  
>  LIBS= $(LIBQUOTA) $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBBLKID) $(LIBUUID) \
> -	$(LIBINTL) $(LIBE2P) $(SYSLIBS)
> +	$(LIBINTL) $(LIBE2P) $(SYSLIBS) $(LIBPTHREADS)
>  DEPLIBS= $(DEPLIBQUOTA) $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBBLKID) \
>  	 $(DEPLIBUUID) $(DEPLIBE2P)
>  
>  STATIC_LIBS= $(STATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) \
>  	     $(STATIC_LIBBLKID) $(STATIC_LIBUUID) $(LIBINTL) $(STATIC_LIBE2P) \
> -	     $(SYSLIBS)
> +	     $(SYSLIBS) $(LIBPTHEADS)
>  STATIC_DEPLIBS= $(DEPSTATIC_LIBQUOTA) $(STATIC_LIBEXT2FS) \
>  		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBBLKID) \
>  		$(DEPSTATIC_LIBUUID) $(DEPSTATIC_LIBE2P)
> diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
> index 43ee063..820281d 100644
> --- a/e2fsck/e2fsck.8.in
> +++ b/e2fsck/e2fsck.8.in
> @@ -208,6 +208,11 @@ option may prevent you from further manual data recovery.
>  Do not attempt to discard free blocks and unused inode blocks. This option is
>  exactly the opposite of discard option. This is set as default.
>  .TP
> +.BI readahead_mem_kb
> +Use at most this many KiB to pre-fetch metadata in the hopes of reducing
> +e2fsck runtime.  By default, this uses half the physical memory in the
> +system; setting this value to zero disables readahead entirely.
> +.TP
>  .BI strict_csums
>  Verify each metadata object's checksum before checking anything other fields
>  in the metadata object.  If the verification fails, offer to clear the item,
> diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
> index 0ec1540..c5d823c 100644
> --- a/e2fsck/e2fsck.c
> +++ b/e2fsck/e2fsck.c
> @@ -15,6 +15,10 @@
>  #include "e2fsck.h"
>  #include "problem.h"
>  
> +#ifdef HAVE_PTHREAD_H
> +#include <pthread.h>
> +#endif
> +
>  /*
>   * This function allocates an e2fsck context
>   */
> @@ -44,6 +48,8 @@ errcode_t e2fsck_allocate_context(e2fsck_t *ret)
>  			context->flags |= E2F_FLAG_TIME_INSANE;
>  	}
>  
> +	e2fsck_init_thread(&context->ra_thread);
> +
>  	*ret = context;
>  	return 0;
>  }
> @@ -209,6 +215,7 @@ int e2fsck_run(e2fsck_t ctx)
>  {
>  	int	i;
>  	pass_t	e2fsck_pass;
> +	errcode_t	err;
>  
>  #ifdef HAVE_SETJMP_H
>  	if (setjmp(ctx->abort_loc)) {
> @@ -226,6 +233,10 @@ int e2fsck_run(e2fsck_t ctx)
>  		e2fsck_pass(ctx);
>  		if (ctx->progress)
>  			(void) (ctx->progress)(ctx, 0, 0, 0);
> +		err = e2fsck_stop_thread(&ctx->ra_thread, NULL);
> +		if (err)
> +			com_err(ctx->program_name, err, "%s",
> +				_("while stopping readahead"));
>  	}
>  	ctx->flags &= ~E2F_FLAG_SETJMP_OK;
>  
> @@ -233,3 +244,128 @@ int e2fsck_run(e2fsck_t ctx)
>  		return (ctx->flags & E2F_FLAG_RUN_RETURN);
>  	return 0;
>  }
> +
> +#ifdef HAVE_PTHREAD_H
> +struct run_threaded {
> +	struct e2fsck_thread *thread;
> +	void * (*func)(void *);
> +	void (*cleanup)(void *);
> +	void *arg;
> +};
> +
> +static void run_threaded_cleanup(void *p)
> +{
> +	struct run_threaded *rt = p;
> +
> +	if (rt->cleanup)
> +		rt->cleanup(rt->arg);
> +	pthread_mutex_lock(&rt->thread->lock);
> +	rt->thread->running = 0;
> +	pthread_mutex_unlock(&rt->thread->lock);
> +	ext2fs_free_mem(&rt);
> +}
> +
> +static void *run_threaded_helper(void *p)
> +{
> +	int old;
> +	struct run_threaded *rt = p;
> +	void *ret;
> +
> +	pthread_cleanup_push(run_threaded_cleanup, rt);
> +	pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
> +	ret = rt->func(rt->arg);
> +	pthread_setcanceltype(old, NULL);
> +	pthread_cleanup_pop(1);
> +	pthread_exit(ret);
> +	return NULL;
> +}
> +#endif /* HAVE_PTHREAD_H */
> +
> +errcode_t e2fsck_init_thread(struct e2fsck_thread *thread)
> +{
> +	errcode_t err = 0;
> +
> +	thread->magic = E2FSCK_ET_MAGIC_RUN_THREAD;
> +#ifdef HAVE_PTHREAD_H
> +	err = pthread_mutex_init(&thread->lock, NULL);
> +#endif /* HAVE_PTHREAD_H */
> +
> +	return err;
> +}
> +
> +errcode_t e2fsck_run_thread(struct e2fsck_thread *thread,
> +			    void * (*func)(void *), void (*cleanup)(void *),
> +			    void *arg)
> +{
> +#ifdef HAVE_PTHREAD_H
> +	struct run_threaded *rt;
> +#endif
> +	errcode_t err = 0, err2;
> +
> +	EXT2_CHECK_MAGIC(thread, E2FSCK_ET_MAGIC_RUN_THREAD);
> +#ifdef HAVE_PTHREAD_H
> +	err = pthread_mutex_lock(&thread->lock);
> +	if (err)
> +		return err;
> +
> +	if (thread->running) {
> +		err = EAGAIN;
> +		goto out;
> +	}
> +
> +	err = pthread_join(thread->tid, NULL);
> +	if (err && err != ESRCH)
> +		goto out;
> +
> +	err = ext2fs_get_mem(sizeof(*rt), &rt);
> +	if (err)
> +		goto out;
> +
> +	rt->thread = thread;
> +	rt->func = func;
> +	rt->cleanup = cleanup;
> +	rt->arg = arg;
> +
> +	err = pthread_create(&thread->tid, NULL, run_threaded_helper, rt);
> +	if (err)
> +		ext2fs_free_mem(&rt);
> +	else
> +		thread->running = 1;
> +out:
> +	pthread_mutex_unlock(&thread->lock);
> +#else
> +	thread->ret = func(arg);
> +	if (cleanup)
> +		cleanup(arg);
> +#endif /* HAVE_PTHREAD_H */
> +
> +	return err;
> +}
> +
> +errcode_t e2fsck_stop_thread(struct e2fsck_thread *thread, void **ret)
> +{
> +	errcode_t err = 0, err2;
> +
> +	EXT2_CHECK_MAGIC(thread, E2FSCK_ET_MAGIC_RUN_THREAD);
> +
> +#ifdef HAVE_PTHREAD_H
> +	err = pthread_mutex_lock(&thread->lock);
> +	if (err)
> +		return err;
> +	if (thread->running)
> +		err = pthread_cancel(thread->tid);
> +	if (err == ESRCH)
> +		err = 0;
> +	err2 = pthread_mutex_unlock(&thread->lock);
> +	if (!err && err2)
> +		err = err2;
> +	if (!err)
> +		err = pthread_join(thread->tid, ret);
> +	if (err == ESRCH)
> +		err = 0;
> +#else
> +	if (ret)
> +		*ret = thread->ret;
> +#endif
> +	return err;
> +}
> diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
> index a8219a8..fcda392 100644
> --- a/e2fsck/e2fsck.conf.5.in
> +++ b/e2fsck/e2fsck.conf.5.in
> @@ -205,6 +205,19 @@ of that type are squelched.  This can be useful if the console is slow
>  (i.e., connected to a serial port) and so a large amount of output could
>  end up delaying the boot process for a long time (potentially hours).
>  .TP
> +.I readahead_mem_pct
> +Use no more than this percentage of memory to try to read in metadata blocks
> +ahead of the main e2fsck thread.  This should reduce run times, depending on
> +the speed of the underlying storage and the amount of free memory.  By default,
> +this is set to 50%.
> +.TP
> +.I readahead_mem_kb
> +Use no more than this amount of memory to read in metadata blocks ahead of the
> +main checking thread.  Setting this value to zero disables readahead entirely.
> +There is no default, but see
> +.B readahead_mem_pct
> +for more details.
> +.TP
>  .I report_features
>  If this boolean relation is true, e2fsck will print the file system
>  features as part of its verbose reporting (i.e., if the
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index c739329..59045bc 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -11,6 +11,7 @@
>  
>  #include <stdio.h>
>  #include <string.h>
> +#include <stdint.h>
>  #ifdef HAVE_UNISTD_H
>  #include <unistd.h>
>  #endif
> @@ -69,6 +70,24 @@
>  
>  #include "quota/mkquota.h"
>  
> +/* Functions to run something asynchronously */
> +struct e2fsck_thread {
> +	int magic;
> +#ifdef HAVE_PTHREAD_H
> +	int running;
> +	pthread_t tid;
> +	pthread_mutex_t lock;
> +#else
> +	void *ret;
> +#endif /* HAVE_PTHREAD_T */
> +};
> +
> +errcode_t e2fsck_init_thread(struct e2fsck_thread *thread);
> +errcode_t e2fsck_run_thread(struct e2fsck_thread *thread,
> +			    void * (*func)(void *), void (*cleanup)(void *),
> +			    void *arg);
> +errcode_t e2fsck_stop_thread(struct e2fsck_thread *thread, void **ret);
> +
>  /*
>   * Exit codes used by fsck-type programs
>   */
> @@ -373,6 +392,10 @@ struct e2fsck_struct {
>  	 * e2fsck functions themselves.
>  	 */
>  	void *priv_data;
> +
> +	/* How much are we allowed to readahead? */
> +	unsigned long long readahead_mem_kb;
> +	struct e2fsck_thread ra_thread;
>  };
>  
>  /* Used by the region allocation code */
> @@ -507,6 +530,7 @@ void e2fsck_rehash_dir_later(e2fsck_t ctx, ext2_ino_t ino);
>  int e2fsck_dir_will_be_rehashed(e2fsck_t ctx, ext2_ino_t ino);
>  errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino);
>  void e2fsck_rehash_directories(e2fsck_t ctx);
> +int e2fsck_will_rehash_dirs(e2fsck_t ctx);
>  
>  /* sigcatcher.c */
>  void sigcatcher_setup(void);
> @@ -585,6 +609,7 @@ extern errcode_t e2fsck_allocate_subcluster_bitmap(ext2_filsys fs,
>  						   int default_type,
>  						   const char *profile_name,
>  						   ext2fs_block_bitmap *ret);
> +int64_t get_memory_size(void);
>  
>  /* unix.c */
>  extern void e2fsck_clear_progbar(e2fsck_t ctx);
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index eb9497c..376ee23 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -589,6 +589,67 @@ static errcode_t recheck_bad_inode_checksum(ext2_filsys fs, ext2_ino_t ino,
>  	return 0;
>  }
>  
> +struct pass1ra_ctx {
> +	ext2_filsys fs;
> +	dgrp_t group;
> +	dgrp_t ngroups;
> +};
> +
> +static void pass1_readahead_cleanup(void *p)
> +{
> +	struct pass1ra_ctx *c = p;
> +
> +	ext2fs_free_mem(&p);
> +}
> +
> +static void *pass1_readahead(void *p)
> +{
> +	struct pass1ra_ctx *c = p;
> +	errcode_t err;
> +
> +	e2fsck_readahead(c->fs, E2FSCK_READA_ITABLE, c->group, c->ngroups);
> +	return NULL;
> +}
> +
> +static errcode_t initiate_readahead(e2fsck_t ctx, dgrp_t group, dgrp_t ngroups)
> +{
> +	struct pass1ra_ctx *ractx;
> +	errcode_t err;
> +
> +	err = ext2fs_get_mem(sizeof(*ractx), &ractx);
> +	if (err)
> +		return err;
> +
> +	ractx->fs = ctx->fs;
> +	ractx->group = group;
> +	ractx->ngroups = ngroups;
> +
> +	err = e2fsck_run_thread(&ctx->ra_thread, pass1_readahead,
> +				pass1_readahead_cleanup, ractx);
> +	if (err)
> +		ext2fs_free_mem(&ractx);
> +
> +	return err;
> +}
> +
> +static ext2_ino_t estimate_next_ra_inode(ext2_filsys fs, dgrp_t start,
> +					 dgrp_t end)
> +{
> +	ext2_ino_t inodes_per_group = fs->super->s_inodes_per_group;
> +	dgrp_t grp;
> +
> +	if (end >= fs->group_desc_count)
> +		end = fs->group_desc_count - 1;
> +
> +	for (grp = end; grp >= start; grp--) {
> +		if (ext2fs_bg_flags_test(fs, grp, EXT2_BG_INODE_UNINIT))
> +			continue;
> +		return grp * inodes_per_group;
> +	}
> +
> +	return end * inodes_per_group;
> +}
> +
>  void e2fsck_pass1(e2fsck_t ctx)
>  {
>  	int	i;
> @@ -611,10 +672,40 @@ void e2fsck_pass1(e2fsck_t ctx)
>  	int		busted_fs_time = 0;
>  	int		inode_size;
>  	int		failed_csum = 0;
> +	dgrp_t		grp = 0;
> +	ext2_ino_t	ra_threshold = 0, ino_threshold;
> +	dgrp_t		ra_groups = 0;
> +	ext2_ino_t	inodes_per_group = fs->super->s_inodes_per_group;
> +	errcode_t	err;
>  
>  	init_resource_track(&rtrack, ctx->fs->io);
>  	clear_problem_context(&pctx);
>  
> +	/* If we can do readahead, figure out how many groups to pull in. */
> +	if (!e2fsck_can_readahead(ctx->fs))
> +		ctx->readahead_mem_kb = 0;
> +	if (ctx->readahead_mem_kb) {
> +		ra_groups = ctx->readahead_mem_kb /
> +			    (fs->inode_blocks_per_group * fs->blocksize /
> +			     1024);
> +		if (ra_groups > fs->group_desc_count)
> +			ra_groups = fs->group_desc_count;
> +		if (ra_groups < 16)
> +			ra_groups = 0;
> +		if (ra_groups) {
> +			err = initiate_readahead(ctx, grp, ra_groups);
> +			if (err) {
> +				com_err(ctx->program_name, err, "%s",
> +					_("while starting pass1 readahead"));
> +				ra_groups = 0;
> +			}
> +			ra_threshold = ra_groups *
> +				       inodes_per_group;
> +			ino_threshold = estimate_next_ra_inode(fs, 0,
> +					ra_groups * 9 / 10);
> +		}
> +	}
> +
>  	if (!(ctx->options & E2F_OPT_PREEN))
>  		fix_problem(ctx, PR_1_PASS_HEADER, &pctx);
>  
> @@ -774,10 +865,23 @@ void e2fsck_pass1(e2fsck_t ctx)
>  	(void) e2fsck_get_lost_and_found(ctx, 0);
>  
>  	while (1) {
> -		if (ino % (fs->super->s_inodes_per_group * 4) == 1) {
> +
> +		if (ino % (inodes_per_group * 4) == 1) {
>  			if (e2fsck_mmp_update(fs))
>  				fatal_error(ctx, 0);
>  		}
> +		if (ra_groups > 0 && ino > ino_threshold) {
> +			grp = (ra_threshold - 1) / inodes_per_group;
> +			err = initiate_readahead(ctx, grp, ra_groups);
> +			if (err == EAGAIN)
> +				ra_groups /= 2;
> +			else if (err)
> +				com_err(ctx->program_name, err, "%s",
> +					_("while starting pass1 readahead"));
> +			ra_threshold += ra_groups * inodes_per_group;
> +			ino_threshold = estimate_next_ra_inode(fs, grp,
> +					grp + (ra_groups * 9 / 10));
> +		}
>  		old_op = ehandler_operation(_("getting next inode from scan"));
>  		pctx.errcode = ext2fs_get_next_inode_full(scan, &ino,
>  							  inode, inode_size);
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 95f51b7..1667292 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -61,6 +61,9 @@
>   * Keeps track of how many times an inode is referenced.
>   */
>  static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf);
> +static int check_dir_block2(ext2_filsys fs,
> +			   struct ext2_db_entry2 *dir_blocks_info,
> +			   void *priv_data);
>  static int check_dir_block(ext2_filsys fs,
>  			   struct ext2_db_entry2 *dir_blocks_info,
>  			   void *priv_data);
> @@ -77,8 +80,67 @@ struct check_dir_struct {
>  	struct problem_context	pctx;
>  	int	count, max;
>  	e2fsck_t ctx;
> +	int	save_readahead;
> +};
> +
> +struct pass2_readahead_data {
> +	ext2_filsys fs;
> +	ext2_dblist dblist;
>  };
>  
> +static int readahead_dir_block(ext2_filsys fs, struct ext2_db_entry2 *db,
> +			       void *priv_data)
> +{
> +	db->blockcnt = 1;
> +	return 0;
> +}
> +
> +static void pass2_readahead_cleanup(void *p)
> +{
> +	struct pass2_readahead_data *pr = p;
> +
> +	ext2fs_free_dblist(pr->dblist);
> +	ext2fs_free_mem(&pr);
> +}
> +
> +static void *pass2_readahead(void *p)
> +{
> +	struct pass2_readahead_data *pr = p;
> +
> +	e2fsck_readahead_dblist(pr->fs, 0, pr->dblist);
> +	return NULL;
> +}
> +
> +static errcode_t initiate_readahead(e2fsck_t ctx)
> +{
> +	struct pass2_readahead_data *pr;
> +	errcode_t err;
> +
> +	err = ext2fs_get_mem(sizeof(*pr), &pr);
> +	if (err)
> +		return err;
> +	pr->fs = ctx->fs;
> +	err = ext2fs_copy_dblist(ctx->fs->dblist, &pr->dblist);
> +	if (err)
> +		goto out_pr;
> +	err = ext2fs_dblist_iterate2(pr->dblist, readahead_dir_block,
> +				     NULL);
> +	if (err)
> +		goto out_dblist;
> +	err = e2fsck_run_thread(&ctx->ra_thread, pass2_readahead,
> +				pass2_readahead_cleanup, pr);
> +	if (err)
> +		goto out_dblist;
> +
> +	return 0;
> +
> +out_dblist:
> +	ext2fs_free_dblist(pr->dblist);
> +out_pr:
> +	ext2fs_free_mem(&pr);
> +	return err;
> +}
> +
>  void e2fsck_pass2(e2fsck_t ctx)
>  {
>  	struct ext2_super_block *sb = ctx->fs->super;
> @@ -96,6 +158,10 @@ void e2fsck_pass2(e2fsck_t ctx)
>  	int			i, depth;
>  	problem_t		code;
>  	int			bad_dir;
> +	int (*check_dir_func)(ext2_filsys fs,
> +			      struct ext2_db_entry2 *dir_blocks_info,
> +			      void *priv_data);
> +	errcode_t		err;
>  
>  	init_resource_track(&rtrack, ctx->fs->io);
>  	clear_problem_context(&cd.pctx);
> @@ -139,6 +205,7 @@ void e2fsck_pass2(e2fsck_t ctx)
>  	cd.ctx = ctx;
>  	cd.count = 1;
>  	cd.max = ext2fs_dblist_count2(fs->dblist);
> +	cd.save_readahead = e2fsck_will_rehash_dirs(ctx);
>  
>  	if (ctx->progress)
>  		(void) (ctx->progress)(ctx, 2, 0, cd.max);
> @@ -146,7 +213,16 @@ void e2fsck_pass2(e2fsck_t ctx)
>  	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX)
>  		ext2fs_dblist_sort2(fs->dblist, special_dir_block_cmp);
>  
> -	cd.pctx.errcode = ext2fs_dblist_iterate2(fs->dblist, check_dir_block,
> +	if (ctx->readahead_mem_kb) {
> +		check_dir_func = check_dir_block2;
> +		err = initiate_readahead(ctx);
> +		if (err)
> +			com_err(ctx->program_name, err, "%s",
> +				_("while starting pass2 readahead"));
> +	} else
> +		check_dir_func = check_dir_block;
> +
> +	cd.pctx.errcode = ext2fs_dblist_iterate2(fs->dblist, check_dir_func,
>  						 &cd);
>  	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
>  		return;
> @@ -655,6 +731,7 @@ clear_and_exit:
>  	clear_htree(cd->ctx, cd->pctx.ino);
>  	dx_dir->numblocks = 0;
>  	e2fsck_rehash_dir_later(cd->ctx, cd->pctx.ino);
> +	cd->save_readahead = 1;
>  }
>  #endif /* ENABLE_HTREE */
>  
> @@ -774,6 +851,19 @@ static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
>  	return 0;
>  }
>  
> +static int check_dir_block2(ext2_filsys fs,
> +			   struct ext2_db_entry2 *db,
> +			   void *priv_data)
> +{
> +	int err;
> +	struct check_dir_struct *cd = priv_data;
> +
> +	err = check_dir_block(fs, db, priv_data);
> +	if (!cd->save_readahead)
> +		io_channel_cache_release(fs->io, db->blk, 1);
> +	return err;
> +}
> +
>  static int check_dir_block(ext2_filsys fs,
>  			   struct ext2_db_entry2 *db,
>  			   void *priv_data)
> @@ -957,6 +1047,7 @@ out_htree:
>  					 &cd->pctx))
>  				goto skip_checksum;
>  			e2fsck_rehash_dir_later(ctx, ino);
> +			cd->save_readahead = 1;
>  			goto skip_checksum;
>  		}
>  		if (failed_csum) {
> @@ -1249,6 +1340,7 @@ skip_checksum:
>  			pctx.dirent = dirent;
>  			fix_problem(ctx, PR_2_REPORT_DUP_DIRENT, &pctx);
>  			e2fsck_rehash_dir_later(ctx, ino);
> +			cd->save_readahead = 1;
>  			dups_found++;
>  		} else
>  			dict_alloc_insert(&de_dict, dirent, dirent);
> @@ -1316,6 +1408,7 @@ skip_checksum:
>  			if (insert_dirent_tail(fs, buf) == 0)
>  				goto write_and_fix;
>  			e2fsck_rehash_dir_later(ctx, ino);
> +			cd->save_readahead = 1;
>  		}
>  
>  write_and_fix:
> diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
> index 21d93f0..6cebfa3 100644
> --- a/e2fsck/pass4.c
> +++ b/e2fsck/pass4.c
> @@ -87,6 +87,21 @@ static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i,
>  	return 0;
>  }
>  
> +/* Since pass4 is mostly CPU bound, start readahead of bitmaps for pass 5. */
> +static void *pass5_readahead(void *p)
> +{
> +	ext2_filsys fs = p;
> +
> +	e2fsck_readahead(fs, E2FSCK_READA_BBITMAP | E2FSCK_READA_IBITMAP, 0,
> +			 fs->group_desc_count);
> +	return NULL;
> +}
> +
> +static errcode_t initiate_readahead(e2fsck_t ctx)
> +{
> +	return e2fsck_run_thread(&ctx->ra_thread, pass5_readahead, NULL,
> +				 ctx->fs);
> +}
>  
>  void e2fsck_pass4(e2fsck_t ctx)
>  {
> @@ -100,12 +115,19 @@ void e2fsck_pass4(e2fsck_t ctx)
>  	__u16	link_count, link_counted;
>  	char	*buf = 0;
>  	dgrp_t	group, maxgroup;
> +	errcode_t	err;
>  
>  	init_resource_track(&rtrack, ctx->fs->io);
>  
>  #ifdef MTRACE
>  	mtrace_print("Pass 4");
>  #endif
> +	if (ctx->readahead_mem_kb) {
> +		err = initiate_readahead(ctx);
> +		if (err)
> +			com_err(ctx->program_name, err, "%s",
> +				_("while starting pass5 readahead"));
> +	}
>  
>  	clear_problem_context(&pctx);
>  
> diff --git a/e2fsck/prof_err.et b/e2fsck/prof_err.et
> index c9316c7..21fb524 100644
> --- a/e2fsck/prof_err.et
> +++ b/e2fsck/prof_err.et
> @@ -62,5 +62,6 @@ error_code	PROF_BAD_INTEGER,		"Invalid integer value"
>  
>  error_code	PROF_MAGIC_FILE_DATA, "Bad magic value in profile_file_data_t"
>  
> +error_code	E2FSCK_ET_MAGIC_RUN_THREAD,	"Wrong magic number for e2fsck_thread structure"
>  
>  end
> diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
> index 3b05715..89708c2 100644
> --- a/e2fsck/rehash.c
> +++ b/e2fsck/rehash.c
> @@ -71,6 +71,16 @@ int e2fsck_dir_will_be_rehashed(e2fsck_t ctx, ext2_ino_t ino)
>  	return ext2fs_u32_list_test(ctx->dirs_to_hash, ino);
>  }
>  
> +/* Ask if there will be a pass 3A. */
> +int e2fsck_will_rehash_dirs(e2fsck_t ctx)
> +{
> +	if (ctx->options & E2F_OPT_COMPRESS_DIRS)
> +		return 1;
> +	if (!ctx->dirs_to_hash)
> +		return 0;
> +	return ext2fs_u32_list_count(ctx->dirs_to_hash) > 0;
> +}
> +
>  struct fill_dir_struct {
>  	char *buf;
>  	struct ext2_inode *inode;
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index c6cdb49..da888c2 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -643,6 +643,7 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
>  	char	*buf, *token, *next, *p, *arg;
>  	int	ea_ver;
>  	int	extended_usage = 0;
> +	unsigned long long reada_kb;
>  
>  	buf = string_copy(ctx, opts, 0);
>  	for (token = buf; token && *token; token = next) {
> @@ -671,6 +672,15 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
>  				continue;
>  			}
>  			ctx->ext_attr_ver = ea_ver;
> +		} else if (strcmp(token, "readahead_mem_kb") == 0) {
> +			reada_kb = strtoull(arg, &p, 0);
> +			if (*p) {
> +				fprintf(stderr, "%s",
> +					_("Invalid readahead buffer size.\n"));
> +				extended_usage++;
> +				continue;
> +			}
> +			ctx->readahead_mem_kb = reada_kb;
>  		} else if (strcmp(token, "fragcheck") == 0) {
>  			ctx->options |= E2F_OPT_FRAGCHECK;
>  			continue;
> @@ -716,6 +726,7 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
>  		fputs(("\tnodiscard\n"), stderr);
>  		fputs(("\tstrict_csums\n"), stderr);
>  		fputs(("\tno_strict_csums\n"), stderr);
> +		fputs(("\treadahead_mem_kb=<buffer size>\n"), stderr);
>  		fputc('\n', stderr);
>  		exit(1);
>  	}
> @@ -749,6 +760,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
>  #ifdef CONFIG_JBD_DEBUG
>  	char 		*jbd_debug;
>  #endif
> +	unsigned long long phys_mem_kb;
>  
>  	retval = e2fsck_allocate_context(&ctx);
>  	if (retval)
> @@ -776,6 +788,8 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
>  	else
>  		ctx->program_name = "e2fsck";
>  
> +	phys_mem_kb = get_memory_size() / 1024;
> +	ctx->readahead_mem_kb = ~0ULL;
>  	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
>  		switch (c) {
>  		case 'C':
> @@ -965,6 +979,22 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
>  	if (c)
>  		verbose = 1;
>  
> +	/* Figure out how much memory goes to readahead */
> +	if (ctx->readahead_mem_kb == ~0ULL) {
> +		profile_get_integer(ctx->profile, "options",
> +				    "readahead_mem_pct", 0, 50, &c);
> +		if (c >= 0 && c <= 100)
> +			ctx->readahead_mem_kb = phys_mem_kb * c / 100;
> +		else
> +			ctx->readahead_mem_kb = phys_mem_kb / 2;
> +		profile_get_integer(ctx->profile, "options",
> +				    "readahead_mem_kb", 0, -1, &c);
> +		if (c >= 0)
> +			ctx->readahead_mem_kb = c;
> +	}
> +	if (ctx->readahead_mem_kb > phys_mem_kb)
> +		ctx->readahead_mem_kb = phys_mem_kb;
> +
>  	/* Turn off discard in read-only mode */
>  	if ((ctx->options & E2F_OPT_NO) &&
>  	    (ctx->options & E2F_OPT_DISCARD))
> @@ -1781,6 +1811,11 @@ no_journal:
>  		}
>  	}
>  
> +	retval = e2fsck_stop_thread(&ctx->ra_thread, NULL);
> +	if (retval)
> +		com_err(ctx->program_name, retval, "%s",
> +			_("while stopping readahead"));
> +
>  	e2fsck_write_bitmaps(ctx);
>  	io_channel_flush(ctx->fs->io);
>  	print_resource_track(ctx, NULL, &ctx->global_rtrack, ctx->fs->io);
> diff --git a/e2fsck/util.c b/e2fsck/util.c
> index fec6179..09b78c2 100644
> --- a/e2fsck/util.c
> +++ b/e2fsck/util.c
> @@ -37,6 +37,10 @@
>  #include <errno.h>
>  #endif
>  
> +#ifdef HAVE_SYS_SYSCTL_H
> +#include <sys/sysctl.h>
> +#endif
> +
>  #include "e2fsck.h"
>  
>  extern e2fsck_t e2fsck_global_ctx;   /* Try your very best not to use this! */
> @@ -845,3 +849,50 @@ errcode_t e2fsck_allocate_subcluster_bitmap(ext2_filsys fs, const char *descr,
>  	fs->default_bitmap_type = save_type;
>  	return retval;
>  }
> +
> +/* Return memory size in bytes */
> +int64_t get_memory_size(void)
> +{
> +#if defined(_SC_PHYS_PAGES)
> +# if defined(_SC_PAGESIZE)
> +	return (int64_t)sysconf(_SC_PHYS_PAGES) *
> +	       (int64_t)sysconf(_SC_PAGESIZE);
> +# elif defined(_SC_PAGE_SIZE)
> +	return (int64_t)sysconf(_SC_PHYS_PAGES) *
> +	       (int64_t)sysconf(_SC_PAGE_SIZE);
> +# endif
> +#elif defined(_SC_AIX_REALMEM)
> +	return (int64_t)sysconf(_SC_AIX_REALMEM) * (int64_t)1024L;
> +#elif defined(CTL_HW)
> +# if (defined(HW_MEMSIZE) || defined(HW_PHYSMEM64))
> +#  define CTL_HW_INT64
> +# elif (defined(HW_PHYSMEM) || defined(HW_REALMEM))
> +#  define CTL_HW_UINT
> +# endif
> +	int mib[2];
> +	mib[0] = CTL_HW;
> +# if defined(HW_MEMSIZE)
> +	mib[1] = HW_MEMSIZE;
> +# elif defined(HW_PHYSMEM64)
> +	mib[1] = HW_PHYSMEM64;
> +# elif defined(HW_REALMEM)
> +	mib[1] = HW_REALMEM;
> +# elif defined(HW_PYSMEM)
> +	mib[1] = HW_PHYSMEM;
> +# endif
> +# if defined(CTL_HW_INT64)
> +	int64_t size = 0;
> +# elif defined(CTL_HW_UINT)
> +	unsigned int size = 0;
> +# endif
> +# if defined(CTL_HW_INT64) || defined(CTL_HW_UINT)
> +	size_t len = sizeof(size);
> +	if (sysctl(mib, 2, &size, &len, NULL, 0) == 0)
> +		return (int64_t)size;
> +# endif
> +	return 0;
> +#else
> +# warning "Don't know how to detect memory on your platform?"
> +	return 0;
> +#endif
> +}
> diff --git a/lib/config.h.in b/lib/config.h.in
> index e0384ee..836c2df 100644
> --- a/lib/config.h.in
> +++ b/lib/config.h.in
> @@ -203,6 +203,9 @@
>  /* Define if your <locale.h> file defines LC_MESSAGES. */
>  #undef HAVE_LC_MESSAGES
>  
> +/* Define to 1 if you have the `pthread' library (-lpthread). */
> +#undef HAVE_LIBPTHREAD
> +
>  /* Define to 1 if you have the <limits.h> header file. */
>  #undef HAVE_LIMITS_H
>  
> @@ -314,6 +317,9 @@
>  /* Define to 1 if you have the `pread' function. */
>  #undef HAVE_PREAD
>  
> +/* Define to 1 if you have the <pthread.h> header file. */
> +#undef HAVE_PTHREAD_H
> +
>  /* Define to 1 if you have the `putenv' function. */
>  #undef HAVE_PUTENV
>  
> @@ -465,6 +471,9 @@
>  /* Define to 1 if you have the <sys/syscall.h> header file. */
>  #undef HAVE_SYS_SYSCALL_H
>  
> +/* Define to 1 if you have the <sys/sysctl.h> header file. */
> +#undef HAVE_SYS_SYSCTL_H
> +
>  /* Define to 1 if you have the <sys/sysmacros.h> header file. */
>  #undef HAVE_SYS_SYSMACROS_H
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
