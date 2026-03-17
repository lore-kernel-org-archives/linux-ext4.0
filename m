Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4DF3C3BF0
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 13:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773753823; cv=none; b=m7gNEZVejUADA8F5+4x5Nu66j7KPMObi9FEfe2PcxvDQm2seffH5Y11U9RBjf0AISjGU9eN0hSJ3iZTL1R/VNPtK4k9XBpHeAmcqjf8Uk4yeeD6xvisMekvtxDdSABFShdM+A4OqlFHqr8bv/Sd+NJlFFz+WZLfb3X9IQU7ULNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773753823; c=relaxed/simple;
	bh=zRqYwsaQjbzPweFVZG7Vcc6xFgnJ2dJVGg4RTxCL8JQ=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=kVawwRv6FeQr7y+nhEygS5toteI/p69bwDCeEPNuqQe7haMYFojlv2yisbTR/sh1AZxmhB2EbdKzRSEXP17a0iVi1d+UFCjI/zpRflDL4P/aL7X/ynuRQtSe7BWZi6Mudk9VsvtKY5O85gGpxkafpd+bhtOEdNBWBdVlpgye+AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n/yKCdNv; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n/yKCdNv"
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773753819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eLE1bO1sAFW/aIxrF7164qd1+c52VLlR0z0r7oduuZA=;
	b=n/yKCdNvIQ0+SEBMvAPggeQeyBMC8mkqJVVOsQI0kzX1i3oBX/gTZi9jL8oeJ0cLpAmWkE
	h7EhBKGYRAhs4a5u6gV4A+xHO03O190dKADcJfvfvZHjUv9da5ijqdvjs+Bsn6Znx/e/7j
	UZn88kGbqxDRADo44xgZOg2iSfR6kTw=
Date: Tue, 17 Mar 2026 13:23:32 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Zqiang" <qiang.zhang@linux.dev>
Message-ID: <5b06137188083d93a6938a0c94d23a57c6ec8db3@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] ext4: Fix possible NULL pointer dereference in
 ext4_group_desc_free()
To: "Baokun Li" <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com
In-Reply-To: <5e747089-7fc8-4230-b9e2-65e479fcebab@linux.alibaba.com>
References: <20260316082025.9574-1-qiang.zhang@linux.dev>
 <e275a80b-df14-4d05-9334-b10d2e57fbbc@linux.alibaba.com>
 <584a552d5b5cf7554f4a1c607e62f308436ff3eb@linux.dev>
 <5e747089-7fc8-4230-b9e2-65e479fcebab@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT

>=20
>=20On 3/17/26 7:33 AM, Zqiang wrote:
>=20
>=20>=20
>=20> >=20
>=20> > On 3/16/26 4:20 PM, Zqiang wrote:
> > >=20
>=20>  This can happen if the kvmalloc_objs() fails and sbi->s_group_desc=
 pointer
