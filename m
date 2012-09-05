From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 1/2 RESEND] vfs: re-implement
 writeback_inodes_sb(_nr)_if_idle() and rename them
Date: Wed, 5 Sep 2012 17:54:04 +0200
Message-ID: <20120905155403.GL17430@twin.jikos.cz>
References: <503DB3E8.1000308@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>,
	viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Kamal Mostafa <kamal@canonical.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <503DB3E8.1000308@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 29, 2012 at 02:17:12PM +0800, Miao Xie wrote:
> writeback_inodes_sb(_nr)_if_idle() is re-implemented by replacing down_read()
> with down_read_trylock() because
> - If ->s_umount is write locked, then the sb is not idle. That is
>   writeback_inodes_sb(_nr)_if_idle() needn't wait for the lock.
> - writeback_inodes_sb(_nr)_if_idle() grabs s_umount lock when it want to start
>   writeback, it may bring us deadlock problem when doing umount.
>   (Ex. Btrfs has such a problem, see the following URL
>        http://marc.info/?l=linux-btrfs&m=133540923510561&w=2)
> 
> The name of these two functions is cumbersome, so rename them to
> try_to_writeback_inodes_sb(_nr).
> 
> This idea came from Christoph Hellwig.
> Some code is from the patch of Kamal Mostafa.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Tested-by: David Sterba <dsterba@suse.cz>

> ---
> Many users who use btrfs met the deadlock problem caused by writeback_inodes_sb(_nr)_if_idle(),
> so I send this patch again and hope it will be received as soon as possible if nobody objects.

Yes please, this makes testing of the 'autodefrag' mount option hard as
the deadlock occurs frequently upon umount (when there's a background
snapshot cleanup in progress).

>From the user's POV, the autodefrag improves performance, it's not yet
on by default until it proves to be stable, the deadlocks were standing
in the way for long.

thanks,
david
