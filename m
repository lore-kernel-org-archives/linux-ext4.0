Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=188.68.63.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794034415;
	b=NAcOB1QeQvYHN+NpORCytkX2QWGGTvQgcIRkj0PAVWFp6JpirHezU32FGz3EN9eXFk8e
	 Ty1YtqRK1S311bmlWG1LpoYquS/D+sHq2iCW8cYPCuy8k16CunjTXN7YJLyHZl9gGYLut
	 V7BPAYE6TEum+abSQsDIsiNQNtDeYwypSpllP2MzOotwg1SwVMc86qptH8LaejOhNTzAf
	 NGVypik+9KKvywvip0EGYlLF74jGhtrxzPdt3p7nEELLa3BlGwiFR/EwI5VqtYpuTL1xN
	 VegDeAric3ssmAKhOoSBw5lUiuiZB697ec1adkCmDZpHECB2O2aqg5vkpjKEW+FENTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794034415;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received-SPF:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-PPP-Message-ID:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-NC-CID;
	bh=sgjFvW4wEENdKL/320svk5+ImV/LvW07zU9oF/dDyws=;
	b=DrxHaG/hSyvPHJQ8kQ9sKwaBUERDpwTUtsL/MpibowPXXWu/w6zqYLCYwRAWllSlPMRO
	 tS3U+KibV9zz7hHssDZnVImIqqWztGxRHS8z0D0sOg+98PpDdTzrvb4TlI5Ky/CoAjUjG
	 1bXLRCVfeVpP30vzexqwIiUgkTRFvS/AVEh1zrZNXG9xMwHoFljRzrxmAqE5Q/A7/lBiZ
	 8boXK857ewJWB1sI41O2kPW6f4lBksKQGJlMG7Meji5lutHjNtqoHhDvcwbxCwUDcOCCx
	 xQgoaz4i7i/obB0Ve/86pMPib6e6tPtmpXYJI+ZtSJJ2bAUkPBf6p4qfAB1Qt2Uq7Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leemhuis.info;
	spf=pass smtp.mailfrom=leemhuis.info;
	dkim=pass header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=bWceHprm;
	arc=none smtp.remote-ip=188.68.63.98
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98FC606A32E;
	Sat,  7 Nov 2026 06:53:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A98FC606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=bWceHprm
Received: from mors-relay-2501.netcup.net (localhost [127.0.0.1])
	by mors-relay-2501.netcup.net (Postfix) with ESMTPS id 4jM6Dn363Vz6CMg;
	Sat,  7 Nov 2026 07:52:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1794034361;
	bh=W4I87TQG2Scg90wu2d+/OtsosugT18Ycf+G0ZMsoPdU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bWceHprmzPdDuOSWyaiV2A1lJWko/B9eKOvjrjyBsa1JQf9sjeb06jroqtYWIMb9C
	 Wcpn0pzKehCp5i3Hr+GPl8p++5DVZ+duvMx/3umEKKnD805DUyIAxW4sb1bVt1ccRi
	 4eBYPuh+5qjkGkwA9kY9nsA0uQ8dLE8H2AwDj4SB9jONgEppdP4J8Hwu43LIoIsYS2
	 4Zpk3qLxRrf9OSbTgFRZyTOuRMLnf84Tm4LglX5L9cIltXFZp6A4wmbzDhWRFthATn
	 GsKmwRw8c9r+wpIkN/xJ0rcCCVD5fF9WcK8GTWid7jqRoAuWY9Q3LBXjLf7u0kmiXc
	 B6KApkGgRrwIw==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2501.netcup.net (Postfix) with ESMTPS id 4jM6Dn2N8Qz4xlH;
	Sat,  7 Nov 2026 07:52:41 +0100 (CET)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4jM6Dm10GYz8sbs;
	Sat,  7 Nov 2026 07:52:40 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 79B805F987;
	Sat,  7 Nov 2026 07:52:30 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <c34778fd-e5c7-4547-b958-e5a9fb75e5c5@leemhuis.info>
Date: Sat, 7 Nov 2026 07:52:29 +0100
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] 6.1.191: NULL pointer dereference in
 ext4_mb_load_buddy_gfp()
