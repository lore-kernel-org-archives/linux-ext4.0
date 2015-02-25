From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] debugfs/set_fields: fix several errors and add assertions
Date: Tue, 24 Feb 2015 20:24:41 -0800
Message-ID: <20150225042441.GB11031@birch.djwong.org>
References: <20150224124611.6795.44936.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27832 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbBYEYr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2015 23:24:47 -0500
Content-Disposition: inline
In-Reply-To: <20150224124611.6795.44936.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2015 at 03:46:11PM +0300, Konstantin Khlebnikov wrote:
> Fix copy-n-paste errors:
> * remove duplicate "lastcheck" and "min_extra_isize"
> * fix pointer for "first_error_line" and "last_error_line"
> * remove superblock field "inodes_count" from inode fields
> * add null-termination for mmp_fields
> 
> Add assertions for catching such errors in the future.
> Mark true aliases with flag "FLAG_ALIAS" and suppress assert for them.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> ---
>  debugfs/set_fields.c |   65 ++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 55 insertions(+), 10 deletions(-)
> 
> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
> index 60695ad..1af7d0f 100644
> --- a/debugfs/set_fields.c
> +++ b/debugfs/set_fields.c
> @@ -30,6 +30,7 @@
>  #ifdef HAVE_ERRNO_H
>  #include <errno.h>
>  #endif
> +#include <assert.h>
>  #if HAVE_STRINGS_H
>  #include <strings.h>
>  #endif
> @@ -50,6 +51,7 @@ static ext2_ino_t set_ino;
>  static int array_idx;
>  
>  #define FLAG_ARRAY	0x0001
> +#define FLAG_ALIAS	0x0002	/* Data intersects with other field */
>  
>  struct field_set_info {
>  	const char	*name;
> @@ -110,7 +112,6 @@ static struct field_set_info super_fields[] = {
>  	{ "uuid", &set_sb.s_uuid, NULL, 16, parse_uuid },
>  	{ "volume_name",  &set_sb.s_volume_name, NULL, 16, parse_string },
>  	{ "last_mounted",  &set_sb.s_last_mounted, NULL, 64, parse_string },
> -	{ "lastcheck",  &set_sb.s_lastcheck, NULL, 4, parse_uint },
>  	{ "algorithm_usage_bitmap", &set_sb.s_algorithm_usage_bitmap, NULL,
>  		  4, parse_uint },
>  	{ "prealloc_blocks", &set_sb.s_prealloc_blocks, NULL, 1, parse_uint },
> @@ -135,7 +136,6 @@ static struct field_set_info super_fields[] = {
>  	{ "want_extra_isize", &set_sb.s_want_extra_isize, NULL, 2, parse_uint },
>  	{ "flags", &set_sb.s_flags, NULL, 4, parse_uint },
>  	{ "raid_stride", &set_sb.s_raid_stride, NULL, 2, parse_uint },
> -	{ "min_extra_isize", &set_sb.s_min_extra_isize, NULL, 4, parse_uint },
>  	{ "mmp_interval", &set_sb.s_mmp_update_interval, NULL, 2, parse_uint },
>  	{ "mmp_block", &set_sb.s_mmp_block, NULL, 8, parse_uint },
>  	{ "raid_stripe_width", &set_sb.s_raid_stripe_width, NULL, 4, parse_uint },
> @@ -159,19 +159,18 @@ static struct field_set_info super_fields[] = {
>  	{ "first_error_ino", &set_sb.s_first_error_ino, NULL, 4, parse_uint },
>  	{ "first_error_block", &set_sb.s_first_error_block, NULL, 8, parse_uint },
>  	{ "first_error_func", &set_sb.s_first_error_func, NULL, 32, parse_string },
> -	{ "first_error_line", &set_sb.s_first_error_ino, NULL, 4, parse_uint },
> +	{ "first_error_line", &set_sb.s_first_error_line, NULL, 4, parse_uint },
>  	{ "last_error_time", &set_sb.s_last_error_time, NULL, 4, parse_time },
>  	{ "last_error_ino", &set_sb.s_last_error_ino, NULL, 4, parse_uint },
>  	{ "last_error_block", &set_sb.s_last_error_block, NULL, 8, parse_uint },
>  	{ "last_error_func", &set_sb.s_last_error_func, NULL, 32, parse_string },
> -	{ "last_error_line", &set_sb.s_last_error_ino, NULL, 4, parse_uint },
> +	{ "last_error_line", &set_sb.s_last_error_line, NULL, 4, parse_uint },
>  	{ "encrypt_algos", &set_sb.s_encrypt_algos, NULL, 1, parse_uint,
>  	  FLAG_ARRAY, 4 },
>  	{ 0, 0, 0, 0 }
>  };
>  
>  static struct field_set_info inode_fields[] = {
> -	{ "inodes_count", &set_sb.s_inodes_count, NULL, 4, parse_uint },
>  	{ "mode", &set_inode.i_mode, NULL, 2, parse_uint },
>  	{ "uid", &set_inode.i_uid, &set_inode.osd2.linux2.l_i_uid_high,
>  		2, parse_uint },
> @@ -189,7 +188,8 @@ static struct field_set_info inode_fields[] = {
>  	{ "flags", &set_inode.i_flags, NULL, 4, parse_uint },
>  	{ "version", &set_inode.osd1.linux1.l_i_version,
>  		&set_inode.i_version_hi, 4, parse_uint },
> -	{ "translator", &set_inode.osd1.hurd1.h_i_translator, NULL, 4, parse_uint },
> +	{ "translator", &set_inode.osd1.hurd1.h_i_translator, NULL,
> +		4, parse_uint, FLAG_ALIAS },
>  	{ "block", &set_inode.i_block[0], NULL, 4, parse_uint, FLAG_ARRAY,
>  	  EXT2_NDIR_BLOCKS },
>  	{ "block[IND]", &set_inode.i_block[EXT2_IND_BLOCK], NULL, 4, parse_uint },
> @@ -199,14 +199,14 @@ static struct field_set_info inode_fields[] = {
>  	/* Special case: i_file_acl_high is 2 bytes */
>  	{ "file_acl", &set_inode.i_file_acl, 
>  		&set_inode.osd2.linux2.l_i_file_acl_high, 6, parse_uint },
> -	{ "dir_acl", &set_inode.i_dir_acl, NULL, 4, parse_uint },
> +	{ "dir_acl", &set_inode.i_dir_acl, NULL, 4, parse_uint, FLAG_ALIAS },
>  	{ "faddr", &set_inode.i_faddr, NULL, 4, parse_uint },
> -	{ "frag", &set_inode.osd2.hurd2.h_i_frag, NULL, 1, parse_uint },
> +	{ "frag", &set_inode.osd2.hurd2.h_i_frag, NULL, 1, parse_uint, FLAG_ALIAS },
>  	{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, NULL, 1, parse_uint },
>  	{ "checksum", &set_inode.osd2.linux2.l_i_checksum_lo, 
>  		&set_inode.i_checksum_hi, 2, parse_uint },
>  	{ "author", &set_inode.osd2.hurd2.h_i_author, NULL,
> -		4, parse_uint },
> +		4, parse_uint, FLAG_ALIAS },
>  	{ "extra_isize", &set_inode.i_extra_isize, NULL,
>  		2, parse_uint },
>  	{ "ctime_extra", &set_inode.i_ctime_extra, NULL,
> @@ -262,7 +262,8 @@ static struct field_set_info ext4_bg_fields[] = {
>  };
>  
>  static struct field_set_info mmp_fields[] = {
> -	{ "clear", &set_mmp.mmp_magic, NULL, sizeof(set_mmp), parse_mmp_clear },
> +	{ "clear", &set_mmp.mmp_magic, NULL, sizeof(set_mmp),
> +		parse_mmp_clear, FLAG_ALIAS },
>  	{ "magic", &set_mmp.mmp_magic, NULL, 4, parse_uint },
>  	{ "seq", &set_mmp.mmp_seq, NULL, 4, parse_uint },
>  	{ "time", &set_mmp.mmp_time, NULL, 8, parse_uint },
> @@ -272,8 +273,52 @@ static struct field_set_info mmp_fields[] = {
>  		parse_string },
>  	{ "check_interval", &set_mmp.mmp_check_interval, NULL, 2, parse_uint },
>  	{ "checksum", &set_mmp.mmp_checksum, NULL, 4, parse_uint },
> +	{ 0, 0, 0, 0 }

Looks good so far.

>  };
>  
> +static void do_verify_field_set_info(struct field_set_info *fields,
> +		const void *data, size_t size)
> +{
> +	struct field_set_info *ss, *ss2;
> +	const char *begin = (char *)data;
> +	const char *end = begin + size;
> +
> +	for (ss = fields ; ss->name ; ss++) {
> +		const char *ptr;
> +
> +		/* Check pointers */
> +		ptr = ss->ptr;
> +		assert(!ptr || (ptr >= begin && ptr < end));
> +		ptr = ss->ptr2;
> +		assert(!ptr || (ptr >= begin && ptr < end));
> +
> +		/* Check function */
> +		assert(ss->func);
> +
> +		for (ss2 = fields ; ss2 != ss ; ss2++) {
> +			/* Check duplicate names */
> +			assert(strcmp(ss->name, ss2->name));
> +
> +			if (ss->flags & FLAG_ALIAS || ss2->flags & FLAG_ALIAS)
> +				continue;
> +			/* Check false aliases, might be copy-n-paste error */
> +			assert(!ss->ptr || (ss->ptr != ss2->ptr &&
> +					    ss->ptr != ss2->ptr2));
> +			assert(!ss->ptr2 || (ss->ptr2 != ss2->ptr &&
> +					     ss->ptr2 != ss2->ptr2));
> +		}
> +	}
> +}
> +
> +static __attribute__((constructor)) void verify_field_set_info(void)
> +{
> +	do_verify_field_set_info(super_fields, &set_sb, sizeof(set_sb));
> +	do_verify_field_set_info(inode_fields, &set_inode, sizeof(set_inode));
> +	do_verify_field_set_info(ext2_bg_fields, &set_gd, sizeof(set_gd));
> +	do_verify_field_set_info(ext4_bg_fields, &set_gd4, sizeof(set_gd4));
> +	do_verify_field_set_info(mmp_fields, &set_mmp, sizeof(set_mmp));
> +}

This ought to be run along with the 'make check' testcases, since they're
already looking for errors there.

Also, does running this on /every/ debugfs invocation slow down startup
noticeably?  Just idle curiosity. :)

--D

> +
>  static int check_suffix(const char *field)
>  {
>  	int len = strlen(field);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
