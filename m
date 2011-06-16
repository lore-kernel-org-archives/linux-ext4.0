From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH 08/11 RESEND] e4defrag: Use blk64_t instead of ext4_fsblk_t
Date: Wed, 15 Jun 2011 21:19:51 -0600
Message-ID: <876C7F6D-1FB0-4E04-A6DD-0A3554C10A91@gmail.com>
References: <4DF85313.7000404@sx.jp.nec.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42750 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1FPDTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jun 2011 23:19:40 -0400
Received: by pwj7 with SMTP id 7so38099pwj.19
        for <linux-ext4@vger.kernel.org>; Wed, 15 Jun 2011 20:19:40 -0700 (PDT)
In-Reply-To: <4DF85313.7000404@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-15, at 12:37 AM, Kazuya Mio <k-mio@sx.jp.nec.com> wrote:
> e2fsprogs has blk64_t defined for the physical block number. e4defrag uses it
> instead of ext4_fsblk_t.

On a related note, I'd like to make a patch to e2fsprogs to make the type names consistent with the kernel.

> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---
> misc/e4defrag.c |   19 ++++++++-----------
> 1 file changed, 8 insertions(+), 11 deletions(-)
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index ba0d424..6365103 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -41,6 +41,7 @@
> 
> #include "e2p/e2p.h"
> #include "ext2fs/ext2_types.h"
> +#include "ext2fs/ext2fs.h"
> #include "ext2fs/fiemap.h"
> 
> /* A relatively new ioctl interface ... */
> @@ -111,13 +112,10 @@
> #define NGMSG_LOST_FOUND    "Can not process \"lost+found\""
> #define NGMSG_EXT_FORMAT    "File is not extent format"
> 
> -/* Data type for filesystem-wide blocks number */
> -typedef unsigned long long ext4_fsblk_t;
> -
> struct fiemap_extent_data {
>    __u64 len;            /* blocks count */
>    __u64 logical;        /* start logical block number */
> -    ext4_fsblk_t physical;        /* start physical block number */
> +    blk64_t physical;        /* start physical block number */
> };
> 
> struct fiemap_extent_list {
> @@ -461,9 +459,9 @@ static int defrag_fadvise(int fd, struct move_extent defrag_data,
>  * @file:        file name.
>  * @blk_count:        file blocks.
>  */
> -static int check_free_size(int fd, const char *file, ext4_fsblk_t blk_count)
> +static int check_free_size(int fd, const char *file, blk64_t blk_count)
> {
> -    ext4_fsblk_t    free_blk_count;
> +    blk64_t        free_blk_count;
>    struct statfs64    fsbuf;
>    uid_t        current_uid = getuid();
> 
> @@ -521,8 +519,7 @@ static int file_frag_count(int fd)
>  * @extents:        file extents.
>  * @blk_count:        file blocks.
>  */
> -static int file_check(int fd, const char *file, int extents,
> -                    ext4_fsblk_t blk_count)
> +static int file_check(int fd, const char *file, int extents, blk64_t blk_count)
> {
>    int    ret;
>    struct flock    lock;
> @@ -761,9 +758,9 @@ static int get_exts_count(struct fiemap_extent_list *ext_list_head)
>  *
>  * @ext_list_head:    the extent list head of the target file
>  */
> -static ext4_fsblk_t get_file_blocks(struct fiemap_extent_list *ext_list_head)
> +static blk64_t get_file_blocks(struct fiemap_extent_list *ext_list_head)
> {
> -    ext4_fsblk_t blk_count = 0;
> +    blk64_t blk_count = 0;
>    struct fiemap_extent_list *ext_list_tmp = ext_list_head;
> 
>    do {
> @@ -954,7 +951,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
>    int    file_frags_start, file_frags_end;
>    char    tmp_inode_name[PATH_MAX + 8];
>    size_t    threshold;
> -    ext4_fsblk_t            blk_count = 0;
> +    blk64_t                blk_count = 0;
>    struct fiemap_extent_list    *orig_list = NULL;
>    struct fiemap_extent_list    *donor_list = NULL;
>    struct fiemap_extent_group    *orig_group_head = NULL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
