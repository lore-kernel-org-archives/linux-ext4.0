From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due to
 a deadlock
Date: Thu, 31 Mar 2011 16:48:39 +0800
Message-ID: <AANLkTin52MfegV=r5=CaDmaVLT6xyH9LZ4MKr8SUaXpB@mail.gmail.com>
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
	<AANLkTi=jTSEXsRJE+zzNvvTfFmqdAY42na8vm22NJefz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38519 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab1CaIsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Mar 2011 04:48:40 -0400
In-Reply-To: <AANLkTi=jTSEXsRJE+zzNvvTfFmqdAY42na8vm22NJefz@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 31, 2011 at 4:37 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> Hi everyone,
>
> Amir met a deadlock when he tested ext4 with snapshot. =A0The deadloc=
k
> was reported on
> https://github.com/amir73il/ext4-snapshots/commit/56396185d922a73524a=
091b545e665543abf741a.
> =A0It is difficult to reproduce the deadlock. =A0There is a deadlock
> reported on http://www.spinics.net/lists/linux-ext4/msg23018.html.
> Actually, these two deadlocks come from a same source.
>
> Below are my analysis on the 1st one. =A0Mail is not a good place to
> describe parallel processes. =A0I have submitted the analysis to
> https://github.com/YANGYongqiang/ext4-snapshots/blob/9e0ae9ae9907125e=
6bf45aa91db296d4cc041b17/fs/ext4/BUGS#L143.
> =A0It is much more readable.
>
> -- deadlock in ext4 with snapshot
> =A0 =A0 =A0 ext4 with snapshot calls freeze_super() to bring
> =A0 =A0 =A0 a fs be in a clean state when a user takes a snapshot.
>
> =A0 =A0 freeze =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0truncate =A0 =A0 =A0=
 =A0 =A0 =A0 =A0kjournald
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0ext4_ext_truncate =A0 =A0=
 |
> =A0 =A0freeze_super() =A0| =A0 starts a handle =A0 =A0 =A0|
> =A0 =A0sets s_frozen =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0ext4_ext_truncate =A0 =A0=
 |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0holds i_data_sem =A0 =A0 =
=A0|
> =A0ext4_freeze() =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0| =A0 commit_transaction()
> =A0 wait for updates | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
| =A0 waits for i_data_sem
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0ext4_free_blocks =A0 =A0 =
=A0|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0calls dquot_free_block|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0dquot_free_block call |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0ext4_dirty_inode =A0 =A0 =
=A0|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0ext4_dirty_inode =A0 =A0 =
=A0|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0trys to start a handle|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0|
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0block due to s_frozen |
>
> in ext3, ext3_freeze() prevents journal from being updated by
> lock_journal_updates(), ext3_unfreeze() allow journal to be updated b=
y
> unlock_journal_updates().
>
> in ext4, however, before ext4_freeze() returns, it unlock journal, an=
d
> ext4 prevents journal from being updated by s_frozen. s_frozen is in
> an upper layer, so it is out control of ext4 and deadlock is easy to
> happen.

Virtually,  it is not right to block ext4_journal_start_sb() before we
confirm that current thread has no a active handle. But ext4 does like
that. Deadlock is thus easy to happen.   Right?

>
> Could someone explain why ext4 does like above but not follow ext3?
>
> Yongqiang.
> --
> Best Wishes
> Yongqiang Yang
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
