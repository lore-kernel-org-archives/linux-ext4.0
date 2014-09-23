From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] misc/e4defrag: output extent's status(written or unwritten)
Date: Tue, 23 Sep 2014 21:02:06 +0200
Message-ID: <C0C311EB-9F6E-4F6D-8157-F81F8246B868@dilger.ca>
References: <1411468901-32210-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "<linux-ext4@vger.kernel.org>" <linux-ext4@vger.kernel.org>,
	"<tytso@mit.edu>" <tytso@mit.edu>,
	"<darrick.wong@oracle.com>" <darrick.wong@oracle.com>
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55199 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaIWUWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Sep 2014 16:22:08 -0400
Received: by mail-wi0-f169.google.com with SMTP id fb4so5340123wid.2
        for <linux-ext4@vger.kernel.org>; Tue, 23 Sep 2014 13:22:07 -0700 (PDT)
In-Reply-To: <1411468901-32210-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It would be nice if the output would match the format used by filefrag. 

Cheers, Andreas

> On Sep 23, 2014, at 12:41, Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com> wrote:
> 
> Before this patch, the output woulld be(e4defrag -c -v testfile):
> <File>
> [ext 1]:        start 33796:    logical 0:      len 1
> [ext 2]:        start 9267:     logical 1:      len 29
> [ext 3]:        start 9296:     logical 30:     len 1
> [ext 4]:        start 9297:     logical 31:     len 29
> [ext 5]:        start 9326:     logical 60:     len 1
> [ext 6]:        start 9327:     logical 61:     len 29
> ...
> [ext 32]:       start 9265:     logical 800:    len 1
> [ext 33]:       start 9266:     logical 900:    len 1
> 
> Total/best extents                             33/1
> Average size per extent                        61 KB
> Fragmentation score                            51
> [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
> This file (/mnt/xfstests/scratch/test.10) does not need defragmentation.
> Done.
> 
> After this patch, the output would be:
> <File>
> [ext 1]:   start 33796:    logical 0:      len 1   [written]
> [ext 2]:   start 9267:     logical 1:      len 29  [unwritten]
> [ext 3]:   start 9296:     logical 30:     len 1   [written]
> [ext 4]:   start 9297:     logical 31:     len 29  [unwritten]
> [ext 5]:   start 9326:     logical 60:     len 1   [written]
> [ext 6]:   start 9327:     logical 61:     len 29  [unwritten]
> ...
> [ext 32]:  start 9265:     logical 800:    len 1   [unwritten]
> [ext 33]:  start 9266:     logical 900:    len 1   [unwritten]
> 
> Total/best extents                             33/1
> Average size per extent                        61 KB
> Fragmentation score                            51
> [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
> This file (/mnt/xfstests/scratch/test.10) does not need defragmentation.
> Done.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> ---
> misc/e4defrag.c | 14 ++++++++++----
> 1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index d0eac60..b39e263 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -129,6 +129,7 @@ struct fiemap_extent_data {
>    __u64 len;            /* blocks count */
>    __u64 logical;        /* start logical block number */
>    ext4_fsblk_t physical;        /* start physical block number */
> +    __u32 fe_flags;        /* FIEMAP_EXTENT_* flags for this extent */
> };
> 
> struct fiemap_extent_list {
> @@ -831,6 +832,7 @@ static int get_file_extents(int fd, struct fiemap_extent_list **ext_list_head)
>                        / block_size;
>            ext_list->data.len = ext_buf[i].fe_length
>                        / block_size;
> +            ext_list->data.fe_flags = ext_buf[i].fe_flags;
> 
>            ret = insert_extent_by_physical(
>                    ext_list_head, ext_list);
> @@ -1170,12 +1172,16 @@ static int file_statistic(const char *file, const struct stat64 *buf,
> 
>            /* Print extents info */
>            do {
> +                char *status = ext_list_tmp->data.fe_flags &
> +                    FIEMAP_EXTENT_UNWRITTEN ?
> +                    "unwritten" : "written";
>                count++;
>                printf("[ext %d]:\tstart %llu:\tlogical "
> -                        "%llu:\tlen %llu\n", count,
> -                        ext_list_tmp->data.physical,
> -                        ext_list_tmp->data.logical,
> -                        ext_list_tmp->data.len);
> +                       "%llu:\tlen %llu \t[%s]\n", count,
> +                       ext_list_tmp->data.physical,
> +                       ext_list_tmp->data.logical,
> +                       ext_list_tmp->data.len,
> +                       status);
>                ext_list_tmp = ext_list_tmp->next;
>            } while (ext_list_tmp != logical_list_head);
> 
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
