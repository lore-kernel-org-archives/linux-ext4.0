From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH V2] vfs: re-implement writeback_inodes_sb(_nr)_if_idle()
 and rename them
Date: Sat, 12 Jan 2013 10:54:01 +0800
Message-ID: <20130112025401.GA8948@localhost>
References: <50D2E3DF.4010105@cn.fujitsu.com>
 <20121228143338.GW14116@twin.jikos.cz>
 <50EE560D.6040604@cn.fujitsu.com>
 <20130111201211.GA20981@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, dsterba@suse.cz,
	Christoph Hellwig <hch@infradead.org>,
	Kamal Mostafa <kamal@canonical.com>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130111201211.GA20981@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 11, 2013 at 09:12:11PM +0100, Jan Kara wrote:
> On Thu 10-01-13 13:47:57, Miao Xie wrote:
> > writeback_inodes_sb(_nr)_if_idle() is re-implemented by replacing down_read()
> > with down_read_trylock() because
> > - If ->s_umount is write locked, then the sb is not idle. That is
> >   writeback_inodes_sb(_nr)_if_idle() needn't wait for the lock.
> > - writeback_inodes_sb(_nr)_if_idle() grabs s_umount lock when it want to start
> >   writeback, it may bring us deadlock problem when doing umount. In order to
> >   fix the problem, ext4 and btrfs implemented their own writeback functions
> >   instead of writeback_inodes_sb(_nr)_if_idle(), but it introduced the redundant
> >   code, it is better to implement a new writeback_inodes_sb(_nr)_if_idle().
> > 
> > The name of these two functions is cumbersome, so rename them to
> > try_to_writeback_inodes_sb(_nr).
> > 
> > This idea came from Christoph Hellwig.
> > Some code is from the patch of Kamal Mostafa.
>   The patch looks good. Thanks! You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
>   BTW, since changes to filesystems are minimal, maybe Fengguang can take
> the patch through his writeback tree? Fengguang?

OK, done. The patch looks good, thanks!

Fengguang
