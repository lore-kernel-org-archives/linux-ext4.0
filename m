Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ACC468C15
	for <linux-ext4@vger.kernel.org>; Mon,  7 Sep 2026 11:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788780227; cv=none; b=qwvPeT7bF+rZaXWLmewzlY3c09dZfaTjhmxdHInM9SRhnomhO7NF7JLzlJeyMQBKz14uZw5ySXJS1yRqfhyPUfpxku0yvVBXWMGAx13mqyhdUYNA9spXf8fYnaDVMppiZFlyPNGNaIKHUh0Gpr8HI6YItAhXnor+A2K5Bq4bOBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788780227; c=relaxed/simple;
	bh=tVe/V26RzsuNjlKJMy714hPyuVGIrjhD6enUGFbRWig=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K9vescl1whJRhe+8ezFbdnAyDB+WUAqrrR9Wo+cIaIiUo0vmXdWBoXcTGPJs1ZKYfSqRIiG1zTYweZN0f0HV4zba97KREx0Csei5joy4+7IpNlyz2f76rqnF4PKPWI89FwKz3aPJvUhP2jNHNSToEP+Qje8XiCY25X1ratbuXRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ws9rSB8T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ws9rSB8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464F11F00A3A;
	Mon,  7 Sep 2026 11:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788780223;
	bh=Atcifj7T8s78OUWQTPkJUdK9cCYfNDCyKJzT+Ri2OXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ws9rSB8TBlza2RH1GLgaiCWDqO//0BK7Iy0KAJWqFkmSdqgWnTUQdTKu0z/j9qsKt
	 BDhp3tKJpJaAxSCT11FlH0CvSRVkMXCRUZn816GEUzBX7lJVwkA0Vf7xLlL06FmtUm
	 A1Kg4d/r/K61O0Q16dZ8fcu4KD9HXmRsJQClkbRoB+6BSJMeckdv8KqSetB/+0Yuet
	 Lpa0kL/U6Fdm+TzzpWAs5rCee9DTzuMToVlOjMdw2eHV2GS+EN82bQTeFr8YNcgpPN
	 fcFHWulI4akcb0mtGZevb+SGA8halKpMqMNyyRE6ah5AWqx2PP82vPteVnaaUSO2Ty
	 fA3ZXc8vedKcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: move journal state away from orphan list
 updates
Reply-To: sashiko-reviews@lists.linux.dev
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <a33183c1c24ea47a98afdd4756b49365593a2762.1788779199.git.jonaszhou@zhaoxin.com>
References: <tf24u75hmpjhb2iqabyx6n3qur2kyda7vwz2eo5zcc2ek7utwp@m5sepatzqx2x>
 <a33183c1c24ea47a98afdd4756b49365593a2762.1788779199.git.jonaszhou@zhaoxin.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 11:23:42 +0000
Message-Id: <20260907112343.464F11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Concurrent sysfs writes to err_report_sec corrupt the timer list d=
ue to unnecessary timer_setup()
--

commit 5546001d405559aa5c5103006d23b436861ae874
Author: Jonas Zhou <jonaszhou@zhaoxin.com>
Subject: ext4: move journal state away from orphan list updates

This patch exchanges s_journal and s_ext4_flags with s_err_report_sec
and s_li_request in struct ext4_sb_info. This separates common journal
and flag readers from orphan-list writes to improve cache line usage
and avoid false sharing.

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 724a27e8be613..16ef010782331 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1641,9 +1641,13 @@ struct ext4_sb_info {
>  	struct super_block *s_sb;
>  	struct buffer_head *s_mmp_bh;
> =20
> +	/* timeout in seconds for s_err_report; 0 disables the timer. */
> +	unsigned long s_err_report_sec;
> +

[Severity: High]
This isn't a bug introduced by this patch, but while looking at the movement
of s_err_report_sec, I noticed a pre-existing issue in its sysfs store
handler.

Can concurrent writes to the err_report_sec sysfs file corrupt the timer li=
st?

Looking at err_report_sec_store() in fs/ext4/sysfs.c, it does not hold any
locks. If two threads concurrently write non-zero values when the current
value is 0:

Thread A
  if (!sbi->s_err_report_sec && t)
      timer_setup(&sbi->s_err_report, print_daily_error_info, 0);
  ...
  mod_timer(&sbi->s_err_report, ...);

Thread B
  if (!sbi->s_err_report_sec && t)
      timer_setup(&sbi->s_err_report, print_daily_error_info, 0);
  ...
  mod_timer(&sbi->s_err_report, ...);

Thread A arms the timer and puts it in the active timer wheel. Thread B then
calls timer_setup() which zeroes timer->entry.pprev. This makes Thread B's
subsequent mod_timer() re-insert the timer without detaching it, corrupting
the timer wheel's doubly-linked hlist.

Since the timer is already unconditionally initialized during filesystem
mount, and timer_delete_sync() doesn't deinitialize it, is this timer_setup=
()
call in the sysfs handler unnecessary?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/a33183c1c24ea47a98a=
fdd4756b49365593a2762.1788779199.git.jonaszhou@zhaoxin.com?part=3D1
