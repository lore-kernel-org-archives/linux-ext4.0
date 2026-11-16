Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847326;
	b=dlC97m1ERB7Ud1mG6Yxm1miEhnZrCDGsEeWdssJ4k6PrueYET9s8P831i81jk2/aAqxN
	 ou5obuwRVdy9Y6NpsyYK1nFWCDSdbVDC5iN6KcT86yUT1c8HFStwAM0gRmZ7euCC0DvEC
	 GxEO8eCZlWsbMl1omk9YEZ1voLYMh7i7w/b0xjx15vx4ZzzX9gxd+2SwqH31W1K/eHeWf
	 eoQBUJsRGXMOmlFsS+OiybOEIjTdHWFGajwfH/uP29Vclvr+er2xyLt7m1Jd3aQ/cD41z
	 rumiUflAmtuxkJ1wGubwIMy/x2jQEEAGfWrxq9EtZGyxBKSSmqTO/o/i9JYIrqJ28Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847326;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=r8TUoai3Uj7HxGiIV2+FAEKe5ZUbHPmsq4P7S5/sIf0=;
	b=ojfdOSU7x0EdlqRydx0IW3lGRi+pNY3tGK2r9WUyJlGlCgU7SWRbBqIAxvb2AKasKw0g
	 v1buWqWqBpW0oNLKVEPz0fHaD6QpraXT+9qzpZefrajHTN+a9hM9CVqlwXbYxX1yHmEEW
	 a8q7RL3uUb7Ys+Y3KXlo965+EKG1dWhYDpFWwdmdVWiPpz9k6PIqIMCyVQA6DyHc5+9JV
	 nxuw1HOKsDGFtbZcGfPwYfsBhSOzjNnTagofLbGBzWQBGA7wka7HzMgbLFleXtLT1DI0d
	 Laxp6QHU9JbLMqd28n4y6H+A42IU8yljsvSHLWZ5n7e467DLYibrzlQrGT3djxk9gGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OJFAblBt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BD1606A32F
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 16:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OJFAblBt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9021F000C4;
	Mon, 16 Nov 2026 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794847326;
	bh=r8TUoai3Uj7HxGiIV2+FAEKe5ZUbHPmsq4P7S5/sIf0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OJFAblBtbEssP4dxx9JrOhWlZn9Y/zOCABp7kt9H5Z0/llU4FezEo2QGI2MLHt+ue
	 JfP+UnVQMR09UGBYKcaefGBDE3mK8s9w+CdbtpThaJX8zecNZXCn8ST+1aPYNbhT1R
	 E1D8nfdO5zsUpz1PafJqRvhDWbow597v8pr9GtYe6OrLEoza0MeRebyDij+0Y8g3cy
	 WY2LTqjtBlktyeCEJLH3MnrVbG+NpbSnrRSQiiqoPHNvKbDPqFY/f7vXYYM7+U43GF
	 utisTho6bSySbSKb6SONLP0ZFXWkPjbJ+0gmEW+kiA8TqQTg7VE4+8l+hmx2a3vKze
	 /TESNmmgCpXjw==
Message-ID: <sashiko-outbox-217372@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: use a stable source for the kmmpd thread name
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <da634961-1d13-4d21-b181-f366fd72e0d1@bytedance.com>
References: <20261114172523.5888-1-zhaogongyi@bytedance.com>
 <qz2gh5bbbyqjqfqclatkq34pgxnvbu3ey5kf3octnlykstzhx2@s65dxum2wdso>
 <da634961-1d13-4d21-b181-f366fd72e0d1@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 16:42:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] lib/kasprintf: reproducer-only msleep(1000) delay committed in
  kvasprintf()
- [High] ext4: missing Signed-off-by trailer in commit message
- [Medium] ext4: commit title and raw email reply body do not match code
  changes
--

commit d8ecd786cfd0874e564c2e769446a7a6d1cd1f7f
Author: Zhao Gongyi <zhaogongyi@bytedance.com>

