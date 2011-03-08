From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: potential memory leak on transaction commit
Date: Tue, 8 Mar 2011 17:13:31 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103081713030.2167@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.02.1103081849430.6414@zhanghuan.nrchpc.ac.cn> <alpine.LFD.2.00.1103081331200.31811@dhcp-27-109.brq.redhat.com> <alpine.OSX.2.00.1103082241230.58225@zhanghuan.mc371>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Zhang Huan <zhhuan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab1CHQNf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Mar 2011 11:13:35 -0500
In-Reply-To: <alpine.OSX.2.00.1103082241230.58225@zhanghuan.mc371>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 8 Mar 2011, Zhang Huan wrote:

> 
> On Tue, 8 Mar 2011, Lukas Czerner wrote:
> 
> > On Tue, 8 Mar 2011, Zhang Huan wrote:
> > 
> > > Hi all,
> > > 
> > > There is potential memory leak of journal head in function
> > > jbd2_journal_commit_transaction. The problem is that JBD2 will not
> > > reclaim the journal head of commit record if error occurs or journal is
> > > abotred.
> > > 
> > > I use the following script to reproduce this issue, on a RHEL6 system. I
> > > found it very easy to reproduce with async commit enabled.
> > > 
> > > mount /dev/sdb /mnt -o journal_checksum,journal_async_commit
> > > touch /mnt/xxx
> > > echo offline > /sys/block/sdb/device/state
> > > sync
> > > umount /mnt
> > > rmmod ext4
> > > rmmod jbd2
> > > 
> > > Removal of the jbd2 module will make slab complaining that
> > > "cache `jbd2_journal_head': can't free all objects".
> > > 
> > > 
> > > Here is my fix for this issue. The commit record should be reclaimed no
> > > matter error occurs or not.
> > > 
> > > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > > index f3ad159..37a973a 100644
> > > --- a/fs/jbd2/commit.c
> > > +++ b/fs/jbd2/commit.c
> > > @@ -105,6 +105,8 @@ static int journal_submit_commit_record(journal_t
> > > *journal,
> > >  	int ret;
> > >  	struct timespec now = current_kernel_time();
> > > 
> > > +	*cbh = NULL;
> > > +
> > >  	if (is_journal_aborted(journal))
> > >  		return 0;
> > > 
> > > @@ -808,7 +810,7 @@ wait_for_iobuf:
> > >  		if (err)
> > >  			__jbd2_journal_abort_hard(journal);
> > >  	}
> > > -	if (!err && !is_journal_aborted(journal))
> > > +	if (cbh)
> > 
> > Hi,
> > 
> > I wonder if we could do rather this:
> > 
> > 	if (!err && !is_journal_aborted(journal))
> > 		err = journal_wait_on_commit_record(journal, cbh);
> > 	else if (cbh) {
> > 		put_bh(cbh);
> > 		jbd2_journal_put_journal_head(bh2jh(cbh));
> > 	}
> > 
> > I think this is more readable...
> 
> Hi,
> 
> I don't think it is a good idea. Anyway, you need to wait for buffer to
> complete, and then release journal head on it. That is exactly what
> journal_wait_on_commit_record does.

Oh, I see. Ok then ignore me :)

Thanks!
-Lukas

> 
> > 
> > Thanks!
> > -Lukas
> > 
> > >  		err = journal_wait_on_commit_record(journal, cbh);
> > >  	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
> > >  				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
> > > 
> > > 
> > > 
> > > PS: Just out of curiosity, why would journal_submit_commit_record return a
> > > value of 1 instead of an error number if get descriptor buffer is failed.
> > > 
> > > 
> > > Zhang Huan
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > -- 
> > 
> 
> Zhang Huan
> 

-- 
