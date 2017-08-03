From: Andrew Perepechko <anserper@yandex.ru>
Subject: Re: quota: dqio_mutex design
Date: Thu, 03 Aug 2017 16:55:40 +0300
Message-ID: <8209641.NLfoyJy6gT@panda>
References: <10928956.Fla3vXZ7d9@panda> <CAP9B-QnvPJTvh3b0igBOJm+i-kzWPLcKM0qiPb-sfLxztzJUaA@mail.gmail.com> <2768942.M4bvsTtnaB@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Shuichi Ihara <sihara@ddn.com>, Wang Shilong <wshilong@ddn.com>,
        Li Xi <lixi@ddn.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward2m.cmail.yandex.net ([5.255.216.20]:36759 "EHLO
        forward2m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751010AbdHCN5j (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Aug 2017 09:57:39 -0400
In-Reply-To: <2768942.M4bvsTtnaB@panda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Let me put it this way:

Under file creation from different threads, ext4 will generate a series of
dquot updates (incore and then ondisk, through journal):

dquot update1
dquot update2
dquot update3
...
dquot updateN

Either with my patch or without it, ondisk dquot update through journal
may miss dquot update1, dquot update2, ... dquot update{N-1}.

You can easily see that from the code of dquot_commit():

int dquot_commit(struct dquot *dquot)
{
        int ret = 0;
        struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);

        mutex_lock(&dqopt->dqio_mutex);
        spin_lock(&dq_list_lock);
        if (!clear_dquot_dirty(dquot)) {
                spin_unlock(&dq_list_lock);
                goto out_sem;
        }
...
}


If actual dquot_commit() wrote dquot update N, the threads commiting
updates 1 through N-1 will exit immediately once they get dqio_mutex
since the dquot will NOT be dirty.

My patch only avoids blocking on dqio_mutex when we know for sure
that another will NECESSARILY write the needed or a FRESHER dquot ondisk.

> > This change mean if this dquot is dirty we skip, this
> > won't work because in this way, quota update is only kept in vfs dquota
> > memory and newer update is not wrote to journal file and not wrapped into
> > transaction too.
> 
> That's not true.
> 
> As I explained earlier, having DQ_MOD_B set at this point means another
> thread is going to write dquot but hasn't yet started doing so. This thread
> does not care whether it updates the ondisk dquot with its own data or with
> fresher data which came from another thread. In-core dquot has no indication
> of whose data in contains.
> 
> As I also explained earlier, the update cannot happen in the context of
> another transaction because thread A which sees DQ_MOD_B set and thread
> B which is running dquot_commit() both have journal handles to the same
> transaction. There's only one running transaction at a time and thread B
> does not switch to another transaction.
> 
> Please read the code carefully.
> 
> > This is not what journal quota means to do.
> > 
> > 
> > Thanks,
> > Shilong
> > 
> > > Thank you,
> > > Andrew
