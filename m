From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/7] ext4: completed_io locking cleanup
Date: Mon, 10 Sep 2012 14:19:52 +0400
Message-ID: <87ehmagoxj.fsf@openvz.org>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org> <1347211634-11509-3-git-send-email-dmonakhov@openvz.org> <20120910092312.GD22903@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34834 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2IJKTz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Sep 2012 06:19:55 -0400
Received: by lbbgj3 with SMTP id gj3so1060560lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2012 03:19:53 -0700 (PDT)
In-Reply-To: <20120910092312.GD22903@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 10 Sep 2012 11:23:12 +0200, Jan Kara <jack@suse.cz> wrote:
> On Sun 09-09-12 21:27:09, Dmitry Monakhov wrote:
> > Current unwritten extent conversion state-machine is very fuzzy.
> > - By unknown reason it want perform conversion under i_mutex. What for?
> >   All this games with mutex_trylock result in following deadlock
> >    truncate:                          kworker:
> >     ext4_setattr                       ext4_end_io_work
> >     mutex_lock(i_mutex)
> >     inode_dio_wait(inode)  ->BLOCK
> >                              DEADLOCK<- mutex_trylock()
> >                                         inode_dio_done()
> >   #TEST_CASE1_BEGIN
> >   MNT=/mnt_scrach
> >   unlink $MNT/file
> >   fallocate -l $((1024*1024*1024)) $MNT/file
> >   aio-stress -I 100000 -O -s 100m -n -t 1 -c 10 -o 2 -o 3 $MNT/file
> >   sleep 2
> >   truncate -s 0 $MNT/file
> >   #TEST_CASE1_END
> > 
> > This patch makes state machine simple and clean:
> > 
> > (1) ext4_flush_completed_IO is responsible for handling all pending
> >     end_io from ei->i_completed_io_list(per inode list)
> >     NOTE1: i_completed_io_lock is acquired only once
> >     NOTE2: i_mutex is not required because it does not protect
> >            any data guarded by i_mutex
>   Removing of i_mutex might be OK but you really need to add more
> justification (both into the changelog and end_io code) than just "it does
> not protect any data guarded by i_mutex". So far i_mutex is supposed to
> protect all modifications of extent tree, now that won't be true anymore.
> We have i_data_sem protecting extent tree as well but that is acquired for
> single extent operation only so it cannot be used for guarding "global
> properties of the extent tree" - e.g. if end_io code would race with
> truncate it could happen that end_io would create some extents beyond EOF.
> Now maybe that cannot happen because of other synchronization mechanisms
> (e.g. inode_dio_wait(), or waiting for PageWriteback while invalidating
> page cache - although extra care needs to be taken when extents straddle
> i_size and there can be IO running on the part of the extent before
> i_size). So I don't immediaetly see a problem but please add more
> justification to convince me (and future readers of the code) here...
Ok you right. Actually I've already tried to figure out correct BUG_ON
condition to spot extent beyond EOF, but this condition is not trivial
and need justification. My current assumption:
  Since EXT4_GET_BLOCKS_UNINIT_EXT is used only then file size is not 
  changed it seems to be correct to prohibit
  ext4_convert_unwritten_extents() to handle blocks beyond
  EXT4_I(inode)->i_disksize (inode->i_size is not suitable here
  because truncate may already reduce it, and now wait for existing dio)

As a naive word in my defence i should say that blocks beyond EOF issue easily
triggered on current kernel via xfstests, but not happen w/ my patch-queue. 
