From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Thu, 22 Mar 2012 10:53:42 +0100
Message-ID: <20120322095342.GC14485@quack.suse.cz>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 20-03-12 16:41:20, Artem Bityutskiy wrote:
> This patch-set makes ext4 independent of the VFS superblock management
> services. Namely, ext4 does not require to register the 'write_super()' VFS
> call-back.
> 
> The reason of this exercises is to get rid of the 'sync_supers()' kernel thread
> which wakes up every 5 seconds (by default) even if all superblocks are clean.
> This is wasteful from power management POW (unnecessary wake-ups).
> 
> Note, I tried to optimize 'sync_supers()' instead in 2010, but Al wanted me
> to get rid of it instead. See https://lkml.org/lkml/2010/6/6/87
> And I think this is right because many file-systems do not need this, for
> example btrfs does not use VFS superblock management services at all, so on a
> btrfs-based system we currently end-up useless periodic wake-ups source.
> 
> Changes for other file-systems are coming later.
> 
> The patch-set structure.
> 1. patches 1,2,3 are independent ext4 cleanups and I ask Ted to merge them as
>    soon/long as they are OK. I sent them also independently in order to get
>    early comments, but did not get so far, so re-sending.
> 2. patch 4 exports 'dirty_writeback_interval' and it would be very useful to
>    have it merged ASAP to simplify further work
> 3. patch 5 is also and independent VFS clean-up
> 4. patches 6-9 actually make ext4 independent on the 'sync_supers()' thread.
  Artem, if you look at places where ext4 sets s_dirt you will notice they
are rather rare events and all of them actually take care of writing
superblock themselves (at least if my memory serves well). So ext4
shouldn't need sync_supers() at all...

								Honza
