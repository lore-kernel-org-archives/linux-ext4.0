From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: lockdep warnings - possible circular locking
Date: Tue, 30 Aug 2011 17:35:42 +0800
Message-ID: <CABqxG0fTD+Yiv_w72FKZKZZp2FJze28F3K8AOg-5PTgY4Vb1tg@mail.gmail.com>
References: <CABqxG0e6EXfDUEeno6e70Orgye+0EGq6x7qsFJ2q8Og3vt+aiA@mail.gmail.com>
	<4E5CAD18.1020907@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55216 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1H3Jfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 05:35:43 -0400
In-Reply-To: <4E5CAD18.1020907@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 30, 2011 at 5:27 PM, Tao Ma <tm@tao.ma> wrote:
> Hi Dave,
> On 08/30/2011 05:09 PM, Dave Young wrote:
>> Hi,
>>
>> I got following lockdep warnings, ext4 related?
> This is already reported by many guys. Ted has a fix for it.
> Please search the mail with subject
> [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
>

Thanks for tell, will try

> Thanks
> Tao
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>> [11038.258992] [ INFO: possible circular locking dependency detected=
 ]
>> [11038.258996] 3.1.0-rc3-00283-gc11a7e2 #264
>> [11038.258998] -----------------------------------------------------=
--
>> [11038.259002] soffice.bin/3022 is trying to acquire lock:
>> [11038.259005] =C2=A0(&sb->s_type->i_mutex_key#4){+.+.+.}, at:
>> [<ffffffff811836d3>] ext4_evict_inode+0x4a/0x2ff
>> [11038.259019]
>> [11038.259020] but task is already holding lock:
>> [11038.259024] =C2=A0(&group->notification_mutex){+.+...}, at:
>> [<ffffffff8112f838>] fsnotify_flush_notify+0x22/0x115
>> [11038.259034]
>> [11038.259034] which lock already depends on the new lock.
>> [11038.259036]
>> [11038.259039]
>> [11038.259039] the existing dependency chain (in reverse order) is:
>> [11038.259043]
>> [11038.259044] -> #1 (&group->notification_mutex){+.+...}:
>> [11038.259051] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8106c21d>] lock_=
acquire+0xd9/0x105
>> [11038.259057] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81532ac2>] _raw_=
spin_lock+0x2c/0x38
>> [11038.259064] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff810f72fa>] __sla=
b_alloc+0x105/0x374
>> [11038.259070] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff810f7fd6>] kmem_=
cache_alloc+0x82/0xf1
>> [11038.259075] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81112c34>] __d_a=
lloc+0x24/0x16e
>> [11038.259081] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81112de9>] d_all=
oc+0x1c/0x7e
>> [11038.259086] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81112ead>] d_all=
oc_name+0x62/0x64
>> [11038.259092] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8115fb06>] devpt=
s_pty_new+0x16a/0x207
>> [11038.259098] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff813015b6>] ptmx_=
open+0xac/0x106
>> [11038.259104] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81103983>] chrde=
v_open+0x138/0x157
>> [11038.259110] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff810fee11>] __den=
try_open+0x1af/0x2bd
>> [11038.259116] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff810fefd5>] namei=
data_to_filp+0x53/0x62
>> [11038.259122] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8110c449>] do_la=
st+0x491/0x590
>> [11038.259128] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8110c615>] path_=
openat+0xcd/0x345
>> [11038.259134] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8110c982>] do_fi=
lp_open+0x38/0x86
>> [11038.259139] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff810feb1d>] do_sy=
s_open+0x6c/0xf6
>> [11038.259145] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff810febd0>] sys_o=
pen+0x1b/0x1d
>> [11038.259150] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81539b52>] syste=
m_call_fastpath+0x16/0x1b
>> [11038.259157]
>> [11038.259158] -> #0 (&sb->s_type->i_mutex_key#4){+.+.+.}:
>> [11038.259165] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8106ba31>] __loc=
k_acquire+0xb78/0xe95
>> [11038.259172] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8106c21d>] lock_=
acquire+0xd9/0x105
>> [11038.259177] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81531c7a>] __mut=
ex_lock_common+0x48/0x355
>> [11038.259183] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81532030>] mutex=
_lock_nested+0x26/0x2b
>> [11038.259188] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811836d3>] ext4_=
evict_inode+0x4a/0x2ff
>> [11038.259194] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81115133>] evict=
+0xa7/0x163
>> [11038.259199] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811153be>] iput+=
0x1cf/0x1d7
>> [11038.259204] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811130d5>] dentr=
y_kill+0x174/0x192
>> [11038.259209] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81113a73>] dput+=
0x103/0x113
>> [11038.259214] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8110937c>] path_=
put+0x15/0x21
>> [11038.259220] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8112f6fe>] fsnot=
ify_put_event+0x53/0x90
>> [11038.259230] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8112f8f7>] fsnot=
ify_flush_notify+0xe1/0x115
>> [11038.259233] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8112fc27>]
>> fsnotify_final_destroy_group+0x11/0x2f
>> [11038.259236] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8112fc82>] fsnot=
ify_put_group+0x3d/0x43
>> [11038.259239] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8113157b>] inoti=
fy_release+0x48/0x4e
>> [11038.259242] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81101721>] fput+=
0x10b/0x1a8
>> [11038.259245] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff810fe98b>] filp_=
close+0x6d/0x78
>> [11038.259248] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8103cd4c>] put_f=
iles_struct+0xa9/0x141
>> [11038.259252] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8103ce2b>] exit_=
files+0x47/0x50
>> [11038.259254] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8103e7f7>] do_ex=
it+0x281/0x7b1
>> [11038.259257] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8103eda6>] do_gr=
oup_exit+0x7f/0xab
>> [11038.259260] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8103ede4>] sys_e=
xit_group+0x12/0x16
>> [11038.259263] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81539b52>] syste=
m_call_fastpath+0x16/0x1b
>> [11038.259266]
>> [11038.259266] other info that might help us debug this:
>> [11038.259267]
>> [11038.259269] =C2=A0Possible unsafe locking scenario:
>> [11038.259269]
>> [11038.259271] =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU1
>> [11038.259272] =C2=A0 =C2=A0 =C2=A0 =C2=A0---- =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0----
>> [11038.259273] =C2=A0 lock(&group->notification_mutex);
>> [11038.259276] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lock(&sb->s_typ=
e->i_mutex_key);
>> [11038.259279] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lock(&group->no=
tification_mutex);
>> [11038.259282] =C2=A0 lock(&sb->s_type->i_mutex_key);
>> [11038.259284]
>> [11038.259284] =C2=A0*** DEADLOCK ***
>> [11038.259285]
>> [11038.259287] 1 lock held by soffice.bin/3022:
>> [11038.259288] =C2=A0#0: =C2=A0(&group->notification_mutex){+.+...},=
 at:
