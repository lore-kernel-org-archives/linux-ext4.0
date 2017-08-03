From: Jan Kara <jack@suse.cz>
Subject: Re: quota: dqio_mutex design
Date: Thu, 3 Aug 2017 16:23:21 +0200
Message-ID: <20170803142321.GA23093@quack2.suse.cz>
References: <10928956.Fla3vXZ7d9@panda>
 <CAP9B-QnvPJTvh3b0igBOJm+i-kzWPLcKM0qiPb-sfLxztzJUaA@mail.gmail.com>
 <2768942.M4bvsTtnaB@panda>
 <8209641.NLfoyJy6gT@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Shilong <wangshilong1991@gmail.com>,
        Shuichi Ihara <sihara@ddn.com>,
        Wang Shilong <wshilong@ddn.com>, Li Xi <lixi@ddn.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
To: Andrew Perepechko <anserper@yandex.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751932AbdHCOXX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 3 Aug 2017 10:23:23 -0400
Content-Disposition: inline
In-Reply-To: <8209641.NLfoyJy6gT@panda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 03-08-17 16:55:40, Andrew Perepechko wrote:
> Let me put it this way:
> 
> Under file creation from different threads, ext4 will generate a series of
> dquot updates (incore and then ondisk, through journal):
> 
> dquot update1
> dquot update2
> dquot update3
> ...
> dquot updateN
> 
> Either with my patch or without it, ondisk dquot update through journal
> may miss dquot update1, dquot update2, ... dquot update{N-1}.
> 
> You can easily see that from the code of dquot_commit():
> 
> int dquot_commit(struct dquot *dquot)
> {
>         int ret = 0;
>         struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
> 
>         mutex_lock(&dqopt->dqio_mutex);
>         spin_lock(&dq_list_lock);
>         if (!clear_dquot_dirty(dquot)) {
>                 spin_unlock(&dq_list_lock);
>                 goto out_sem;
>         }
> ...
> }
> 
> 
> If actual dquot_commit() wrote dquot update N, the threads commiting
> updates 1 through N-1 will exit immediately once they get dqio_mutex
> since the dquot will NOT be dirty.
> 
> My patch only avoids blocking on dqio_mutex when we know for sure
> that another will NECESSARILY write the needed or a FRESHER dquot ondisk.

Yeah, I agree with Andrew. What they did is *almost* safe for ext4. The
only moment when it is not safe is when someone calls mark_dquot_dirty()
outside of a scope of a transaction which happens when doing Q_SETQUOTA
quotactl.

Another things which is subtle with Andrew's approach is that process
modifying quota information can return and stop its handle before quota
data gets copied to transaction buffer. This does not currently create any
real problem since nobody is relying on that however it relies on intimate
details of JBD2 transaction machinery and that could bite us in the future.

								Honza

> > > This change mean if this dquot is dirty we skip, this
> > > won't work because in this way, quota update is only kept in vfs dquota
> > > memory and newer update is not wrote to journal file and not wrapped into
> > > transaction too.
> > 
> > That's not true.
> > 
> > As I explained earlier, having DQ_MOD_B set at this point means another
> > thread is going to write dquot but hasn't yet started doing so. This thread
> > does not care whether it updates the ondisk dquot with its own data or with
> > fresher data which came from another thread. In-core dquot has no indication
> > of whose data in contains.
> > 
> > As I also explained earlier, the update cannot happen in the context of
> > another transaction because thread A which sees DQ_MOD_B set and thread
> > B which is running dquot_commit() both have journal handles to the same
> > transaction. There's only one running transaction at a time and thread B
> > does not switch to another transaction.
> > 
> > Please read the code carefully.
> > 
> > > This is not what journal quota means to do.
> > > 
> > > 
> > > Thanks,
> > > Shilong
> > > 
> > > > Thank you,
> > > > Andrew
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
