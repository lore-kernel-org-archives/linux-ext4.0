From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] ext2: skip pages past number of blocks in
 ext2_find_entry
Date: Thu, 21 Dec 2006 11:05:49 -0800
Message-ID: <20061221110549.bf336c02.randy.dunlap@oracle.com>
References: <458AD954.7020904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1423034AbWLUTGm@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <458AD954.7020904@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 21 Dec 2006 12:58:28 -0600 Eric Sandeen wrote:

> This one was pointed out on the MOKB site:
> http://kernelfun.blogspot.com/2006/11/mokb-09-11-2006-linux-26x-ext2checkpage.html
> 
> If a directory's i_size is corrupted, ext2_find_entry() will keep processing
> pages until the i_size is reached, even if there are no more blocks associated
> with the directory inode.  This patch puts in some minimal sanity-checking
> so that we don't keep checking pages (and issuing errors) if we know there
> can be no more data to read, based on the block count of the directory inode.
> 
> This is somewhat similar in approach to the ext3 patch I sent earlier this
> year.
> 
> Thanks,
> 
> -Eric
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Index: linux-2.6.19/fs/ext2/dir.c
> ===================================================================
> --- linux-2.6.19.orig/fs/ext2/dir.c
> +++ linux-2.6.19/fs/ext2/dir.c
> @@ -368,6 +368,14 @@ struct ext2_dir_entry_2 * ext2_find_entr
>  		}
>  		if (++n >= npages)
>  			n = 0;
> +		/* next page is past the blocks we've got */
> +		if (unlikely(n > (dir->i_blocks >> (PAGE_CACHE_SHIFT - 9)))) {
> +			ext2_error(dir->i_sb, __FUNCTION__,
> +				"dir %lu size %lld exceeds block count %llu",
> +				dir->i_ino, dir->i_size,
> +				(unsigned long long)dir->i_blocks);
> +				goto out;

Please don't hide the goto; un-indent 1 tab stop.

> +		}
>  	} while (n != start);
>  out:
>  	return NULL;


---
~Randy