>> [<ffffffff8112f838>] fsnotify_flush_notify+0x22/0x115
>> [11038.259294]
>> [11038.259294] stack backtrace:
>> [11038.259297] Pid: 3022, comm: soffice.bin Not tainted
>> 3.1.0-rc3-00283-gc11a7e2 #264
>> [11038.259299] Call Trace:
>> [11038.259302] =C2=A0[<ffffffff8106aea8>] print_circular_bug+0x20e/0=
x21f
>> [11038.259305] =C2=A0[<ffffffff8106ba31>] __lock_acquire+0xb78/0xe95
>> [11038.259309] =C2=A0[<ffffffff8106c21d>] lock_acquire+0xd9/0x105
>> [11038.259312] =C2=A0[<ffffffff811836d3>] ? ext4_evict_inode+0x4a/0x=
2ff
>> [11038.259315] =C2=A0[<ffffffff81531c7a>] __mutex_lock_common+0x48/0=
x355
>> [11038.259318] =C2=A0[<ffffffff811836d3>] ? ext4_evict_inode+0x4a/0x=
2ff
>> [11038.259321] =C2=A0[<ffffffff811836d3>] ? ext4_evict_inode+0x4a/0x=
2ff
>> [11038.259324] =C2=A0[<ffffffff81532030>] mutex_lock_nested+0x26/0x2=
b
>> [11038.259326] =C2=A0[<ffffffff811836d3>] ext4_evict_inode+0x4a/0x2f=
f
>> [11038.259329] =C2=A0[<ffffffff81115133>] evict+0xa7/0x163
>> [11038.259332] =C2=A0[<ffffffff811153be>] iput+0x1cf/0x1d7
>> [11038.259335] =C2=A0[<ffffffff811130d5>] dentry_kill+0x174/0x192
>> [11038.259338] =C2=A0[<ffffffff81113a73>] dput+0x103/0x113
>> [11038.259340] =C2=A0[<ffffffff8110937c>] path_put+0x15/0x21
>> [11038.259343] =C2=A0[<ffffffff8112f6fe>] fsnotify_put_event+0x53/0x=
90
>> [11038.259346] =C2=A0[<ffffffff8112f8f7>] fsnotify_flush_notify+0xe1=
/0x115
>> [11038.259349] =C2=A0[<ffffffff81531ade>] ? mutex_unlock+0x9/0xb
>> [11038.259352] =C2=A0[<ffffffff8112fc27>] fsnotify_final_destroy_gro=
up+0x11/0x2f
>> [11038.259355] =C2=A0[<ffffffff8112fc82>] fsnotify_put_group+0x3d/0x=
43
>> [11038.259357] =C2=A0[<ffffffff8113157b>] inotify_release+0x48/0x4e
>> [11038.259360] =C2=A0[<ffffffff81101721>] fput+0x10b/0x1a8
>> [11038.259363] =C2=A0[<ffffffff810fe98b>] filp_close+0x6d/0x78
>> [11038.259366] =C2=A0[<ffffffff8103cd4c>] put_files_struct+0xa9/0x14=
1
>> [11038.259368] =C2=A0[<ffffffff8103ccc5>] ? put_files_struct+0x22/0x=
141
>> [11038.259372] =C2=A0[<ffffffff81291a55>] ? do_raw_spin_unlock+0x8f/=
0x96
>> [11038.259375] =C2=A0[<ffffffff8103ce2b>] exit_files+0x47/0x50
>> [11038.259378] =C2=A0[<ffffffff8103e7f7>] do_exit+0x281/0x7b1
>> [11038.259380] =C2=A0[<ffffffff8103eda6>] do_group_exit+0x7f/0xab
>> [11038.259383] =C2=A0[<ffffffff8103ede4>] sys_exit_group+0x12/0x16
>> [11038.259386] =C2=A0[<ffffffff81539b52>] system_call_fastpath+0x16/=
0x1b
>>
>
>



--=20
Regards
Yang RuiRui
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
