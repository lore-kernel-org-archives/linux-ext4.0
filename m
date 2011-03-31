From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due to
 a deadlock
Date: Thu, 31 Mar 2011 16:37:27 +0800
Message-ID: <AANLkTi=jTSEXsRJE+zzNvvTfFmqdAY42na8vm22NJefz@mail.gmail.com>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>
	<20110215160630.GH17313@quack.suse.cz>
	<20110215170352.GE4255@thunk.org>
	<20110215172954.GK17313@quack.suse.cz>
	<20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com>
	<20110216145627.GB5592@quack.suse.cz>
	<4D5C9B1B.2050304@jp.fujitsu.com>
	<20110217104552.GD4947@quack.suse.cz>
	<20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
	<20110330141205.GC22349@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110330141205.GC22349@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi everyone,

Amir met a deadlock when he tested ext4 with snapshot.  The deadlock
was reported on
https://github.com/amir73il/ext4-snapshots/commit/56396185d922a73524a091b545e665543abf741a.
 It is difficult to reproduce the deadlock.  There is a deadlock
reported on http://www.spinics.net/lists/linux-ext4/msg23018.html.
Actually, these two deadlocks come from a same source.

Below are my analysis on the 1st one.  Mail is not a good place to
describe parallel processes.  I have submitted the analysis to
https://github.com/YANGYongqiang/ext4-snapshots/blob/9e0ae9ae9907125e6bf45aa91db296d4cc041b17/fs/ext4/BUGS#L143.
 It is much more readable.

-- deadlock in ext4 with snapshot
       ext4 with snapshot calls freeze_super() to bring
       a fs be in a clean state when a user takes a snapshot.

     freeze                  truncate              kjournald

                    |  ext4_ext_truncate     |
    freeze_super()  |   starts a handle      |
    sets s_frozen   |                        |
                    |  ext4_ext_truncate     |
                    |  holds i_data_sem      |
  ext4_freeze()     |                        |   commit_transaction()
   wait for updates |                        |   waits for i_data_sem
                    |  ext4_free_blocks      |
                    |  calls dquot_free_block|
                    |                        |
                    |  dquot_free_block call |
                    |  ext4_dirty_inode      |
                    |                        |
                    |  ext4_dirty_inode      |
                    |  trys to start a handle|
                    |                        |
                    |  block due to s_frozen |

in ext3, ext3_freeze() prevents journal from being updated by
lock_journal_updates(), ext3_unfreeze() allow journal to be updated by
unlock_journal_updates().

in ext4, however, before ext4_freeze() returns, it unlock journal, and
ext4 prevents journal from being updated by s_frozen. s_frozen is in
an upper layer, so it is out control of ext4 and deadlock is easy to
happen.

Could someone explain why ext4 does like above but not follow ext3?

Yongqiang.
-- 
Best Wishes
Yongqiang Yang
