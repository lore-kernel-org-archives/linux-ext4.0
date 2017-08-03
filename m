From: Andrew Perepechko <anserper@yandex.ru>
Subject: Re: quota: dqio_mutex design
Date: Thu, 03 Aug 2017 16:41:38 +0300
Message-ID: <2768942.M4bvsTtnaB@panda>
References: <10928956.Fla3vXZ7d9@panda> <8584759.E72qcEIvA1@panda> <CAP9B-QnvPJTvh3b0igBOJm+i-kzWPLcKM0qiPb-sfLxztzJUaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Shuichi Ihara <sihara@ddn.com>, Wang Shilong <wshilong@ddn.com>,
        Li Xi <lixi@ddn.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAP9B-QnvPJTvh3b0igBOJm+i-kzWPLcKM0qiPb-sfLxztzJUaA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> 
> This change mean if this dquot is dirty we skip, this
> won't work because in this way, quota update is only kept in vfs dquota
> memory and newer update is not wrote to journal file and not wrapped into
> transaction too.

That's not true.

As I explained earlier, having DQ_MOD_B set at this point means another
thread is going to write dquot but hasn't yet started doing so. This thread
does not care whether it updates the ondisk dquot with its own data or with
fresher data which came from another thread. In-core dquot has no indication
of whose data in contains.

As I also explained earlier, the update cannot happen in the context of
another transaction because thread A which sees DQ_MOD_B set and thread
B which is running dquot_commit() both have journal handles to the same
transaction. There's only one running transaction at a time and thread B does
not switch to another transaction.

Please read the code carefully.


> 
> This is not what journal quota means to do.
> 
> 
> Thanks,
> Shilong
> 
> > Thank you,
> > Andrew
