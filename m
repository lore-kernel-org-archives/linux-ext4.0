From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Thu, 22 Mar 2012 11:33:09 +0100
Message-ID: <20120322103309.GA14484@quack.suse.cz>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <20120322095342.GC14485@quack.suse.cz>
 <1332410747.18717.12.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab2CVKdL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 06:33:11 -0400
Content-Disposition: inline
In-Reply-To: <1332410747.18717.12.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 22-03-12 12:05:47, Artem Bityutskiy wrote:
> On Thu, 2012-03-22 at 10:53 +0100, Jan Kara wrote:
> > On Tue 20-03-12 16:41:20, Artem Bityutskiy wrote:
> > > This patch-set makes ext4 independent of the VFS superblock management
> > > services. Namely, ext4 does not require to register the 'write_super()' VFS
> > > call-back.
> > > 
> > > The reason of this exercises is to get rid of the 'sync_supers()' kernel thread
> > > which wakes up every 5 seconds (by default) even if all superblocks are clean.
> > > This is wasteful from power management POW (unnecessary wake-ups).
> > > 
> > > Note, I tried to optimize 'sync_supers()' instead in 2010, but Al wanted me
> > > to get rid of it instead. See https://lkml.org/lkml/2010/6/6/87
> > > And I think this is right because many file-systems do not need this, for
> > > example btrfs does not use VFS superblock management services at all, so on a
> > > btrfs-based system we currently end-up useless periodic wake-ups source.
> > > 
> > > Changes for other file-systems are coming later.
> > > 
> > > The patch-set structure.
> > > 1. patches 1,2,3 are independent ext4 cleanups and I ask Ted to merge them as
> > >    soon/long as they are OK. I sent them also independently in order to get
> > >    early comments, but did not get so far, so re-sending.
> > > 2. patch 4 exports 'dirty_writeback_interval' and it would be very useful to
> > >    have it merged ASAP to simplify further work
> > > 3. patch 5 is also and independent VFS clean-up
> > > 4. patches 6-9 actually make ext4 independent on the 'sync_supers()' thread.
> >   Artem, if you look at places where ext4 sets s_dirt you will notice they
> > are rather rare events and all of them actually take care of writing
> > superblock themselves (at least if my memory serves well). So ext4
> > shouldn't need sync_supers() at all...
> 
> Hmm, if there is journal, then ext4 does not initialize the
> '->write_super()' VFS call-back and indeed takes care of the SB itself.
> Indeed. So 'sync_supers()' wakes up every 5 seconds for nothing.
  Yes.

> However, if there is _no_ journal, the 'write_super' is initialized, and
> in many places the 's_dirt' flag is set, and thus VFS services seem to
> be actively used.
  Which many places are you speaking about? Grep shows 4 places with
sb->s_dirt = 1;
  You remove two of those in your cleanups so only
__ext4_handle_dirty_super() remains. That is called from 3 (4 after your
cleanups) places and they happen so rarely (during filesystem resize or
when we start using some feature on the filesystem) that if you use
sync_buffer() from all of them, it should be fine.

  Then we have ext4_mark_super_dirty() call from 4 places - I forgot about
these originally... I kind of miss their purpose. Originally they were used
so that we write total number of free blocks and inodes in the superblock
but when we do not maintain them in the journal mode I don't see a reason
to periodically sync them in no-journal mode. Ted, what is the purpose of
these calls?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
