From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 1/7] e2fsck: add support for dirdata feature
Date: Tue, 14 Nov 2017 12:48:15 -0800
Message-ID: <20171114204815.GA5105@magnolia>
References: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
 <20171114070440.79510-2-artem.blagodarenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        Andreas Dilger <andreas.dilger@intel.com>,
        Bobi Jam <bobijam.xu@intel.com>,
        Manisha Salve <msalve@ddn.com>,
        Pravin Shelar <pravin@clusterfs.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21407 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdKNUtB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Nov 2017 15:49:01 -0500
Content-Disposition: inline
In-Reply-To: <20171114070440.79510-2-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 14, 2017 at 10:04:34AM +0300, Artem Blagodarenko wrote:
> From: Andreas Dilger <andreas.dilger@intel.com>
> 
> Add support for the INCOMPAT_DIRDATA feature, which allows
> storing extra data in the directory entry beyond the name.
> This allows the Lustre File IDentifier to be accessed in
> an efficient manner, and would be useful for expanding a
> filesystem to allow more than 2^32 inodes in the future.
> 
> Include this patches:
> 
> e2fsck: e2fsck -D does not change dirdata content
> 
> Fix dir optimization to preserve dirdata content for dot
> and dotdot entries.
> 
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-1774
> Signed-off-by: Bobi Jam <bobijam.xu@intel.com>
> Change-Id: Iae190794da75a2080a8e5cc5b95a49e0c894f72f
> 
> e2fsprogs: Consider DIRENT_LUFID flag in link_proc().
> 
> While adding the new file entry in directory block, link_proc()
> calculates minimum record length of the existing directory entry
> without considering the dirent data size and which leads to
> corruption. Changed the code to use EXT2_DIR_REC_LEN() which will
> return correct record length including dirent data size.
> 
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-2462
> Signed-off-by: Manisha Salve <msalve@ddn.com>
> Change-Id: Ic593c558c47a78183143ec8e99d8385ac94d06f7
> 
> libext2fs, e2fsck: don't use ext2_dir_entry_2
> 
> Due to endian issues, do not use ext2_dir_entry_2 because it will
> have the wrong byte order on directory entries that are swabbed.
> Instead, use the standard practice of mask-and-shift to access the
> file_type and dirdata flags.
> 
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-4677
> Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> 
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
>  debugfs/htree.c          |   2 +-
>  debugfs/ls.c             |  44 +++++++++++++++-
>  e2fsck/pass1.c           |   4 +-
>  e2fsck/pass2.c           | 133 +++++++++++++++++++++++++++++++++++++++--------
>  e2fsck/pass3.c           |   8 +++
>  e2fsck/problem.c         |   5 ++
>  e2fsck/problem.h         |   3 ++
>  e2fsck/rehash.c          |  78 ++++++++++++++++-----------
>  lib/ext2fs/dirblock.c    |  34 ++++++++++++
>  lib/ext2fs/ext2_fs.h     |  16 +++++-
>  lib/ext2fs/ext2fs.h      |  22 +++++++-
>  lib/ext2fs/inline_data.c |  14 ++---
>  lib/ext2fs/lfsck.h       |  42 +++++++++++++++
>  lib/ext2fs/link.c        |  10 ++--
>  lib/ext2fs/newdir.c      |   4 +-
>  misc/mke2fs.c            |   1 +
>  misc/tune2fs.c           |   2 +
>  17 files changed, 349 insertions(+), 73 deletions(-)

Kind of a long patch here... (says the guy who habitually dumps out
huge patch series :P)

