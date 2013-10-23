From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix build w/o quota
Date: Wed, 23 Oct 2013 10:51:48 -0200
Message-ID: <20131023125147.GA31449@orion.maiolino.org>
References: <52615CC0.7010007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab3JWMvx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 08:51:53 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9NCpqk8023207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 23 Oct 2013 08:51:52 -0400
Received: from orion.maiolino.org (ovpn-113-152.phx2.redhat.com [10.3.113.152])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r9NCpm3I031381
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 23 Oct 2013 08:51:51 -0400
Content-Disposition: inline
In-Reply-To: <52615CC0.7010007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey Eric,

I did a test here building the e2fsprogs -next tree without quota support and I
didn't have any problems configuring and compiling it. Can you share the test
you did and failed?

just as a matter of information, my 'next' branch should be up2date:

[cem@orion misc]$ git log --pretty=oneline -2
1586850bcd716e7e99825bd0a9a138f8618e2305 Merge branch 'maint' into next
43075b42bdff509cc567bd870a32072edf05d04c quota: fix disabling quota, add quota
tests


Cheers,

The latest commit on the tree is 
On Fri, Oct 18, 2013 at 11:07:28AM -0500, Eric Sandeen wrote:
> The next branch fails a few ways if quota isn't enabled;
> for starters, libquota build was turned off after commit
> 
> 43075b4 quota: fix disabling quota, add quota tests
> 
> because now we don't build libquota, but still depend on it.
> 
> Using @QUOTA_CMT@ to comment out those libs fixes things
> as far as deps, but then all calls to quota functions fail,
> of course.
> 
> So this is a very quick & dirty stab at providing stubs
> for those functions when quota is disabled.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Note - Compile-tested only, with & without quota.
> 
> diff --git a/MCONFIG.in b/MCONFIG.in
> index fa2b03e..e6be05c 100644
> --- a/MCONFIG.in
> +++ b/MCONFIG.in
> @@ -93,13 +93,13 @@ LIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@ @PRIVATE_LIBS_CMT@ @SEM_INIT_LIB@
>  LIBE2P = $(LIB)/libe2p@LIB_EXT@
>  LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
>  LIBUUID = @LIBUUID@ @SOCKET_LIB@
> -LIBQUOTA = @STATIC_LIBQUOTA@
> +@QUOTA_CMT@LIBQUOTA = @STATIC_LIBQUOTA@
>  LIBBLKID = @LIBBLKID@ @PRIVATE_LIBS_CMT@ $(LIBUUID)
>  LIBINTL = @LIBINTL@
>  DEPLIBSS = $(LIB)/libss@LIB_EXT@
>  DEPLIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@
>  DEPLIBUUID = @DEPLIBUUID@
> -DEPLIBQUOTA = @DEPSTATIC_LIBQUOTA@
> +@QUOTA_CMT@DEPLIBQUOTA = @DEPSTATIC_LIBQUOTA@
>  DEPLIBBLKID = @DEPLIBBLKID@ @PRIVATE_LIBS_CMT@ $(DEPLIBUUID)
>  
>  STATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@ @DLOPEN_LIB@
> @@ -107,12 +107,12 @@ STATIC_LIBCOM_ERR = $(LIB)/libcom_err@STATIC_LIB_EXT@ @SEM_INIT_LIB@
>  STATIC_LIBE2P = $(LIB)/libe2p@STATIC_LIB_EXT@
>  STATIC_LIBEXT2FS = $(LIB)/libext2fs@STATIC_LIB_EXT@
>  STATIC_LIBUUID = @STATIC_LIBUUID@ @SOCKET_LIB@
> -STATIC_LIBQUOTA = @STATIC_LIBQUOTA@
> +@QUOTA_CMT@STATIC_LIBQUOTA = @STATIC_LIBQUOTA@
>  STATIC_LIBBLKID = @STATIC_LIBBLKID@ $(STATIC_LIBUUID)
>  DEPSTATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@
>  DEPSTATIC_LIBCOM_ERR = $(LIB)/libcom_err@STATIC_LIB_EXT@
>  DEPSTATIC_LIBUUID = @DEPSTATIC_LIBUUID@
> -DEPSTATIC_LIBQUOTA = @DEPSTATIC_LIBQUOTA@
> +@QUOTA_CMT@DEPSTATIC_LIBQUOTA = @DEPSTATIC_LIBQUOTA@
>  DEPSTATIC_LIBBLKID = @DEPSTATIC_LIBBLKID@ $(DEPSTATIC_LIBUUID)
>  
>  PROFILED_LIBSS = $(LIB)/libss@PROFILED_LIB_EXT@ @DLOPEN_LIB@
> @@ -120,12 +120,12 @@ PROFILED_LIBCOM_ERR = $(LIB)/libcom_err@PROFILED_LIB_EXT@ @SEM_INIT_LIB@
>  PROFILED_LIBE2P = $(LIB)/libe2p@PROFILED_LIB_EXT@
>  PROFILED_LIBEXT2FS = $(LIB)/libext2fs@PROFILED_LIB_EXT@
>  PROFILED_LIBUUID = @PROFILED_LIBUUID@ @SOCKET_LIB@
> -PROFILED_LIBQUOTA = @PROFILED_LIBQUOTA@
> +@QUOTA_CMT@PROFILED_LIBQUOTA = @PROFILED_LIBQUOTA@
>  PROFILED_LIBBLKID = @PROFILED_LIBBLKID@ $(PROFILED_LIBUUID)
>  DEPPROFILED_LIBSS = $(LIB)/libss@PROFILED_LIB_EXT@
>  DEPPROFILED_LIBCOM_ERR = $(LIB)/libcom_err@PROFILED_LIB_EXT@
>  DEPPROFILED_LIBUUID = @PROFILED_LIBUUID@
> -DEPPROFILED_LIBQUOTA = @PROFILED_LIBQUOTA@
> +@QUOTA_CMT@DEPPROFILED_LIBQUOTA = @PROFILED_LIBQUOTA@
>  DEPPROFILED_LIBBLKID = @PROFILED_LIBBLKID@ $(DEPPROFILED_LIBUUID)
>  
>  #
> diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
> index ee15071..2d5d927 100644
> --- a/lib/quota/mkquota.h
> +++ b/lib/quota/mkquota.h
> @@ -43,6 +43,7 @@ struct quota_ctx {
>  };
>  
>  /* In mkquota.c */
> +#ifdef CONFIG_QUOTA
>  errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
>  void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
>  		int adjust);
> @@ -60,5 +61,81 @@ int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
>  void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
>  errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
>  				   int *usage_inconsistent);
> +#else
> +static inline
> +errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
> +{
> +	return 0;
> +}
>  
> +static inline
> +void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
> +		int adjust)
> +{
> +	return; 
> +}
> +
> +static inline
> +void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
> +		    qsize_t space)
> +{
> +	return;
> +}
> +
> +static inline
> +void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
> +		    qsize_t space)
> +{
> +	return;
> +}
> +
> +static inline
> +errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
> +{
> +	return 0;
> +}
> +
> +static inline
> +errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
> +{
> +	return 0;
> +}
> +
> +static inline
> +errcode_t quota_compute_usage(quota_ctx_t qctx)
> +{
> +	return 0;
> +}
> +
> +static inline
> +void quota_release_context(quota_ctx_t *qctx)
> +{
> +	return;
> +}
> +
> +static inline
> +errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
> +{
> +	return 0;
> +}
> +
> +static inline
> +int quota_file_exists(ext2_filsys fs, int qtype, int fmt)
> +{
> +	return 0;
> +}
> +
> +static inline
> +void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
> +{
> +	return;
> +}
> +
> +static inline
> +errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
> +				   int *usage_inconsistent)
> +{
> +	return 0;
> +}
> +#endif
>  #endif  /* __QUOTA_QUOTAIO_H__ */
> diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
> index 1c062f1..c2d7a41 100644
> --- a/lib/quota/quotaio.h
> +++ b/lib/quota/quotaio.h
> @@ -158,8 +158,24 @@ void update_grace_times(struct dquot *q);
>     than maxlen of extensions[] and fmtnames[] (plus 2) found in quotaio.c */
>  #define QUOTA_NAME_LEN 16
>  
> +#ifdef CONFIG_QUOTA
>  const char *quota_get_qf_name(int type, int fmt, char *buf);
>  const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
>  			      char *path_buf, size_t path_buf_size);
> +#else
> +static inline
> +const char *quota_get_qf_name(int type, int fmt, char *buf)
> +{
> +	return NULL;
> +}
> +
> +static inline
> +const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
> +			      char *path_buf, size_t path_buf_size)
> +{
> +	return NULL;
> +}
> +#endif
> +
>  
>  #endif /* GUARD_QUOTAIO_H */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
