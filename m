From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 04/27] ext2: Add ext2_sb_info mutex
Date: Mon, 2 Nov 2009 11:26:54 +0100
Message-ID: <20091102102654.GG31511@one.firstfloor.org>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-5-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754654AbZKBK0y@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1257156307-24175-5-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> @@ -762,6 +767,12 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	sbi->s_sb_block = sb_block;
>  
>  	/*
> +	 * mutex for protection of modifications of the superblock while being
> +	 * write out by ext2_write_super() or ext2_sync_fs().
> +	 */
> +	mutex_init(&sbi->s_mutex);

I didn't go over all the code paths in detail, but if you replace
the BKL with a mutex that is hold over a longer write-out sleep
period you potentially limit IO parallelism a lot.

In this case since the BKL didn't protect over the sleep anyways it might
be reasonable to drop it during the IO operation (and possibly if
you're sure nothing else sleeps use a spin lock)

-Andi