> diff --git a/debugfs/htree.c b/debugfs/htree.c
> index cf7d78aa..b7f1add0 100644
> --- a/debugfs/htree.c
> +++ b/debugfs/htree.c
> @@ -278,7 +278,7 @@ void do_htree_dump(int argc, char *argv[])
>  		goto errout;
>  	}
>  
> -	rootnode = (struct ext2_dx_root_info *) (buf + 24);
> +	rootnode = get_ext2_dx_root_info(current_fs, buf);
>  
>  	fprintf(pager, "Root node dump:\n");
>  	fprintf(pager, "\t Reserved zero: %u\n", rootnode->reserved_zero);
> diff --git a/debugfs/ls.c b/debugfs/ls.c
> index 61b63196..5655933e 100644
> --- a/debugfs/ls.c
> +++ b/debugfs/ls.c
> @@ -24,6 +24,7 @@ extern char *optarg;
>  #endif
>  
>  #include "debugfs.h"
> +#include "ext2fs/lfsck.h"
>  
>  /*
>   * list directory
> @@ -32,6 +33,7 @@ extern char *optarg;
>  #define LONG_OPT	0x0001
>  #define PARSE_OPT	0x0002
>  #define RAW_OPT		0x0004
> +#define DIRDATA_OPT	0x0008
>  #define ENCRYPT_OPT	0x8000
>  
>  struct list_dir_struct {
> @@ -44,6 +46,41 @@ struct list_dir_struct {
>  static const char *monstr[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
>  				"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
>  
> +static void list_dirdata(struct list_dir_struct *ls,
> +			 struct ext2_dir_entry *dirent)
> +{
> +	unsigned char	*data;
> +	int		dlen;
> +	__u8		dirdata_mask;
> +	__u8		file_type = dirent->name_len >> 8;
> +
> +	data = (unsigned char *)dirent->name +
> +		(dirent->name_len & EXT2_NAME_LEN) + 1;
> +
> +	for (dirdata_mask = EXT2_FT_MASK + 1;
> +	     dirdata_mask != 0; dirdata_mask <<= 1) {
> +		if ((dirdata_mask & file_type) == 0)
> +			continue;
> +
> +		dlen = data[0];
> +
> +		if (dirdata_mask == EXT2_DIRENT_LUFID) {
> +			struct lu_fid *fid = (struct lu_fid *)(data + 1);
> +
> +			fid_be_to_cpu(fid, fid);
> +			fprintf(ls->f, DFID, PFID(fid));

/me wonders if this could just be a fprintf_lufid() helper in lfsck.h...

> +		} else {
> +			int i;
> +
> +			for (i = 1; i < dlen; i++)
> +				fprintf(ls->f, "%02x", data[i]);
> +		}
> +
> +		fprintf(ls->f, " ");
> +		data += dlen;
> +	}
> +}
> +
>  static int print_filename(FILE *f, struct ext2_dir_entry *dirent, int options)
>  {
>  	unsigned char	ch;
> @@ -157,6 +194,8 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
>  		else
>  			fprintf(ls->f, "%5llu", EXT2_I_SIZE(&inode));
>  		fprintf(ls->f, " %s ", datestr);
> +		if ((ls->options & DIRDATA_OPT) != 0)
> +			list_dirdata(ls, dirent);
>  		print_filename(ls->f, dirent, options);
>  		fputc('\n', ls->f);
>  	} else {
> @@ -204,7 +243,7 @@ void do_list_dir(int argc, char *argv[])
>  		return;
>  
>  	reset_getopt();
> -	while ((c = getopt (argc, argv, "cdlpr")) != EOF) {
> +	while ((c = getopt(argc, argv, "cdDlpr")) != EOF) {
>  		switch (c) {
>  		case 'c':
>  			flags |= DIRENT_FLAG_INCLUDE_CSUM;
> @@ -212,6 +251,9 @@ void do_list_dir(int argc, char *argv[])
>  		case 'l':
>  			ls.options |= LONG_OPT;
>  			break;
> +		case 'D':
> +			ls.options |= DIRDATA_OPT;
> +			break;
>  		case 'd':
>  			flags |= DIRENT_FLAG_INCLUDE_REMOVED;
>  			break;
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 5015d938..686c2019 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -719,7 +719,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
>  		 */
>  		memcpy(&dotdot, inode->i_block, sizeof(dotdot));
>  		memcpy(&de, ((char *)inode->i_block) + EXT4_INLINE_DATA_DOTDOT_SIZE,
> -		       EXT2_DIR_REC_LEN(0));
> +		       __EXT2_DIR_REC_LEN(0));
>  		dotdot = ext2fs_le32_to_cpu(dotdot);
>  		de.inode = ext2fs_le32_to_cpu(de.inode);
>  		de.rec_len = ext2fs_le16_to_cpu(de.rec_len);
> @@ -2646,7 +2646,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
>  		return 1;
>  
>  	/* XXX should check that beginning matches a directory */
> -	root = (struct ext2_dx_root_info *) (block_buf + 24);
> +	root = get_ext2_dx_root_info(fs, block_buf);
>  
>  	if ((root->reserved_zero || root->info_length < 8) &&
>  	    fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 1b0504c8..1a719b2f 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -366,13 +366,88 @@ static EXT2_QSORT_TYPE special_dir_block_cmp(const void *a, const void *b)
>  	return (int) (db_a->blockcnt - db_b->blockcnt);
>  }
>  
> +void ext2_fix_dirent_dirdata(struct ext2_dir_entry *de)
> +{
> +	__u16 file_type = de->name_len & (EXT2_FT_MASK << 8);
> +	__u8 de_flags = (de->name_len >> 8) & ~EXT2_FT_MASK;
> +	__u8 name_len = de->name_len & EXT2_NAME_LEN;
> +	__u8 new_flag = 0;
> +	int i;
> +
> +	for (i = 0; i < 4; i++) {
> +		__u8 flags = new_flag | (1 << i) << 4;
> +
> +		/* new_flag is accumulating flags that are set in de_flags
> +		 * and still fit inside rec_len. ext2_get_dirent_dirdata_size()
> +		 * returns the size of all the dirdata entries in flags, and
> +		 * chops off any that are beyond rec_len.
> +		 */
> +		if ((de_flags & flags) == flags) {
> +			int dirdatalen = ext2_get_dirent_dirdata_size(de,
> +								      flags);
> +			int rlen = __EXT2_DIR_REC_LEN(name_len + dirdatalen);
> +
> +			if (rlen > de->rec_len)
> +				break;
> +
> +			new_flag |= flags;
> +		}
> +	}
> +
> +	de->name_len = name_len | file_type | (new_flag << 8);
> +}
> +
> +/*
> + * check for dirent data in ext3 dirent.
> + * return 0 if dirent data is ok.
> + * return 1 if dirent data does not exist.
> + * return 2 if dirent was modified due to error.
> + */
> +int e2fsck_check_dirent_data(e2fsck_t ctx, struct ext2_dir_entry *de,
> +			     unsigned int offset, struct problem_context *pctx)
> +{
> +	if (!(ctx->fs->super->s_feature_incompat &
> +			EXT4_FEATURE_INCOMPAT_DIRDATA)) {

if (!ext2fs_has_feature_dirdata(...))


> +		if ((de->name_len >> 8) & ~EXT2_FT_MASK) {
> +			/* clear dirent extra data flags. */
> +			if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
> +				de->name_len &= (EXT2_FT_MASK << 8) |
> +						EXT2_NAME_LEN;
> +				return 2;
> +			}
> +		}
> +		return 1;
> +	}
> +	if ((de->name_len >> 8) & ~EXT2_FT_MASK) {
> +		if (de->rec_len >= EXT2_DIR_REC_LEN(de) ||
> +		    de->rec_len + offset == EXT2_BLOCK_SIZE(ctx->fs->super)) {
> +			if (ext2_get_dirent_dirdata_size(de,
> +							 EXT2_DIRENT_LUFID) %
> +			    EXT2_DIRENT_LUFID_SIZE == 1 /*size*/ + 1 /*NULL*/)
> +				return 0;
> +		}
> +		/* just clear dirent data flags for now, we should fix FID data
> +		 * in lustre specific pass.
> +		 */
> +		if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
> +			ext2_fix_dirent_dirdata(de);
> +			if (ext2_get_dirent_dirdata_size(de,
> +							 EXT2_DIRENT_LUFID) !=
> +			    EXT2_DIRENT_LUFID_SIZE)
> +				de->name_len &= ~(EXT2_DIRENT_LUFID << 8);
> +
> +			return 2;
> +		}
> +	}
> +	return 1;
> +}
>  
>  /*
>   * Make sure the first entry in the directory is '.', and that the
>   * directory entry is sane.
>   */
>  static int check_dot(e2fsck_t ctx,
> -		     struct ext2_dir_entry *dirent,
> +		     struct ext2_dir_entry *dirent, unsigned int offset,
>  		     ext2_ino_t ino, struct problem_context *pctx)
>  {
>  	struct ext2_dir_entry *nextdir;
> @@ -380,6 +455,7 @@ static int check_dot(e2fsck_t ctx,
>  	int		status = 0;
>  	int		created = 0;
>  	problem_t	problem = 0;
> +	int		dir_data_error;
>  
>  	if (!dirent->inode)
>  		problem = PR_2_MISSING_DOT;
> @@ -389,10 +465,12 @@ static int check_dot(e2fsck_t ctx,
>  	else if (dirent->name[1] != '\0')
>  		problem = PR_2_DOT_NULL_TERM;
>  
> +	dir_data_error = e2fsck_check_dirent_data(ctx, dirent, offset, pctx);
> +
>  	(void) ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
>  	if (problem) {
>  		if (fix_problem(ctx, problem, pctx)) {
> -			if (rec_len < 12)
> +			if (rec_len < 12 && dir_data_error)
>  				rec_len = dirent->rec_len = 12;
>  			dirent->inode = ino;
>  			ext2fs_dirent_set_name_len(dirent, 1);
> @@ -411,7 +489,7 @@ static int check_dot(e2fsck_t ctx,
>  	}
>  	if (rec_len > 12) {
>  		new_len = rec_len - 12;
> -		if (new_len > 12) {
> +		if (new_len > 12 && dir_data_error) {
>  			if (created ||
>  			    fix_problem(ctx, PR_2_SPLIT_DOT, pctx)) {
>  				nextdir = (struct ext2_dir_entry *)
> @@ -436,11 +514,12 @@ static int check_dot(e2fsck_t ctx,
>   * here; this gets done in pass 3.
>   */
>  static int check_dotdot(e2fsck_t ctx,
> -			struct ext2_dir_entry *dirent,
> +			struct ext2_dir_entry *dirent, unsigned int offset,
>  			ext2_ino_t ino, struct problem_context *pctx)
>  {
>  	problem_t	problem = 0;
>  	unsigned int	rec_len;
> +	int		dir_data_error;
>  
>  	if (!dirent->inode)
>  		problem = PR_2_MISSING_DOT_DOT;
> @@ -451,10 +530,12 @@ static int check_dotdot(e2fsck_t ctx,
>  	else if (dirent->name[2] != '\0')
>  		problem = PR_2_DOT_DOT_NULL_TERM;
>  
> +	dir_data_error = e2fsck_check_dirent_data(ctx, dirent, offset, pctx);
> +
>  	(void) ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
>  	if (problem) {
>  		if (fix_problem(ctx, problem, pctx)) {
> -			if (rec_len < 12)
> +			if (rec_len < 12 && dir_data_error)
>  				dirent->rec_len = 12;
>  			/*
>  			 * Note: we don't have the parent inode just
> @@ -528,6 +609,13 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
>  	int	filetype = ext2fs_dirent_file_type(dirent);
>  	int	should_be = EXT2_FT_UNKNOWN;
>  	struct ext2_inode	inode;
> +	__u8    dirdata = 0;
> +
> +	if (ctx->fs->super->s_feature_incompat &
> +			EXT4_FEATURE_INCOMPAT_DIRDATA) {
> +		dirdata = filetype & ~EXT2_FT_MASK;
> +		filetype = filetype & EXT2_FT_MASK;
> +	}
>  
>  	if (!ext2fs_has_feature_filetype(ctx->fs->super)) {
>  		if (filetype == 0 ||
> @@ -559,7 +647,7 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
>  			pctx) == 0)
>  		return 0;
>  
> -	ext2fs_dirent_set_file_type(dirent, should_be);
> +	ext2fs_dirent_set_file_type(dirent, should_be | dirdata);
>  	return 1;
>  }
>  
> @@ -581,7 +669,7 @@ static void parse_int_node(ext2_filsys fs,
>  	int		csum_size = 0;
>  
>  	if (db->blockcnt == 0) {
> -		root = (struct ext2_dx_root_info *) (block_buf + 24);
> +		root = get_ext2_dx_root_info(fs, block_buf);
>  
>  #ifdef DX_DEBUG
>  		printf("Root node dump:\n");
> @@ -591,8 +679,8 @@ static void parse_int_node(ext2_filsys fs,
>  		printf("\t Indirect levels: %d\n", root->indirect_levels);
>  		printf("\t Flags: %d\n", root->unused_flags);
>  #endif
> -
> -		ent = (struct ext2_dx_entry *) (block_buf + 24 + root->info_length);
> +		ent = (struct ext2_dx_entry *)((char *)root +
> +					       root->info_length);
>  
>  		if (failed_csum &&
>  		    (e2fsck_dir_will_be_rehashed(cd->ctx, cd->pctx.ino) ||
> @@ -600,7 +688,7 @@ static void parse_int_node(ext2_filsys fs,
>  				&cd->pctx)))
>  			goto clear_and_exit;
>  	} else {
> -		ent = (struct ext2_dx_entry *) (block_buf+8);
> +		ent = (struct ext2_dx_entry *)(block_buf + 8);
>  
>  		if (failed_csum &&
>  		    (e2fsck_dir_will_be_rehashed(cd->ctx, cd->pctx.ino) ||
> @@ -608,8 +696,7 @@ static void parse_int_node(ext2_filsys fs,
>  				&cd->pctx)))
>  			goto clear_and_exit;
>  	}
> -
> -	limit = (struct ext2_dx_countlimit *) ent;
> +	limit = (struct ext2_dx_countlimit *)ent;
>  
>  #ifdef DX_DEBUG
>  	printf("Number of entries (count): %d\n",
> @@ -794,7 +881,7 @@ static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
>  		d = NEXT_DIRENT(d);
>  
>  	if (d != top) {
> -		unsigned int min_size = EXT2_DIR_REC_LEN(
> +		unsigned int min_size = __EXT2_DIR_REC_LEN(
>  				ext2fs_dirent_name_len(dirbuf));
>  		if (min_size > (char *)top - (char *)d)
>  			return EXT2_ET_DIR_NO_SPACE_FOR_CSUM;
> @@ -828,7 +915,7 @@ static errcode_t fix_inline_dir_size(e2fsck_t ctx, ext2_ino_t ino,
>  	 */
>  	if (old_size > EXT4_MIN_INLINE_DATA_SIZE &&
>  	    old_size < EXT4_MIN_INLINE_DATA_SIZE +
> -		       EXT2_DIR_REC_LEN(1)) {
> +		       __EXT2_DIR_REC_LEN(1)) {
>  		old_size = EXT4_MIN_INLINE_DATA_SIZE;
>  		new_size = old_size;
>  	} else
> @@ -1035,7 +1122,7 @@ inline_read_fail:
>  	if (((inline_data_size & 3) ||
>  	     (inline_data_size > EXT4_MIN_INLINE_DATA_SIZE &&
>  	      inline_data_size < EXT4_MIN_INLINE_DATA_SIZE +
> -				 EXT2_DIR_REC_LEN(1))) &&
> +				 __EXT2_DIR_REC_LEN(1))) &&
>  	    fix_problem(ctx, PR_2_BAD_INLINE_DIR_SIZE, &pctx)) {
>  		errcode_t err = fix_inline_dir_size(ctx, ino,
>  						    &inline_data_size, &pctx,
> @@ -1085,7 +1172,7 @@ inline_read_fail:
>  		(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
>  		limit = (struct ext2_dx_countlimit *) (buf+8);
>  		if (db->blockcnt == 0) {
> -			root = (struct ext2_dx_root_info *) (buf + 24);
> +			root = get_ext2_dx_root_info(fs, buf);
>  			dx_db->type = DX_DIRBLOCK_ROOT;
>  			dx_db->flags |= DX_FLAG_FIRST | DX_FLAG_LAST;
>  			if ((root->reserved_zero ||
> @@ -1165,7 +1252,7 @@ skip_checksum:
>  			 * force salvaging this dir.
>  			 */
>  			if (max_block_size - offset < EXT2_DIR_ENTRY_HEADER_LEN)
> -				rec_len = EXT2_DIR_REC_LEN(1);
> +				rec_len = __EXT2_DIR_REC_LEN(1);
>  			else
>  				(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
>  			cd->pctx.dirent = dirent;
> @@ -1227,7 +1314,7 @@ skip_checksum:
>  				memset(&dot, 0, sizeof(dot));
>  				dirent = &dot;
>  				dirent->inode = ino;
> -				dirent->rec_len = EXT2_DIR_REC_LEN(1);
> +				dirent->rec_len = __EXT2_DIR_REC_LEN(1);
>  				dirent->name_len = 1 | filetype;
>  				dirent->name[0] = '.';
>  			} else if (dot_state == 1) {
> @@ -1235,7 +1322,7 @@ skip_checksum:
>  				dirent = &dotdot;
>  				dirent->inode =
>  					((struct ext2_dir_entry *)buf)->inode;
> -				dirent->rec_len = EXT2_DIR_REC_LEN(2);
> +				dirent->rec_len = __EXT2_DIR_REC_LEN(2);
>  				dirent->name_len = 2 | filetype;
>  				dirent->name[0] = '.';
>  				dirent->name[1] = '.';
> @@ -1247,10 +1334,10 @@ skip_checksum:
>  		}
>  
>  		if (dot_state == 0) {
> -			if (check_dot(ctx, dirent, ino, &cd->pctx))
> +			if (check_dot(ctx, dirent, offset, ino, &cd->pctx))
>  				dir_modified++;
>  		} else if (dot_state == 1) {
> -			ret = check_dotdot(ctx, dirent, ino, &cd->pctx);
> +			ret = check_dotdot(ctx, dirent, offset, ino, &cd->pctx);
>  			if (ret < 0)
>  				goto abort_free_dict;
>  			if (ret)
> @@ -1266,6 +1353,10 @@ skip_checksum:
>  		if (!dirent->inode)
>  			goto next;
>  
> +		ret = e2fsck_check_dirent_data(ctx, dirent, offset, &cd->pctx);
> +		if (ret == 2)
> +			dir_modified++;
> +
>  		/*
>  		 * Make sure the inode listed is a legal one.
>  		 */
> diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
> index 6a975b36..8ed871ff 100644
> --- a/e2fsck/pass3.c
> +++ b/e2fsck/pass3.c
> @@ -698,6 +698,7 @@ static int fix_dotdot_proc(struct ext2_dir_entry *dirent,
>  	struct fix_dotdot_struct *fp = (struct fix_dotdot_struct *) priv_data;
>  	errcode_t	retval;
>  	struct problem_context pctx;
> +	__u16 dirdata = 0;
>  
>  	if (ext2fs_dirent_name_len(dirent) != 2)
>  		return 0;
> @@ -717,11 +718,18 @@ static int fix_dotdot_proc(struct ext2_dir_entry *dirent,
>  		fix_problem(fp->ctx, PR_3_ADJUST_INODE, &pctx);
>  	}
>  	dirent->inode = fp->parent;
> +
> +	dirdata  = dirent->name_len & (~EXT2_FT_MASK << 8);
> +
>  	if (ext2fs_has_feature_filetype(fp->ctx->fs->super))
>  		ext2fs_dirent_set_file_type(dirent, EXT2_FT_DIR);
>  	else
>  		ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
>  
> +	if (fp->ctx->fs->super->s_feature_incompat &
> +	    EXT4_FEATURE_INCOMPAT_DIRDATA)

if (ext2fs_has_feature_dirdata(...)) ?

> +		dirent->name_len |= dirdata;
> +
>  	fp->done++;
>  	return DIRENT_ABORT | DIRENT_CHANGED;
>  }
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index edc9d51f..2a86d528 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1671,6 +1671,11 @@ static struct e2fsck_problem problem_table[] = {
>  	  N_("Encrypted @E is too short.\n"),
>  	  PROMPT_CLEAR, 0 },
>  
> +	/* Directory entry dirdata length set incorrectly */
> +	{ PR_2_CLEAR_DIRDATA,
> +	  N_("@E dirdata length set incorrectly.\n"),
> +	  PROMPT_CLEAR, PR_PREEN_OK },
> +
>  	/* Pass 3 errors */
>  
>  	/* Pass 3: Checking directory connectivity */
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index 482d111a..05214840 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -1004,6 +1004,9 @@ struct problem_context {
>  /* Encrypted directory entry is too short */
>  #define PR_2_BAD_ENCRYPTED_NAME		0x020050
>  
> +/* Entry dirdata length set incorrectly */
> +#define PR_2_CLEAR_DIRDATA		0x020051
> +
>  /*
>   * Pass 3 errors
>   */
> diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
> index 486e1f21..8656c417 100644
> --- a/e2fsck/rehash.c
> +++ b/e2fsck/rehash.c
> @@ -85,6 +85,8 @@ struct fill_dir_struct {
>  	int compress;
>  	ino_t parent;
>  	ext2_ino_t dir;
> +	struct ext2_dir_entry *dot_de;
> +	struct ext2_dir_entry *dotdot_de;
>  };
>  
>  struct hash_entry {
> @@ -160,11 +162,14 @@ static int fill_dir_block(ext2_filsys fs,
>  		if (dirent->inode == 0)
>  			continue;
>  		if (!fd->compress && (name_len == 1) &&
> -		    (dirent->name[0] == '.'))
> +		    (dirent->name[0] == '.')) {
> +			fd->dot_de = dirent;
>  			continue;
> +		}
>  		if (!fd->compress && (name_len == 2) &&
>  		    (dirent->name[0] == '.') && (dirent->name[1] == '.')) {
>  			fd->parent = dirent->inode;
> +			fd->dotdot_de = dirent;
>  			continue;
>  		}
>  		if (fd->num_array >= fd->max_array) {
> @@ -179,7 +184,7 @@ static int fill_dir_block(ext2_filsys fs,
>  		}
>  		ent = fd->harray + fd->num_array++;
>  		ent->dir = dirent;
> -		fd->dir_size += EXT2_DIR_REC_LEN(name_len);
> +		fd->dir_size += EXT2_DIR_REC_LEN(dirent);
>  		ent->ino = dirent->inode;
>  		if (fd->compress)
>  			ent->hash = ent->minor_hash = 0;
> @@ -475,7 +480,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
>  		ent = fd->harray + i;
>  		if (ent->dir->inode == 0)
>  			continue;
> -		rec_len = EXT2_DIR_REC_LEN(ext2fs_dirent_name_len(ent->dir));
> +		rec_len = EXT2_DIR_REC_LEN(ent->dir);
>  		if (rec_len > left) {
>  			if (left) {
>  				left += prev_rec_len;
> @@ -510,8 +515,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
>  		if (retval)
>  			return retval;
>  		prev_rec_len = rec_len;
> -		memcpy(dirent->name, ent->dir->name,
> -		       ext2fs_dirent_name_len(dirent));
> +		memcpy(dirent->name, ent->dir->name, rec_len);
>  		offset += rec_len;
>  		left -= rec_len;
>  		if (left < slack) {
> @@ -536,45 +540,54 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
>  
>  
>  static struct ext2_dx_root_info *set_root_node(ext2_filsys fs, char *buf,
> -				    ext2_ino_t ino, ext2_ino_t parent)
> +					ext2_ino_t ino, ext2_ino_t parent,
> +					struct ext2_dir_entry *dot_de,
> +					struct ext2_dir_entry *dotdot_de)
>  {
> -	struct ext2_dir_entry 		*dir;
> -	struct ext2_dx_root_info  	*root;
> +	struct ext2_dir_entry		*dir;
> +	struct ext2_dx_root_info	*root;
>  	struct ext2_dx_countlimit	*limits;
> -	int				filetype = 0;
>  	int				csum_size = 0;
> -
> -	if (ext2fs_has_feature_filetype(fs->super))
> -		filetype = EXT2_FT_DIR;
> +	int				offset;
> +	int				rec_len;
>  
>  	memset(buf, 0, fs->blocksize);
>  	dir = (struct ext2_dir_entry *) buf;
>  	dir->inode = ino;
> -	dir->name[0] = '.';
> -	ext2fs_dirent_set_name_len(dir, 1);
> -	ext2fs_dirent_set_file_type(dir, filetype);
> -	dir->rec_len = 12;
> -	dir = (struct ext2_dir_entry *) (buf + 12);
> +
> +	ext2fs_dirent_set_name_len(dir, dot_de->name_len);
> +	dir->rec_len = dot_de->rec_len;
> +	rec_len	= EXT2_DIR_REC_LEN(dot_de);
> +	memcpy(dir->name, dot_de->name, rec_len);
> +	offset = rec_len;
> +
> +	dir = (struct ext2_dir_entry *) (buf + offset);
> +	/* set to jump over the index block */
> +
>  	dir->inode = parent;
> -	dir->name[0] = '.';
> -	dir->name[1] = '.';
> -	ext2fs_dirent_set_name_len(dir, 2);
> -	ext2fs_dirent_set_file_type(dir, filetype);
> -	dir->rec_len = fs->blocksize - 12;
>  
> -	root = (struct ext2_dx_root_info *) (buf+24);
> +	ext2fs_dirent_set_name_len(dir, dotdot_de->name_len);
> +	dir->rec_len = fs->blocksize - rec_len;
> +	rec_len = EXT2_DIR_REC_LEN(dotdot_de);
> +	memcpy(dir->name, dotdot_de->name, rec_len);
> +	offset += rec_len;
> +
> +	root = (struct ext2_dx_root_info *) (buf + offset);
> +
>  	root->reserved_zero = 0;
>  	root->hash_version = fs->super->s_def_hash_version;
> -	root->info_length = 8;
> +	root->info_length = sizeof(struct ext2_dx_root_info);
>  	root->indirect_levels = 0;
>  	root->unused_flags = 0;
> +	offset += sizeof(struct ext2_dx_root_info);
>  
>  	if (ext2fs_has_feature_metadata_csum(fs->super))
>  		csum_size = sizeof(struct ext2_dx_tail);
>  
> -	limits = (struct ext2_dx_countlimit *) (buf+32);
> -	limits->limit = (fs->blocksize - (32 + csum_size)) /
> +	limits->limit = (fs->blocksize - (offset + csum_size)) /
>  			sizeof(struct ext2_dx_entry);
> +	limits = (struct ext2_dx_countlimit *) (buf + offset);
> +
>  	limits->count = 0;
>  
>  	return root;
> @@ -647,7 +660,9 @@ static int alloc_blocks(ext2_filsys fs,
>  static errcode_t calculate_tree(ext2_filsys fs,
>  				struct out_dir *outdir,
>  				ext2_ino_t ino,
> -				ext2_ino_t parent)
> +				ext2_ino_t parent,
> +				struct ext2_dir_entry *dot_de,
> +				struct ext2_dir_entry *dotdot_de)
>  {
>  	struct ext2_dx_root_info	*root_info;
>  	struct ext2_dx_entry		*root, *int_ent, *dx_ent = 0;
> @@ -657,7 +672,9 @@ static errcode_t calculate_tree(ext2_filsys fs,
>  	int				i, c1, c2, c3, nblks;
>  	int				limit_offset, int_offset, root_offset;
>  
> -	root_info = set_root_node(fs, outdir->buf, ino, parent);
> +	root_info = set_root_node(fs, outdir->buf, ino, parent, dot_de,
> +				  dotdot_de);
> +
>  	root_offset = limit_offset = ((char *) root_info - outdir->buf) +
>  		root_info->info_length;
>  	root_limit = (struct ext2_dx_countlimit *) (outdir->buf + limit_offset);
> @@ -944,11 +961,10 @@ resort:
>  	if (retval)
>  		goto errout;
>  
> -	free(dir_buf); dir_buf = 0;
> -
>  	if (!fd.compress) {
>  		/* Calculate the interior nodes */
> -		retval = calculate_tree(fs, &outdir, ino, fd.parent);
> +		retval = calculate_tree(fs, &outdir, ino, fd.parent,
> +					fd.dot_de, fd.dotdot_de);
>  		if (retval)
>  			goto errout;
>  	}
> diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
> index 54b27772..e524139b 100644
> --- a/lib/ext2fs/dirblock.c
> +++ b/lib/ext2fs/dirblock.c
> @@ -50,6 +50,40 @@ errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
>  	return ext2fs_read_dir_block4(fs, block, buf, flags, 0);
>  }
>  
> +/*
> + * Compute the total directory entry data length.
> + * This includes the filename and an implicit NUL terminator (always present),
> + * and optional extensions.  Each extension has a bit set in the high 4 bits of
> + * de->file_type, and the extension length is the first byte in each entry.
> + */
> +int ext2_get_dirent_dirdata_size(struct ext2_dir_entry *de,
> +				 char dirdata_flags)
> +{
> +	char *len = de->name + (de->name_len & EXT2_NAME_LEN) + 1 /* NUL */;
> +	__u8 extra_data_flags = (de->name_len & ~(EXT2_FT_MASK << 8)) >> 12;
> +	int dlen = 0;
> +
> +	dirdata_flags >>= 4;
> +	while ((extra_data_flags & dirdata_flags) != 0) {
> +		if (extra_data_flags & 1) {
> +			if (dirdata_flags & 1)
> +				dlen += *len;
> +
> +			len += *len;
> +		}
> +		extra_data_flags >>= 1;
> +		dirdata_flags >>= 1;
> +	}
> +
> +	/* add NUL terminator byte to dirdata length */
> +	return dlen + (dlen != 0);
> +}
> +
> +int ext2_get_dirent_size(struct ext2_dir_entry *de)
> +{
> +	return ext2_get_dirent_dirdata_size(de, ~EXT2_FT_MASK);
> +}
> +
>  errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
>  				 void *buf, int flags EXT2FS_ATTR((unused)))
>  {
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 2496d16d..f0cab391 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -923,7 +923,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		4, ENCRYPT)
>  #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
>  				       EXT4_FEATURE_INCOMPAT_MMP| \
>  				       EXT4_FEATURE_INCOMPAT_LARGEDIR| \
> -				       EXT4_FEATURE_INCOMPAT_EA_INODE)
> +				       EXT4_FEATURE_INCOMPAT_EA_INODE| \
> +				       EXT4_FEATURE_INCOMPAT_DIRDATA)
>  #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
>  					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
>  					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
> @@ -1011,6 +1012,7 @@ struct ext2_dir_entry_tail {
>  #define EXT2_FT_SYMLINK		7
>  
>  #define EXT2_FT_MAX		8
> +#define EXT2_FT_MASK		0x0f
>  
>  /*
>   * Annoyingly, e2fsprogs always swab16s ext2_dir_entry.name_len, so we
> @@ -1028,11 +1030,18 @@ struct ext2_dir_entry_tail {
>  #define EXT2_DIR_ENTRY_HEADER_LEN	8
>  #define EXT2_DIR_PAD			4
>  #define EXT2_DIR_ROUND			(EXT2_DIR_PAD - 1)
> -#define EXT2_DIR_REC_LEN(name_len)	(((name_len) + \
> +#define __EXT2_DIR_REC_LEN(name_len)	(((name_len) + \
>  					  EXT2_DIR_ENTRY_HEADER_LEN + \
>  					  EXT2_DIR_ROUND) & \
>  					 ~EXT2_DIR_ROUND)
>  
> +#define EXT2_DIR_REC_LEN(de)	(__EXT2_DIR_REC_LEN(((de)->name_len &         \
> +						     EXT2_NAME_LEN) +         \
> +						    ext2_get_dirent_size(de)))

Still need a comment explaining the difference between the two.

> +/* lu_fid size and NUL char */
> +#define EXT2_DIRENT_LUFID_SIZE		16
> +#define EXT2_DIRENT_LUFID		0x10
> +
>  /*
>   * Constants for ext4's extended time encoding
>   */
> @@ -1091,6 +1100,9 @@ struct mmp_struct {
>   */
>  #define EXT4_MMP_MIN_CHECK_INTERVAL     5
>  
> +int ext2_get_dirent_dirdata_size(struct ext2_dir_entry *de, char dirdata_flags);
> +int ext2_get_dirent_size(struct ext2_dir_entry *de);
> +
>  /*
>   * Minimum size of inline data.
>   */
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 6774e32c..b653012f 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -600,6 +600,7 @@ typedef struct ext2_icount *ext2_icount_t;
>  					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
>  					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
>  					 EXT4_FEATURE_INCOMPAT_EA_INODE|\
> +					 EXT4_FEATURE_INCOMPAT_DIRDATA|\
>  					 EXT4_LIB_INCOMPAT_MMP|\
>  					 EXT4_FEATURE_INCOMPAT_64BIT|\
>  					 EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
> @@ -1978,6 +1979,25 @@ _INLINE_ int ext2fs_htree_intnode_maxrecs(ext2_filsys fs, int blocks)
>  	return blocks * ((fs->blocksize - 8) / sizeof(struct ext2_dx_entry));
>  }
>  
> +_INLINE_ struct ext2_dx_root_info *get_ext2_dx_root_info(ext2_filsys fs,
> +							 char *buf)
> +{
> +	struct ext2_dir_entry *de = (struct ext2_dir_entry *)buf;
> +
> +	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_DIRDATA))
> +		return (struct ext2_dx_root_info *)(buf +
> +						    __EXT2_DIR_REC_LEN(1) +
> +						    __EXT2_DIR_REC_LEN(2));
> +
> +	/* get dotdot first */
> +	de = (struct ext2_dir_entry *)((char *)de + de->rec_len);
> +
> +	/* dx root info is after dotdot entry */
> +	de = (struct ext2_dir_entry *)((char *)de + EXT2_DIR_REC_LEN(de));
> +
> +	return (struct ext2_dx_root_info *)de;
> +}
> +
>  /*
>   * This is an efficient, overflow safe way of calculating ceil((1.0 * a) / b)
>   */
> @@ -1997,7 +2017,7 @@ _INLINE_ __u64 ext2fs_div64_ceil(__u64 a, __u64 b)
>  
>  _INLINE_ int ext2fs_dirent_name_len(const struct ext2_dir_entry *entry)
>  {
> -	return entry->name_len & 0xff;
> +	return entry->name_len & EXT2_NAME_LEN;
>  }
>  
>  _INLINE_ void ext2fs_dirent_set_name_len(struct ext2_dir_entry *entry, int len)
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index 7215c517..2ce2f6f7 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -149,7 +149,7 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
>  	/* we first check '.' and '..' dir */
>  	dirent.inode = ino;
>  	dirent.name_len = 1;
> -	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(2), &dirent);
> +	ext2fs_set_rec_len(fs, __EXT2_DIR_REC_LEN(2), &dirent);
>  	dirent.name[0] = '.';
>  	dirent.name[1] = '\0';
>  	ctx->buf = (char *)&dirent;
> @@ -160,7 +160,7 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
>  
>  	dirent.inode = ext2fs_le32_to_cpu(inode.i_block[0]);
>  	dirent.name_len = 2;
> -	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(3), &dirent);
> +	ext2fs_set_rec_len(fs, __EXT2_DIR_REC_LEN(3), &dirent);
>  	dirent.name[0] = '.';
>  	dirent.name[1] = '.';
>  	dirent.name[2] = '\0';
> @@ -296,14 +296,14 @@ static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
>  	ext2fs_dirent_set_name_len(dir, 1);
>  	ext2fs_dirent_set_file_type(dir, filetype);
>  	dir->name[0] = '.';
> -	rec_len = (fs->blocksize - csum_size) - EXT2_DIR_REC_LEN(1);
> -	dir->rec_len = EXT2_DIR_REC_LEN(1);
> +	rec_len = (fs->blocksize - csum_size) - __EXT2_DIR_REC_LEN(1);
> +	dir->rec_len = __EXT2_DIR_REC_LEN(1);
>  
>  	/*
>  	 * Set up entry for '..'
>  	 */
>  	dir = (struct ext2_dir_entry *) (bbuf + dir->rec_len);
> -	dir->rec_len = EXT2_DIR_REC_LEN(2);
> +	dir->rec_len = __EXT2_DIR_REC_LEN(2);
>  	dir->inode = ext2fs_le32_to_cpu(((__u32 *)ibuf)[0]);
>  	ext2fs_dirent_set_name_len(dir, 2);
>  	ext2fs_dirent_set_file_type(dir, filetype);
> @@ -313,11 +313,11 @@ static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
>  	/*
>  	 * Adjust the last rec_len
>  	 */
> -	offset = EXT2_DIR_REC_LEN(1) + EXT2_DIR_REC_LEN(2);
> +	offset = __EXT2_DIR_REC_LEN(1) + __EXT2_DIR_REC_LEN(2);
>  	dir = (struct ext2_dir_entry *) (bbuf + offset);
>  	memcpy(bbuf + offset, ibuf + EXT4_INLINE_DATA_DOTDOT_SIZE,
>  	       size - EXT4_INLINE_DATA_DOTDOT_SIZE);
> -	size += EXT2_DIR_REC_LEN(1) + EXT2_DIR_REC_LEN(2) -
> +	size += __EXT2_DIR_REC_LEN(1) + __EXT2_DIR_REC_LEN(2) -
>  		EXT4_INLINE_DATA_DOTDOT_SIZE;
>  
>  	do {
> diff --git a/lib/ext2fs/lfsck.h b/lib/ext2fs/lfsck.h
> new file mode 100644
> index 00000000..9401cd0c
> --- /dev/null
> +++ b/lib/ext2fs/lfsck.h
> @@ -0,0 +1,42 @@
> +#ifndef LFSCK_H
> +#define LFSCK_H
> +
> +/* This is unfortunately needed for older lustre_user.h to be usable */
> +#define LASSERT(cond)		do { } while (0)
> +
> +#ifdef HAVE_LUSTRE_LUSTREAPI_H
> +#include <lustre/lustreapi.h>
> +#elif HAVE_LUSTRE_LIBLUSTREAPI_H
> +#include <lustre/liblustreapi.h>
> +#endif
> +
> +#ifndef DFID
> +#define DFID "[%#llx:0x%x:0x%x]"
> +#define PFID(fid) ((unsigned long long)fid_seq(fid),\
> +		fid_oid(fid), fid_ver(fid))
> +struct lu_fid {
> +	__u64   f_seq;
> +	__u32   f_oid;
> +	__u32   f_ver;
> +};
> +#endif /* !DFID */
> +
> +/* Unfortunately, neither the 1.8 or 2.x lustre_idl.h file is suitable
> + * for inclusion by userspace programs because of external dependencies.
> + * Define the minimum set of replacement functions here until that is fixed.
> + */
> +#ifndef HAVE_LUSTRE_LUSTRE_IDL_H
> +#define fid_seq(fid) ((fid)->f_seq)
> +#define fid_oid(fid) ((fid)->f_oid)
> +#define fid_ver(fid) ((fid)->f_ver)
> +
> +static inline void fid_be_to_cpu(struct lu_fid *dst, struct lu_fid *src)
> +{
> +	dst->f_seq = ext2fs_be64_to_cpu(src->f_seq);
> +	dst->f_oid = ext2fs_be32_to_cpu(src->f_oid);
> +	dst->f_ver = ext2fs_be32_to_cpu(src->f_ver);
> +}
> +#endif
> +
> +#endif /* LFSCK_H */
> +
> diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
> index 65dc8877..5bb1581f 100644
> --- a/lib/ext2fs/link.c
> +++ b/lib/ext2fs/link.c
> @@ -47,7 +47,7 @@ static int link_proc(struct ext2_dir_entry *dirent,
>  	if (ls->done)
>  		return DIRENT_ABORT;
>  
> -	rec_len = EXT2_DIR_REC_LEN(ls->namelen);
> +	rec_len = __EXT2_DIR_REC_LEN(ls->namelen);
>  
>  	ls->err = ext2fs_get_rec_len(ls->fs, dirent, &curr_rec_len);
>  	if (ls->err)
> @@ -92,8 +92,8 @@ static int link_proc(struct ext2_dir_entry *dirent,
>  
>  	/* De-convert a dx_root block */
>  	if (csum_size &&
> -	    curr_rec_len == ls->fs->blocksize - EXT2_DIR_REC_LEN(1) &&
> -	    offset == EXT2_DIR_REC_LEN(1) &&
> +	    curr_rec_len == ls->fs->blocksize - __EXT2_DIR_REC_LEN(1) &&
> +	    offset == __EXT2_DIR_REC_LEN(1) &&
>  	    dirent->name[0] == '.' && dirent->name[1] == '.') {
>  		curr_rec_len -= csum_size;
>  		ls->err = ext2fs_set_rec_len(ls->fs, curr_rec_len, dirent);
> @@ -110,7 +110,7 @@ static int link_proc(struct ext2_dir_entry *dirent,
>  	 * truncate it and return.
>  	 */
>  	if (dirent->inode) {
> -		min_rec_len = EXT2_DIR_REC_LEN(ext2fs_dirent_name_len(dirent));
> +		min_rec_len = EXT2_DIR_REC_LEN(dirent);
>  		if (curr_rec_len < (min_rec_len + rec_len))
>  			return ret;
>  		rec_len = curr_rec_len - min_rec_len;
> @@ -138,7 +138,7 @@ static int link_proc(struct ext2_dir_entry *dirent,
>  	ext2fs_dirent_set_name_len(dirent, ls->namelen);
>  	strncpy(dirent->name, ls->name, ls->namelen);
>  	if (ext2fs_has_feature_filetype(ls->sb))
> -		ext2fs_dirent_set_file_type(dirent, ls->flags & 0x7);
> +		ext2fs_dirent_set_file_type(dirent, ls->flags & EXT2_FT_MASK);
>  
>  	ls->done++;
>  	return DIRENT_ABORT|DIRENT_CHANGED;
> diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
> index 7f472850..aa88f3e4 100644
> --- a/lib/ext2fs/newdir.c
> +++ b/lib/ext2fs/newdir.c
> @@ -64,8 +64,8 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
>  		ext2fs_dirent_set_name_len(dir, 1);
>  		ext2fs_dirent_set_file_type(dir, filetype);
>  		dir->name[0] = '.';
> -		rec_len = (fs->blocksize - csum_size) - EXT2_DIR_REC_LEN(1);
> -		dir->rec_len = EXT2_DIR_REC_LEN(1);
> +		rec_len = (fs->blocksize - csum_size) - __EXT2_DIR_REC_LEN(1);
> +		dir->rec_len = __EXT2_DIR_REC_LEN(1);
>  
>  		/*
>  		 * Set up entry for '..'
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index cfb10bc4..1edc0cd1 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1084,6 +1084,7 @@ static __u32 ok_features[3] = {
>  		EXT4_FEATURE_INCOMPAT_FLEX_BG|
>  		EXT4_FEATURE_INCOMPAT_EA_INODE|
>  		EXT4_FEATURE_INCOMPAT_MMP |
> +		EXT4_FEATURE_INCOMPAT_DIRDATA|
>  		EXT4_FEATURE_INCOMPAT_64BIT|
>  		EXT4_FEATURE_INCOMPAT_INLINE_DATA|
>  		EXT4_FEATURE_INCOMPAT_ENCRYPT |
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index d0a18a18..44dd41a5 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -157,6 +157,7 @@ static __u32 ok_features[3] = {
>  		EXT4_FEATURE_INCOMPAT_FLEX_BG |
>  		EXT4_FEATURE_INCOMPAT_EA_INODE|
>  		EXT4_FEATURE_INCOMPAT_MMP |
> +		EXT4_FEATURE_INCOMPAT_DIRDATA |
>  		EXT4_FEATURE_INCOMPAT_64BIT |
>  		EXT4_FEATURE_INCOMPAT_ENCRYPT |
>  		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
> @@ -183,6 +184,7 @@ static __u32 clear_ok_features[3] = {
>  	EXT2_FEATURE_INCOMPAT_FILETYPE |
>  		EXT4_FEATURE_INCOMPAT_FLEX_BG |
>  		EXT4_FEATURE_INCOMPAT_MMP |
> +		EXT4_FEATURE_INCOMPAT_DIRDATA |
>  		EXT4_FEATURE_INCOMPAT_64BIT |
>  		EXT4_FEATURE_INCOMPAT_CSUM_SEED,
>  	/* R/O compat */
> -- 
> 2.13.6 (Apple Git-96)
> 