> ext4: use a stable source for the kmmpd thread name
>
> Hi Jan,
>
> On 11/16/26 8:16 PM, Jan Kara wrote:
> > What can change it? I don't see anything that should be doing that...
>
> A concurrent buffered write to the loop block device can change it. In
> one diagnostic run, the write reached the page-cache buffer ext4 was
> using for MMP. mmp_bdevname is embedded at bh->b_data + 0x50.
>
> In an x86 QEMU diagnostic run based on commit
> 7475ea8b58616b33c04afb976cf0fbaad9dd63fb, kvasprintf() first read
> "loop0" at ffff888013e1d050. A kprobe on mark_buffer_dirty() then
> fired for a buffer starting at ffff888013e1d000, covering that field.
> The stack was:
>
>    ksys_write -> blkdev_write_iter -> blkdev_buffered_write
>      -> iomap_file_buffered_write -> iomap_write_end
>      -> block_write_end -> block_commit_write -> mark_buffer_dirty
>
> The buffered write path copies data into the page cache before
> block_commit_write(). About one second later, the same source page
> contained an empty string, and kvasprintf() reported return values 11
> and 6. The kprobe records the buffer being dirtied; it does not trap
> the byte-copy instruction itself. My earlier description of a
> concurrent MMP mount changing the name was imprecise.
>
> The original syzkaller manager report shows the warning on an
> unmodified kernel. Standalone QEMU replays without a delay did not hit
> it reliably. To obtain the trace above, I used a diagnostic build with
> a one-second delay after the first vsnprintf() pass, source snapshots,
> an exported MMP buffer address, and a kprobe module. The attached
> test-only delay patch widens the window but does not collect the writer
> trace by itself. None of this diagnostic code is part of the proposed fix.
>
> The attached repro.syz is input to syz-execprog. I ran it in the guest wi=
th:
>
>    /root/syz-execprog -executor=3D/root/syz-executor -arch=3Damd64 \
>      -sandbox=3Dnone -procs=3D12 -repeat=3D0 -threaded=3Dtrue -slowdown=
=3D1 \
>      -sandbox_arg=3D0 -type=3Dqemu /root/repro.syz
>
> I understand that raw writes to a block device during ext4 access can
> corrupt metadata. The proposed change gives the two-pass thread-name
> formatting a stable source; it does not change MMP's protection logic.
> I can provide the full diagnostic diff, kprobe module, and console log
> if useful.
>
> Thanks,
> Gongyi
>
> This is a reproducer-only delay patch for validating:
>
>         WARNING in __kthread_create_on_node
>         different return values (11 and 6) from vsnprintf("kmmpd-%.*s", .=
..)
>
> The first delay patch only matched "kmmpd-%.*s".  That made the A side
> easy to reproduce, but after applying the fix the B side uses
> "kmmpd-%s" and therefore did not hit the same artificial kvasprintf()
> delay window.
>
> Delay both old and fixed kmmpd thread-name formats after kvasprintf()'s
> first vsnprintf() pass.  With this patch, A verifies that the original
> buffer-backed string can change during the widened window, while B uses
> the same widened kvasprintf() window but passes the fixed stack-backed
> string source.
>
> Do not use this patch as a fix and do not ship it outside validation.

[Severity: High]
The commit message is missing a Signed-off-by: trailer.

[Severity: Medium]
Does the commit subject and message match the code change?  The title claims
to provide a stable source for the ext4 kmmpd thread name and the body
contains a mailing-list reply concatenated with validation notes, while the
diff only modifies lib/kasprintf.c.

> diff --git a/lib/kasprintf.c b/lib/kasprintf.c
> index cd2f5974ed987..77cbf8a1cbdd4 100644
> --- a/lib/kasprintf.c
> +++ b/lib/kasprintf.c
> @@ -7,6 +7,7 @@
> =20
>  #include <linux/stdarg.h>
>  #include <linux/export.h>
> +#include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/string.h>
> @@ -22,6 +23,15 @@ char *kvasprintf(gfp_t gfp, const char *fmt, va_list a=
p)
>  	first =3D vsnprintf(NULL, 0, fmt, aq);
>  	va_end(aq);
> =20
> +	/*
> +	 * Reproducer-only delay.  Cover both the original ext4 MMP thread-name
> +	 * format and the fixed format so A and B execute the same widened
> +	 * kvasprintf() window.
> +	 */
> +	if (!strcmp(fmt, "kmmpd-%.*s") ||
> +	    !strcmp(fmt, "kmmpd-%s"))
> +		msleep(1000);

[Severity: High]
Was this reproducer-only delay patch committed instead of the ext4 fix in
ext4_multi_mount_protect()?

Rather than stabilizing the thread name in fs/ext4/mmp.c, this regression
adds an unconditional msleep(1000) between the two vsnprintf() passes in
kvasprintf().  It stalls every ext4 MMP mount by one second, widens the race
window that triggers the vsnprintf() mismatch warning, and sleeps without
checking whether gfp allows blocking.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/da634961-1d13-4d21-=
b181-f366fd72e0d1@bytedance.com?part=3D1
