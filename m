From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/7] ext4: completed_io locking cleanup
Date: Thu, 13 Sep 2012 18:48:05 +0800
Message-ID: <20120913104805.GD11330@gmail.com>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47507 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab2IMKhl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 06:37:41 -0400
Received: by pbbrr13 with SMTP id rr13so3743826pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 03:37:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1347211634-11509-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 09, 2012 at 09:27:09PM +0400, Dmitry Monakhov wrote:
> Current unwritten extent conversion state-machine is very fuzzy.
> - By unknown reason it want perform conversion under i_mutex. What for?
>   All this games with mutex_trylock result in following deadlock
>    truncate:                          kworker:
>     ext4_setattr                       ext4_end_io_work
>     mutex_lock(i_mutex)
>     inode_dio_wait(inode)  ->BLOCK
>                              DEADLOCK<- mutex_trylock()
>                                         inode_dio_done()
>   #TEST_CASE1_BEGIN
>   MNT=/mnt_scrach
>   unlink $MNT/file
>   fallocate -l $((1024*1024*1024)) $MNT/file
>   aio-stress -I 100000 -O -s 100m -n -t 1 -c 10 -o 2 -o 3 $MNT/file
>   sleep 2
>   truncate -s 0 $MNT/file
>   #TEST_CASE1_END
> 
> This patch makes state machine simple and clean:
> 
> (1) ext4_flush_completed_IO is responsible for handling all pending
>     end_io from ei->i_completed_io_list(per inode list)
>     NOTE1: i_completed_io_lock is acquired only once
>     NOTE2: i_mutex is not required because it does not protect
>            any data guarded by i_mutex
> 
> (2) xxx_end_io schedule end_io context completion simply by pushing it
>     to the inode's list.
>     NOTE1: because of (1) work should be queued only if
>     ->i_completed_io_list was empty at the moment, otherwise it
>     work is scheduled already.
> 
> - remove useless END_IO_XXX flags
> - Improve smp scalability by removing useless i_mutex which does not
>   protect anything
> - Reduce lock contention on i_completed_io_lock
> - Move open coded logic from various xx_end_xx routines to ext4_add_complete_io()
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Looks good to me.  You can add:
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
Zheng
