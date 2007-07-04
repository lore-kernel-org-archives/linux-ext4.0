From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] ext4: fix error handling in ext4_create_journal
Date: Thu, 5 Jul 2007 00:17:25 +0400
Message-ID: <20070704201725.GA5812@martell.zuzino.mipt.ru>
References: <20070701221111.GA8627@gollum.tnic> <20070703152543.e58ad39a.akpm@linux-foundation.org> <20070704193024.GA6802@gollum.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Borislav Petkov <bbpetkov@yahoo.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758926AbXGDURm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070704193024.GA6802@gollum.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 04, 2007 at 09:30:24PM +0200, Borislav Petkov wrote:
> Fix error handling in ext4_create_journal according to kernel conventions.

> --- linux-2.6.22-rc7/fs/ext4/super.c.orig
> +++ linux-2.6.22-rc7/fs/ext4/super.c
> @@ -2150,6 +2150,7 @@
>  			       unsigned int journal_inum)
>  {
>  	journal_t *journal;
> +	int err;
>  
>  	if (sb->s_flags & MS_RDONLY) {
>  		printk(KERN_ERR "EXT4-fs: readonly filesystem when trying to "
> @@ -2157,13 +2158,15 @@
>  		return -EROFS;
>  	}
>  
> -	if (!(journal = ext4_get_journal(sb, journal_inum)))
> +	journal = ext4_get_journal(sb, journal_inum);
> +	if (!journal)
>  		return -EINVAL;

OK.

>  	printk(KERN_INFO "EXT4-fs: creating new journal on inode %u\n",
>  	       journal_inum);
>  
> -	if (jbd2_journal_create(journal)) {
> +	err = jbd2_journal_create(journal);
> +	if (err) {
>  		printk(KERN_ERR "EXT4-fs: error creating journal.\n");
>  		jbd2_journal_destroy(journal);
>  		return -EIO;

Original code is fine.
