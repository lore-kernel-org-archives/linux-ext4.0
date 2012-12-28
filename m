From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH RESEND] vfs: re-implement
 writeback_inodes_sb(_nr)_if_idle() and rename them
Date: Fri, 28 Dec 2012 15:33:38 +0100
Message-ID: <20121228143338.GW14116@twin.jikos.cz>
References: <50D2E3DF.4010105@cn.fujitsu.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Kamal Mostafa <kamal@canonical.com>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50D2E3DF.4010105@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 20, 2012 at 06:09:35PM +0800, Miao Xie wrote:
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1314,7 +1314,6 @@ void writeback_inodes_sb_nr(struct super_block *sb,
>  	bdi_queue_work(sb->s_bdi, &work);
>  	wait_for_completion(&done);
>  }
> -EXPORT_SYMBOL(writeback_inodes_sb_nr);

Why do you remove the export? writeback_inodes_sb is exported as well.

Originally the _nr variant has been introduced for btrfs
(3259f8bed2f0f57c2fdcdac1b510c3fa319ef97e) and there are no other users
now, so from that point it would make sense. From the other side, the
change is not strictly necessary for this patch and keeps the writeback
API a bit more flexible. I vote for keeping it.

Otherwise (for the btrfs part),
Tested-by: David Sterba <dsterba@suse.cz>


thanks,
david
