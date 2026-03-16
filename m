Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9008F285C88
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 23:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773704016; cv=none; b=m0UWq7L+1rHMQGpFQQ9v/Qfzn8iuZThICG9YmDkpHIo4D0DNEK6I1CodcM7ClK0OWMFQAp/DwaguQ7tRD9gfyufQ9EAmMcV0VO/PAU6adk2NWN+H5snF0jNP5iTfDyyOSPIl3cXt3F+bnsGu/IZdKJrtsr6GuRrEB18NT9FbLK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773704016; c=relaxed/simple;
	bh=GLiOJ3ea0dqUJ/DBDtvrZYtMtZO2KKHppe1CO9ScklA=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=Jrt02S+xbXJBpqoP0JEo9O+oDZ/uywq5PZviWQZ1ZiagHIUwIHdNR8fmJQni1k9aZ4Z5R1w9FKd3HFud8tnqYU0ds9ZL4T+ZTYjPvwHdG+6tQo9x/Gn8wYVzQMj6QMYt98FjIEiGNMYUJ1lPrq2a7UDh7u1oZzFFSyVr0tr5FKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JZ8aou4Z; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JZ8aou4Z"
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773704012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eEjaw4weOMm7+TpgzjprdXU6tH72jR+8fzJYaDZyTAs=;
	b=JZ8aou4ZFaW5s+6HCIysjSf4FlrvWHOrCq712wekVao4knLnAwT21vYDKl0ufCjeRowRvS
	ciftwVUtn1KP8Aq9wvTzfaDlz8+Izzhp9d1JddJ4hurtEcM/IC0XiAvzBgMKY446jDSZU/
	OrcyNi6nKK42VxR0aSAPpmHXrwq2Hdw=
Date: Mon, 16 Mar 2026 23:33:30 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Zqiang" <qiang.zhang@linux.dev>
Message-ID: <584a552d5b5cf7554f4a1c607e62f308436ff3eb@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] ext4: Fix possible NULL pointer dereference in
 ext4_group_desc_free()
To: "Baokun Li" <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com
In-Reply-To: <e275a80b-df14-4d05-9334-b10d2e57fbbc@linux.alibaba.com>
References: <20260316082025.9574-1-qiang.zhang@linux.dev>
 <e275a80b-df14-4d05-9334-b10d2e57fbbc@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT

>=20
>=20On 3/16/26 4:20 PM, Zqiang wrote:
>=20
>=20>=20
>=20> This can happen if the kvmalloc_objs() fails and sbi->s_group_desc =
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
>=20In ext4_group_desc_init(), s_gdb_count is only assigned after kvmallo=
c_array
> allocation succeeds. Therefore, when kvmalloc_array fails, the
> brelse(group_desc[i]) in ext4_group_desc_free() will not actually be
> executed,
> and thus this NULL pointer dereference issue will not be triggered.


Thanks for replay, got it, sorry for make noise.

Just then, I find that warning may be trigger:

the kvfree() is called in RCU read critical section, if
the sbi->s_group_desc pointer comes from vmalloc(),
the vfree() is called to release it, but the might_sleep()
is called in the vfree(), this may be trigger warnings in
rcu_sleep_check() when the enable CONFIG_DEBUG_ATOMIC_SLEEP.

May be use rcu_access_pointer() to access sbi->s_group_desc
is enough.

Thanks
Zqiang


>=20
>=20Cheers,
> Baokun
>=20
>=20>=20
>=20> - brelse(group_desc[i]);
> >  - kvfree(group_desc);
> >  + if (group_desc) {
> >  + for (i =3D 0; i < sbi->s_gdb_count; i++)
> >  + brelse(group_desc[i]);
> >  + kvfree(group_desc);
> >  + }
> >  rcu_read_unlock();
> >  }
> >
>
