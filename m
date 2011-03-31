From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Thu, 31 Mar 2011 09:04:13 -0500
Message-ID: <4D9489DD.6080602@redhat.com>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>	<20110215160630.GH17313@quack.suse.cz>	<20110215170352.GE4255@thunk.org>	<20110215172954.GK17313@quack.suse.cz>	<20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com>	<20110216145627.GB5592@quack.suse.cz>	<4D5C9B1B.2050304@jp.fujitsu.com>	<20110217104552.GD4947@quack.suse.cz>	<20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>	<20110330141205.GC22349@quack.suse.cz> <AANLkTi=jTSEXsRJE+zzNvvTfFmqdAY42na8vm22NJefz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=jTSEXsRJE+zzNvvTfFmqdAY42na8vm22NJefz@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 3/31/11 3:37 AM, Yongqiang Yang wrote:

> in ext3, ext3_freeze() prevents journal from being updated by
> lock_journal_updates(), ext3_unfreeze() allow journal to be updated by
> unlock_journal_updates().
> 
> in ext4, however, before ext4_freeze() returns, it unlock journal, and
> ext4 prevents journal from being updated by s_frozen. s_frozen is in
> an upper layer, so it is out control of ext4 and deadlock is easy to
> happen.
> 
> Could someone explain why ext4 does like above but not follow ext3?
> 
> Yongqiang.

That was me, I think ...

commit 6b0310fbf087ad6e9e3b8392adca97cd77184084
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sun May 16 02:00:00 2010 -0400

    ext4: don't return to userspace after freezing the fs with a mutex held

    ext4_freeze() used jbd2_journal_lock_updates() which takes
    the j_barrier mutex, and then returns to userspace.  The
    kernel does not like this:

    ================================================
    [ BUG: lock held when returning to user space! ]
    ------------------------------------------------
    lvcreate/1075 is leaving the kernel with locks still held!
    1 lock held by lvcreate/1075:
     #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff811c6214>]
    jbd2_journal_lock_updates+0xe1/0xf0

    Use vfs_check_frozen() added to ext4_journal_start_sb() and
    ext4_force_commit() instead.

    Addresses-Red-Hat-Bugzilla: #568503


    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
