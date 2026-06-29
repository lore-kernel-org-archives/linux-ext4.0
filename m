Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4DF40587E
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 13:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782738509; cv=none; b=Qvk7FOO2x0x38vBUvEQaui15eYsIvtV60abyqTWXo5QecNvFPKClJoAA7eoKujmkESJPEAf+l6sAJy2mUVKLx+oTiOSu8PgNl4y5TBgPxFIAV6fdYiz9bQf20V7tR+mfrctruO1MngFMeJmGTbeQe3kuI9uthDp4WPtU5EWynxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782738509; c=relaxed/simple;
	bh=Ggxh9ByeQmCBi2NeZlw6U6ONOnI1PZUSHxRmJ2bhS3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxAui0S0NH0MrqwURXi/tTwglSJe7bB65HKxAAVhpxsY2KZ24jTMjFBU5XXIa3uW6cQgNEhIetNrREwDNO/1S4c67ts5Y4aJaAcLUHz1CPiVuTV3s+x/S3UZXzOLGRTtmz8ouIQoqXqxJ9NuKqp001X47aPrDAvSE5XKkJqp3hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from macsyma.thunk.org ([104.135.218.91])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 65TD809d008593
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Jun 2026 09:08:01 -0400
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 0A6E47CD5C1; Mon, 29 Jun 2026 09:08:00 -0400 (EDT)
Date: Mon, 29 Jun 2026 09:07:59 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Xianying Wang <wangxianying546@gmail.com>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel BUG in __ext4_journal_stop
Message-ID: <akJsJXcuzxvJruKH@mit.edu>
References: <CAOU40uDfHk-8FxOuHO=rWcfjN0cV4psXhgdxckYhgaoaGZ51qg@mail.gmail.com>
 <ftl6dnudrvbwux7ptcv7l4az3cygysyaigpcik62uj6wdvxq6u@pzabzi5sgby4>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ftl6dnudrvbwux7ptcv7l4az3cygysyaigpcik62uj6wdvxq6u@pzabzi5sgby4>

On Mon, Jun 29, 2026 at 11:29:51AM -0500, Jan Kara wrote:
> Thanks for report but frankly, we have no capacity to analyze every fuzzing
> report somebody comes with. We generally look with higher priority at
> Syzbot produced fuzzing results because it provides environment for
> tracking of reproducers, easy access to artifacts, etc. which significantly
> speeds up analysis.

Xianying,

When we say "syzbot" we're referring to the upstream syzkaller which
has a dashboard[1] which makes it significantly easier for us to also
request rerunning the reproducer in the same environment as used by
the upstream Syzkaller.  (Very often reproducers are very timing
dependent, and so just because it runs on *your* system doesn't
guarantee that it will run elsewhere.)

[1] https://syzkaller.appspot.com/upstream

Also, in particular, if the syzkaller or modified syzkaller involves a
fuzzed, corrupted file system image, I personally significantly
down-prioritize investigating it, because we are getting flooded by
them, and I don't consider it a particularly interesting threat model.
Users shouldn't be blindly mounting untrusted file systems without
running fsck on the image first.

This is similar to the concern of a kernel developers getting attacked
by a denial of service by a flood of low-quality security reports
caused by LLM's[2].

[2] https://www.theverge.com/tech/932312/linus-torvalds-linux-ai-security-bugs

> For example in this case I couldn't even access the console log at
> pastebin to check the exact BUG message.

netlink: 'syz.7.1096': attribute type 3 has an invalid length.
EXT4-fs error (device loop7): ext4_mb_generate_buddy:1314: group 0, block bitmap and bg descriptor inconsistent: 25 vs 150994969 free clusters
------------[ cut here ]------------
kernel BUG at fs/ext4/ext4_jbd2.c:53!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 13658 Comm: syz.7.1098 Not tainted 7.1.0-rc5 #2 PREEMPT(lazy)
Hardware name: QEMU Ubuntu 24.10 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__ext4_journal_stop+0x189/0x1c0
Code: e8 3c 5e a2 ff 48 89 ef e8 14 55 18 00 85 db 0f 44 d8 41 89 dc e9 6d ff ff ff e8 12 79 d5 ff e9 d0 fe ff ff e8 18 5e a2 ff 90 <0f> 0b 4c 89 e7 e8 2d 79 d5 ff e9 06 ff ff ff 48 89 ef e8 20 79 d5
RSP: 0018:ffff88810d3974d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000009 RCX: ffffffff88486688
RDX: ffff8880164cc600 RSI: 000000000000035c RDI: ffffffff8af2ad80
RBP: 0000000000000000 R08: ffff88800e96f9d8 R09: ffffed1001d2df48
R10: ffffed1001d2df47 R11: ffff88800e96fa3b R12: ffffea00044dcb40
R13: ffffffff8af2ad80 R14: 000000000000035c R15: ffff88800e9045c0
FS:  00007f4bb3d37640(0000) GS:ffff888187bc7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4bb532e6e0 CR3: 000000010328d000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
<TASK>
ext4_write_inline_data_end+0x3b3/0xa30
ext4_da_write_end+0x3a3/0xa70 inode.c:-1
generic_perform_write+0x215/0x730
ext4_buffered_write_iter+0x194/0x500 file.c:-1
ext4_file_write_iter+0x4b5/0x1400 file.c:-1
iter_file_splice_write+0x8dc/0xfa0
direct_splice_actor+0x181/0x5c0 splice.c:-1
splice_direct_to_actor+0x335/0x920
do_splice_direct_actor+0x168/0x230 splice.c:-1
do_splice_direct+0x41/0x60
do_sendfile+0x9c4/0xd30 read_write.c:-1
__x64_sys_sendfile64+0x195/0x1d0
do_syscall_64+0x104/0x5b0
entry_SYSCALL_64_after_hwframe+0x77/0x7f

Note the "-1" for the line number.  If you want to reduce the amount
of time that you are wasting, try to fix your build setup so that the
line numbers are correctly reporting in the kernel stack trace.

Or better yet, send us a well-formed kernel patch following the
established patch submission protocols[3].

[3] https://docs.kernel.org/process/submitting-patches.html

Regards,

						- Ted
