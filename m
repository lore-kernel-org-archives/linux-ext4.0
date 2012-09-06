From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 4/4] ext4: serialize truncate with owerwrite DIO workers
Date: Thu, 06 Sep 2012 14:07:25 +0400
Message-ID: <87sjav79cy.fsf@openvz.org>
References: <1346780214-29845-1-git-send-email-dmonakhov@openvz.org> <1346780214-29845-4-git-send-email-dmonakhov@openvz.org> <20120905154920.GF18051@quack.suse.cz> <87y5ko76ea.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46358 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2IFKH2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Sep 2012 06:07:28 -0400
Received: by lbbgj3 with SMTP id gj3so1011559lbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 06 Sep 2012 03:07:27 -0700 (PDT)
In-Reply-To: <87y5ko76ea.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 05 Sep 2012 20:59:09 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> On Wed, 5 Sep 2012 17:49:20 +0200, Jan Kara <jack@suse.cz> wrote:
> > On Tue 04-09-12 21:36:54, Dmitry Monakhov wrote:
> > > Jan Kara have spotted interesting issue:
> > > There are  potential data corruption issue with  direct IO overwrites
> > > racing with truncate:
> > >  Like:
> > >   dio write                      truncate_task
> > >   ->ext4_ext_direct_IO
> > >    ->overwrite == 1
> > >     ->down_read(&EXT4_I(inode)->i_data_sem);
> > >     ->mutex_unlock(&inode->i_mutex);
> > >                                ->ext4_setattr()
> > >                                 ->inode_dio_wait()
> > >                                 ->truncate_setsize()
> > >                                 ->ext4_truncate()
> > >                                  ->down_write(&EXT4_I(inode)->i_data_sem);
> > >     ->__blockdev_direct_IO
> > >      ->ext4_get_block
> > >      ->submit_io()
> > >     ->up_read(&EXT4_I(inode)->i_data_sem);
> > >                                  # truncate data blocks, allocate them to
> > >                                  # other inode - bad stuff happens because
> > >                                  # dio is still in flight.
> > > 
> > > In order to serialize with truncate dio worker should grab extra i_dio_count
> > > reference before drop i_mutex.
> >   Thanks for the patch. You can add:
> > Reviewed-by: Jan Kara <jack@suse.cz>
> I'm Sorry, but unfortunately in two line patch i've done one mistake :( 
> because inode_dio_done() should be before i_mutex will be retaken
> otherwise following deadlock happen
> 
> ext4_setattr                       ext4_direct_io
>                                    mutex_unlock
>                                    atomic_inc(inode->i_dio_count)
>   mutex_lock(i_mutex)
>   inode_dio_wait(inode)  ->BLOCK
>                         DEADLOCK<- mutex_lock(i_mutex)
>                                    inode_dio_done()
Yeah... This is not just my fault :)
Similar deadlock already exist but happen due to end_io_work

truncate:                          kworker:
ext4_setattr                       ext4_end_io_work
                                    

   mutex_lock(i_mutex)
   inode_dio_wait(inode)  ->BLOCK
                         DEADLOCK<- mutex_trylock()
                                    inode_dio_done()
#TEST_CASE
MNT=/mnt_scrach
unlink $MNT/file
fallocate -l $((1024*1024*1024)) $MNT/file
aio-stress -I 100000 -O -s 100m -n -t 1 -c 10 -o 2 -o 3 $MNT/file &
sleep 3
truncate -s 0 $MNT/file
#TEST_CASE_END


> 
> So i'll add your review sing to updated version if you don't mind.
> > 								Honza
> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > > ---
> > >  fs/ext4/inode.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index 5a75908..9725acb 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -3035,6 +3035,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
> > >  		overwrite = *((int *)iocb->private);
> > >  
> > >  		if (overwrite) {
> > > +			atomic_inc(&inode->i_dio_count);
> > >  			down_read(&EXT4_I(inode)->i_data_sem);
> > >  			mutex_unlock(&inode->i_mutex);
> > >  		}
> > > @@ -3134,6 +3135,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
> > >  		if (overwrite) {
> > >  			up_read(&EXT4_I(inode)->i_data_sem);
> > >  			mutex_lock(&inode->i_mutex);
> > > +			inode_dio_done(inode);
> > >  		}
> > >  
> > >  		return ret;
> > > -- 
> > > 1.7.7.6
> > > 
> > -- 
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
