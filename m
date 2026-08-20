Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612BA3D3332;
	Thu, 20 Aug 2026 12:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787227980; cv=none; b=h7lPR3+/Cr0vzeuH8OKoo9+xmTAP92PKDzPaB6DshM6uKRmFk3CsuuGliLhKjbVdKPuevrLFu4fqXszFCpJvaNafsrgTBjXRuYMjPgB7LUlx0ARdPw8CMkPt2h8V0letl8z1bPlpQpLvj3lHUaeNL1jrgCYfTQ2XW/ClBGBRHTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787227980; c=relaxed/simple;
	bh=5Qtba8SWNI25D2cw00ROmV2pdRUvLXmQ5rmzKJbhORs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=u7j7JN2PeWOgmd6jeTIgYJVK+cPFzlolXai7z1yUaHF01I04DQ0Y+WiqBIS/qQhskMIXJrWKXguEAq8MWc2vKbX9nPvwuCNRjJIWdgfl68I7k2ma8NLyGEmosRKLDKRO+x3o1/J7rh3gZg4YWnbLgzDtFdk/ZuR87F9HhUYWjpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.97.62.103])
	by mtasvr (Coremail) with SMTP id _____wCHnnw674Zq_rmtAA--.5449S3;
	Thu, 20 Aug 2026 20:12:43 +0800 (CST)
Received: from smtpclient.apple (unknown [10.97.62.103])
	by mail-app1 (Coremail) with SMTP id yy_KCgDno5s674ZqHEIEBA--.8347S2;
	Thu, 20 Aug 2026 20:12:42 +0800 (CST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: [PATCH] ext4: fix discard work use-after-free on failed mount
From: Fan Wu <12321260@zju.edu.cn>
In-Reply-To: <ao3hudzjy2ljujygifsf7bcbffnfhp4uhxln3qkzdbszih3mjf@cqcopsdlkpnw>
Date: Thu, 20 Aug 2026 20:12:32 +0800
Cc: Fan Wu <fanwu01@zju.edu.cn>,
 tytso@mit.edu,
 adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com,
 ojaswin@linux.ibm.com,
 ritesh.list@gmail.com,
 yi.zhang@huawei.com,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <07DD13A9-C435-4F85-936A-1F587AE386D7@zju.edu.cn>
References: <20260820052102.4616-1-fanwu01@zju.edu.cn>
 <ao3hudzjy2ljujygifsf7bcbffnfhp4uhxln3qkzdbszih3mjf@cqcopsdlkpnw>
To: Jan Kara <jack@suse.cz>
X-Mailer: Apple Mail (2.3774.600.62)
X-CM-TRANSID:yy_KCgDno5s674ZqHEIEBA--.8347S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?5cHGgwXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnVCjTgEH9dVomQuWcozCBBHBveKz7IdZn/dIsL83LI4Y+NpLLomzr14EaNv0CGxYmGem
	BE6pmMLWy8OsxaK3qP8=
X-Coremail-Antispam: 1Uk129KBj93XoW7AF4rtF1fKFW8uF15uFykZwc_yoW8Jw4Dpr
	4rCw47K3yDZFWvy3ZFqw47WryIvr45KayrJryIgr1DC3y5Jw18ArW7tayFgFsxGrsYyw4j
	vw48Xw17GrWrZ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
	W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU85l1PUUUUU==

Hello, Jan

On 26-08-20 19:08, Jan Kara wrote:
> Yes, I think orphan replay is the easiest way how to have running
> transaction in the journal in this shutdown path.

Understood, thanks =E2=80=94 I'll describe the trigger in terms of =
orphan
replay in v2.

> I think failed_mount6 should just force the commit to flush out the
> running transaction before mballoc will be shut down and
> ext4_mb_release() can also use disable_work() after flush_work() to
> make sure no new s_discard_work can be queued as a safety measure.

Agreed =E2=80=94 keeping the journal shutdown at its existing point is =
safer.
I'll send a v2 that calls ext4_force_commit() at failed_mount6 before
ext4_mb_release(), and adds disable_work() after the existing
flush_work() in ext4_mb_release().

One detail I noticed while checking the ordering: jbd2 publishes
j_commit_sequence before invoking the commit callback, so
ext4_force_commit() can return before that callback has finished.  The
callback can therefore queue s_discard_work after flush_work() returns.
disable_work() cancels such a queued instance, but does not wait if it
has already started executing in that small window.  I have kept
disable_work() as you suggested; please let me know if you would prefer
disable_work_sync() for that case.

Thanks for the review!
Fan=

