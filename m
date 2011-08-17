From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 11/12] e4defrag: Fix error messages more clearly
Date: Wed, 17 Aug 2011 10:37:15 -0600
Message-ID: <AB5E90E9-336E-4F39-BFA5-1F68497D7B26@dilger.ca>
References: <4E4B7235.3040605@sx.jp.nec.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:35857 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab1HQQgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 12:36:39 -0400
In-Reply-To: <4E4B7235.3040605@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-17, at 1:48 AM, Kazuya Mio <k-mio@sx.jp.nec.com> wrote:
> There are some error messages we don't really understand what happens.
> This patch fixes those messages.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---
> misc/e4defrag.c |   39 +++++++++++++++++++++------------------
> 1 file changed, 21 insertions(+), 18 deletions(-)
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index ec1b15a..df532d3 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -323,6 +323,7 @@ static int is_ext4(const char *file)
> 
>        mnt_type = realloc(mnt_type, strlen(mnt->mnt_type) + 1);
>        if (mnt_type == NULL) {
> +            perror("Failed to allocate memory");
>            endmntent(fp);
>            return -1;
>        }
> @@ -727,11 +728,9 @@ static int get_file_extents(int fd, struct fiemap_extent_list **ext_list_head)
>        !(ext_buf[EXTENT_MAX_COUNT-1].fe_flags
>                    & FIEMAP_EXTENT_LAST));
> 
> -    FREE(fiemap_buf);
> -    return 0;
> out:
>    FREE(fiemap_buf);
> -    return -1;
> +    return errno ? -1 : 0;
> }
> 
> /*
> @@ -873,7 +872,7 @@ static int call_defrag(int fd, int donor_fd, const char *file,
>            if (mode_flag & DETAIL) {
>                printf("\n");
>                PRINT_ERR_MSG_WITH_ERRNO(
> -                    "Failed to free page");
> +                    "Failed to synchronize the file");
>            } else {
>                printf("\t[ NG ]\n");
>            }
> @@ -971,15 +970,6 @@ static int file_defrag(const char *file, const struct stat64 *buf,
>        return 0;
>    }
> 
> -    /* Has no blocks */
> -    if (buf->st_blocks == 0) {
> -        if (mode_flag & DETAIL) {
> -            PRINT_FILE_NAME(file);
> -            IN_FTW_PRINT_ERR_MSG("File has no blocks");
> -        }
> -        return 0;
> -    }

I think it still makes sense to skip defrag if the file has no blocks. Depending on FIEMAP is dangerous if the file is being modified, and just adds overhead. 

>    fd = open64(file, O_RDWR);
>    if (fd < 0) {
>        if (mode_flag & DETAIL) {
> @@ -997,6 +987,12 @@ static int file_defrag(const char *file, const struct stat64 *buf,
>            PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
>        }
>        goto out;
> +    } else if (orig_list == NULL) {
> +        if (mode_flag & DETAIL) {
> +            PRINT_FILE_NAME(file);
> +            IN_FTW_PRINT_ERR_MSG("File has no blocks");
> +        }
> +        goto out;
>    }
> 
>    /* Count file fragments before defrag */
> @@ -1089,6 +1085,12 @@ static int file_defrag(const char *file, const struct stat64 *buf,
>            PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
>        }
>        goto out;
> +    } else if (donor_list == NULL) {
> +        if (mode_flag & DETAIL) {
> +            PRINT_FILE_NAME(file);
> +            IN_FTW_PRINT_ERR_MSG("Temporary file was removed");
> +        }
> +        goto out;
>    }
> 
>    donor_score = e2p_get_fragscore(donor_fd, threshold,
> @@ -1136,7 +1138,7 @@ check_improvement:
>        file_frags_end = file_frag_count(fd);
>        if (file_frags_end < 0) {
>            printf("\n");
> -            PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_INFO);
> +            PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
>            goto out;
>        }
> 
> @@ -1282,10 +1284,7 @@ int main(int argc, char *argv[])
>        }
> 
>        switch (arg_type) {
> -        case DIRNAME:
> -            printf("ext4 defragmentation for directory(%s)\n",
> -                    argv[i]);
> -
> +        case DIRNAME: {
>            int mount_dir_len = 0;
>            mount_dir_len = strnlen(lost_found_dir, PATH_MAX);
> 
> @@ -1313,6 +1312,10 @@ int main(int argc, char *argv[])
>                /* "e4defrag mount_piont_dir/else_dir" */
>                memset(lost_found_dir, 0, PATH_MAX + 1);
>            }
> +
> +            printf("ext4 defragmentation for directory(%s)\n",
> +                    argv[i]);
> +        }
>        case DEVNAME:
>            if (arg_type == DEVNAME) {
>                strncpy(lost_found_dir, dir_name,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