> >  is NULL in the ext4_group_desc_init(), and then the ext4_group_desc_=
free()
> >  is called, leading to a NULL group_desc pointer dereference.
> >=20
>=20>  This commit therefore adds a NULL check for sbi->s_group_desc befo=
re
> >  accessing its internal members.
> >=20
>=20>  Signed-off-by: Zqiang <qiang.zhang@linux.dev>
> >  ---
> >  fs/ext4/super.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >=20
>=20>  diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >  index 43f680c750ae..c4307dc04687 100644
> >  --- a/fs/ext4/super.c
> >  +++ b/fs/ext4/super.c
> >  @@ -1256,9 +1256,11 @@ static void ext4_group_desc_free(struct ext4_=
sb_info *sbi)
> >=20=20
>=20>  rcu_read_lock();
> >  group_desc =3D rcu_dereference(sbi->s_group_desc);
> >  - for (i =3D 0; i < sbi->s_gdb_count; i++)
> >=20
>=20> >=20
>=20> > In ext4_group_desc_init(), s_gdb_count is only assigned after kvm=
alloc_array
> > >  allocation succeeds. Therefore, when kvmalloc_array fails, the
> > >  brelse(group_desc[i]) in ext4_group_desc_free() will not actually =
be
> > >  executed,
> > >  and thus this NULL pointer dereference issue will not be triggered=
.
> > >=20
>=20>  Thanks for replay, got it, sorry for make noise.
> >=20
>=20>  Just then, I find that warning may be trigger:
> >=20
>=20>  the kvfree() is called in RCU read critical section, if
> >  the sbi->s_group_desc pointer comes from vmalloc(),
> >  the vfree() is called to release it, but the might_sleep()
> >  is called in the vfree(), this may be trigger warnings in
> >  rcu_sleep_check() when the enable CONFIG_DEBUG_ATOMIC_SLEEP.
> >=20
>=20Indeed, vfree triggers the following warning: ```
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> EXT4-fs (vdc): unmounting filesystem
> c478da00-c52c-4dd4-81c1-d4f93e12ab50. BUG: sleeping function called fro=
m
> invalid context at mm/vmalloc.c:3441 in_atomic(): 0, irqs_disabled(): 0=
,
> non_block: 0, pid: 457, name: umount preempt_count: 0, expected: 0 RCU
> nest depth: 1, expected: 0 CPU: 0 UID: 0 PID: 457 Comm: umount Tainted:
> G W 6.19.0-rc4-g4f5e8e6f0123-dirty #10 PREEMPT(none) Tainted: [W]=3DWAR=
N
> Call Trace: <TASK> dump_stack_lvl+0x55/0x70 __might_resched+0x116/0x160
> vfree+0x38/0x60 ext4_put_super+0x1ac/0x490
> generic_shutdown_super+0x81/0x180 kill_block_super+0x1a/0x40
> ext4_kill_sb+0x22/0x40 deactivate_locked_super+0x35/0xb0
> cleanup_mnt+0x101/0x170 task_work_run+0x5c/0xa0
> exit_to_user_mode_loop+0xe2/0x460 do_syscall_64+0x1de/0x1f0
> entry_SYSCALL_64_after_hwframe+0x76/0x7e


This can also actually happen, depending on your kernel configuration:
 CONFIG_PREEMPT_NONE=3Dy=20
=20CONFIG_PROVE_RCU=3Dy
 CONFIG_DEBUG_ATOMIC_SLEEP=3Dy
 CONFIG_PREEMPT_RCU=3Dn
 CONFIG_PREEMPT_COUNT=3Dy
 CONFIG_DEBUG_PREEMPT=3Dy


./include/linux/rcupdate.h:409 Illegal context switch in RCU read-side cr=
itical section!

other info that might help us debug this:

rcu_scheduler_active =3D 2, debug_locks =3D 1
2 locks held by umount/555:
 #0: ffff88800da680e8 (&type->s_umount_key#29){++++}-{4:4}, at: deactivat=
e_super+0x76/0xa0
 #1: ffffffff86a0e580 (rcu_read_lock){....}-{1:3}, at: ext4_group_desc_fr=
ee+0x27/0x270

Call Trace:
 <TASK>
 dump_stack_lvl+0xbb/0xd0
 dump_stack+0x14/0x20
 lockdep_rcu_suspicious+0x15a/0x1b0
 __might_resched+0x375/0x4d0
 ? put_object.part.0+0x2c/0x50
 __might_sleep+0x108/0x160
 vfree+0x58/0x910
 ? ext4_group_desc_free+0x27/0x270
 kvfree+0x23/0x40
 ext4_group_desc_free+0x111/0x270
 ext4_put_super+0x3c8/0xd40
 generic_shutdown_super+0x14c/0x4a0
 ? __pfx_shrinker_free+0x10/0x10
 kill_block_super+0x40/0x90
 ext4_kill_sb+0x6d/0xb0
 deactivate_locked_super+0xb4/0x180
 deactivate_super+0x7e/0xa0
 cleanup_mnt+0x296/0x3e0
 __cleanup_mnt+0x16/0x20
 task_work_run+0x157/0x250
 ? __pfx_task_work_run+0x10/0x10
 ? exit_to_user_mode_loop+0x6a/0x550
 exit_to_user_mode_loop+0x102/0x550
 do_syscall_64+0x44a/0x500
 entry_SYSCALL_64_after_hwframe+0x77/0x7f



> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> ``` And ext4_mb_init_backend, ext4_mb_release, ext4_flex_groups_free
> have similar issues.Indeed, vfree triggers the following warning:
>=20
>=20=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> EXT4-fs (vdc): unmounting filesystem c478da00-c52c-4dd4-81c1-d4f93e12ab=
50.
> BUG: sleeping function called from invalid context at mm/vmalloc.c:3441
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 457, name: umoun=
t
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> CPU: 0 UID: 0 PID: 457 Comm: umount Tainted: G W
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A06.19.0-rc4-g4f5e=
8e6f0123-dirty #10 PREEMPT(none)
> Tainted: [W]=3DWARN
> Call Trace:
> =C2=A0<TASK>
> =C2=A0dump_stack_lvl+0x55/0x70
> =C2=A0__might_resched+0x116/0x160
> =C2=A0vfree+0x38/0x60
> =C2=A0ext4_put_super+0x1ac/0x490
> =C2=A0generic_shutdown_super+0x81/0x180
> =C2=A0kill_block_super+0x1a/0x40
> =C2=A0ext4_kill_sb+0x22/0x40
> =C2=A0deactivate_locked_super+0x35/0xb0
> =C2=A0cleanup_mnt+0x101/0x170
> =C2=A0task_work_run+0x5c/0xa0
> =C2=A0exit_to_user_mode_loop+0xe2/0x460
> =C2=A0do_syscall_64+0x1de/0x1f0
> =C2=A0entry_SYSCALL_64_after_hwframe+0x76/0x7e
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>=20
>=20And ext4_mb_init_backend, ext4_mb_release, ext4_flex_groups_free have
> similar issues.
>=20
>=20>=20
>=20> May be use rcu_access_pointer() to access sbi->s_group_desc
> >  is enough.
> >=20
>=20Yes, these are all initialization or teardown paths and cannot run
> concurrently with
> online resize, so using rcu_access_pointer() seems sufficient.

Will make a patch and CC you :)

>=20
>=20Also, should we add might_sleep() to kvfree() to prevent similar issu=
es?

I think it makes sense.

Thanks
Zqiang

>=20
>=20Cheers,
> Baokun
>
