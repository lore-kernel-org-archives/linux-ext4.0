From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix off-by-one on max nr_pages in
 ext4_find_unwritten_pgoff()
Date: Tue, 23 May 2017 10:34:32 +0200
Message-ID: <20170523083432.GE1230@quack2.suse.cz>
References: <20170521080026.20986-1-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40520 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1759734AbdEWIee (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 23 May 2017 04:34:34 -0400
Content-Disposition: inline
In-Reply-To: <20170521080026.20986-1-eguan@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 21-05-17 16:00:26, Eryu Guan wrote:
> ext4_find_unwritten_pgoff() is used to search for offset of hole or
> data in page range [index, end] (both inclusive), and the max number
> of pages to search should be at least one, if end == index.
> Otherwise the only page is missed and no hole or data is found,
> which is not correct.
> 
> When block size is smaller than page size, this can be demonstrated
> by preallocating a file with size smaller than page size and writing
> data to the last block. E.g. run this xfs_io command on a 1k block
> size ext4 on x86_64 host.
> 
>   # xfs_io -fc "falloc 0 3k" -c "pwrite 2k 1k" \
>   	    -c "seek -d 0" /mnt/ext4/testfile
>   wrote 1024/1024 bytes at offset 2048
>   1 KiB, 1 ops; 0.0000 sec (42.459 MiB/sec and 43478.2609 ops/sec)
>   Whence  Result
>   DATA    EOF
> 
> Data at offset 2k was missed, and lseek(2) returned ENXIO.
> 
> This is unconvered by generic/285 subtest 07 and 08 on ppc64 host,
> where pagesize is 64k. Because a recent change to generic/285
> reduced the preallocated file size to smaller than 64k.
> 
> Cc: stable@vger.kernel.org # v3.7+
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Yeah, thanks for fixing this! Actually this is a bug introduced by my
recent fixes. Previously, 'end' used to be "one block after the end" and so
the math worked out correctly :-|. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 831fd6b..7b206e5 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -481,7 +481,7 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
>  		int i, num;
>  		unsigned long nr_pages;
>  
> -		num = min_t(pgoff_t, end - index, PAGEVEC_SIZE);
> +		num = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
>  		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
>  					  (pgoff_t)num);
>  		if (nr_pages == 0) {
> -- 
> 2.9.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
