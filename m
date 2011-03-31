From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due to
 a deadlock
Date: Thu, 31 Mar 2011 22:36:46 +0800
Message-ID: <AANLkTi=3HT-n4-4Q0RhWLGq0PSAgY68MPUa2zxU_uDY4@mail.gmail.com>
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
	<4D9489DD.6080602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48202 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993Ab1CaOgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Mar 2011 10:36:47 -0400
In-Reply-To: <4D9489DD.6080602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 31, 2011 at 10:04 PM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> On 3/31/11 3:37 AM, Yongqiang Yang wrote:
>
>> in ext3, ext3_freeze() prevents journal from being updated by
>> lock_journal_updates(), ext3_unfreeze() allow journal to be updated =
by
>> unlock_journal_updates().
>>
>> in ext4, however, before ext4_freeze() returns, it unlock journal, a=
nd
>> ext4 prevents journal from being updated by s_frozen. s_frozen is in
>> an upper layer, so it is out control of ext4 and deadlock is easy to
>> happen.
>>
>> Could someone explain why ext4 does like above but not follow ext3?
>>
>> Yongqiang.
>
> That was me, I think ...

Thank you, Eric.

I think ext4_journal_start() should check if current thread has an
active handle before  vfs_check_frozen(), if so, current handle will
be returned. Thus, we can avoid deadlocks.

Do you agree with me?  If I am right, I will send a patch.
>
> commit 6b0310fbf087ad6e9e3b8392adca97cd77184084
> Author: Eric Sandeen <sandeen@redhat.com>
> Date: =A0 Sun May 16 02:00:00 2010 -0400
>
> =A0 =A0ext4: don't return to userspace after freezing the fs with a m=
utex held
>
> =A0 =A0ext4_freeze() used jbd2_journal_lock_updates() which takes
> =A0 =A0the j_barrier mutex, and then returns to userspace. =A0The
> =A0 =A0kernel does not like this:
>
> =A0 =A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> =A0 =A0[ BUG: lock held when returning to user space! ]
> =A0 =A0------------------------------------------------
> =A0 =A0lvcreate/1075 is leaving the kernel with locks still held!
> =A0 =A01 lock held by lvcreate/1075:
> =A0 =A0 #0: =A0(&journal->j_barrier){+.+...}, at: [<ffffffff811c6214>=
]
> =A0 =A0jbd2_journal_lock_updates+0xe1/0xf0
>
> =A0 =A0Use vfs_check_frozen() added to ext4_journal_start_sb() and
> =A0 =A0ext4_force_commit() instead.
>
> =A0 =A0Addresses-Red-Hat-Bugzilla: #568503
>
>
> =A0 =A0Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> =A0 =A0Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
