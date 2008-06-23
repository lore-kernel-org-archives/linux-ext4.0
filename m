From: Sami Liedes <sliedes@cc.hut.fi>
Subject: Re: [PATCH] ext3: handle corrupted orphan list at mount
Date: Tue, 24 Jun 2008 01:32:39 +0300
Message-ID: <20080623223238.GA8802@vipunen.hut.fi>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org> <1214258200-16623-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:49067 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbYFXANw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2008 20:13:52 -0400
Content-Disposition: inline
In-Reply-To: <1214258200-16623-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 23, 2008 at 10:56:40PM +0100, Duane Griffin wrote:
> If the orphan node list includes valid, untruncatable nodes with nlink > 0
> the ext3_orphan_cleanup loop which attempts to delete them will not do so,
> causing it to loop forever. Fix by checking for such nodes in the
> ext3_orphan_get function.

You people working hard to fix bugs and implement great filesystems
almost makes me feel bad for trying to break your code :)

> diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
> index 7712682..bc030f4 100644
> --- a/fs/ext3/ialloc.c
> +++ b/fs/ext3/ialloc.c
[...]
> @@ -690,6 +698,7 @@ bad_orphan:
>  		printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
>  		       NEXT_ORPHAN(inode));
>  		printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
> +		printk(KERN_NOTICE "i_nlink=%lu\n", inode->i_nlink);
					    ^^^

Here I get (on x86 gcc 4.3.1):

fs/ext3/ialloc.c: In function 'ext3_orphan_get':
fs/ext3/ialloc.c:701: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'

So it probably should be %u or something.

	Sami