To: Simone Colombo <colombo.simone@gmail.com>, stable@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, regressions@lists.linux.dev
References: 
 <CAEVL6QtFUCs66EtLFj6dO8DQq9YE0Corvy3BTj-9HEvPkTP7xg@mail.gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <CAEVL6QtFUCs66EtLFj6dO8DQq9YE0Corvy3BTj-9HEvPkTP7xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <179403435076.636600.361162975346760712@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 79B805F987
X-NC-CID: pbMQNuX6ZdkhT5QdWWCDeStPtfzWYZy+2Uy6pjZ44bP/TZg3pck=

On 11/6/26 23:53, Simone Colombo wrote:
> 
> Since 6.1.191, mkdir() on ext4 can oops with a NULL pointer dereference in
> ext4_mb_load_buddy_gfp(). 6.1.190 does not, in the same test.

Not my area of expertise, but from a very quick look this seems to be
the problem that was reported here earlier:

https://lore.kernel.org/linux-ext4/20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com/

A fix for that is queued. Please report back if that seems to be a
different issue.

Ciao, Thorsten

>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   CPU: 0 PID: 60 Comm: mkdir Not tainted 6.1.191 #1
>   RIP: 0010:folio_test_uptodate+0x0/0xc
>   Call Trace:
>    ext4_mb_load_buddy_gfp+0xcb/0x351
>    ext4_mb_regular_allocator+0x3bb/0x82d
>    ext4_mb_new_blocks+0x392/0x93f
>    ext4_ext_map_blocks+0xd5a/0xecd
>    ext4_map_blocks+0x26b/0x47b
>    ext4_getblk+0xca/0x243
>    ext4_bread+0x6/0x45
>    ext4_append+0xc2/0x158
>    ext4_init_new_dir+0x5d/0x103
>    ext4_mkdir+0xfa/0x249
>    vfs_mkdir+0x74/0x8c
>    do_mkdirat+0x81/0xc1
>    __x64_sys_mkdir+0x1d/0x21
> 
> (This trace is from a test build of v6.1.191 with KALLSYMS; our production
> build of 6.1.191 oopses at the same instruction.)
> 
> 6.1.191 picked up these two as prerequisites of "ext4: fix e4b bitmap
> inconsistency reports" (Stable-dep-of: bdc56a9c46b2):
> 
>   99b150d84e49 ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
>   5eea586b47f0 ("ext4: convert bd_buddy_page to bd_buddy_folio")
> 
> They check __filemap_get_folio() only with IS_ERR(), which relies on
> "mm: return an ERR_PTR from __filemap_get_folio" (6.4). In 6.1,
> __filemap_get_folio() still returns NULL when the folio isn't cached, so
> a buddy cache miss in ext4_mb_load_buddy_gfp() ends up in
> folio_test_uptodate(NULL).
> 
> We first hit it on first boot right after growing a mounted ext4 with
> resize2fs, but it only needs memory pressure. Reproducer in QEMU
> (x86_64, 320 MiB guest, NVMe disk):
> 
>   mkfs.ext4 -b 4096 disk.img 244224   # on a 4 GiB image
>   # in the guest:
>   mount /dev/nvme0n1 /mnt
>   resize2fs /dev/nvme0n1              # optional, makes it more likely
>   # fill a 200 MiB tmpfs, write and delete 300 MiB on /mnt, then:
>   for i in $(seq 40); do mkdir /mnt/d$i; dd if=/dev/zero of=/mnt/d$i/f
> bs=64k count=4; done
> 
> 6.1.191 oopses within the first few mkdir calls, with or without the
> resize. 6.1.190 completes the same test both ways. Without memory
> pressure it doesn't reproduce here.
> 
> Locally we work around it by turning a NULL return into ERR_PTR(-ENOENT),
> or ERR_PTR(-ENOMEM) with FGP_CREAT, at the six __filemap_get_folio()
> calls in mballoc.c; with that, 6.1.191 passes the test. I can send that
> patch if it helps, but you may prefer to fix the backport itself.
> 
> #regzbot introduced: v6.1.190..v6.1.191
> 
> Thanks,
> Simone Colombo

