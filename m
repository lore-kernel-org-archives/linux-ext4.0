Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794005619;
	b=IySWqL4tYTUtQqt2Y7QsmN51CS1+Nn3lNhkSysFg02DEIVZxikfF5eM5xMWBe+FV6ghJ
	 3rG1TuUwRozS2Qj23R0bn5rW+ryJVljLTRqbJ6hWf7wlkmtAofcb/7lGae2/8SNyu756V
	 EXK5IG4vWgY1gweBOLCHgnaFEEHNkcsshfF/5xSxFN4u6nmIPlNgYnbkWI/0RYluD+8s5
	 HXB2ERpk693R6zuMlTughXO1Sfd2epBxbJoxpMsdsBIW/g9sPulRt4MVtYgxXOrGtohjc
	 gaDN74zHH+ay79a25aEYqSz9LC74FIM5SX/VAlSTO3D/6y4JCfUV+lFYamAgnLtnuUQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794005619;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=Ajm8sLkLzuE5Epa/6nTv9uoiRj/UyFkuhiq7gPfP9qc=;
	b=Fikq4ogntsXUbczBrF0YqqU1PLUN+jZnntKtQEbteICaCoHPQAGsjuRTDVvlURrypPgD
	 BwvEA+vOt+geysxIge/ccVbRLPOihm21s2lGYY3rCx85tVlkEBC0uzPDRpJM4WjdZGIMf
	 rU5rhRYTbGfSNH8os+zrozLPZlzHO8TdZV/zl3NS3sW773eP7SP7KrTQgvjuFBU8jyMO9
	 PUCfZ1FFQIhSj5/TMLll0+4Y5bAqL6VVbBga5XOAyoakDULTXUfPNSlFeBTM9/xCvK6Kj
	 jQYxhs2JIioZCyegWcspab4EoICYUOZHlyIleGCFfYS7i7heG0zhy8lAdblsDBmAFUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wJBHZdtV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.179
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF5A606A32C
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 22:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AF5A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wJBHZdtV
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5eadef147ffso904929e0c.3
        for <linux-ext4@vger.kernel.org>; Fri, 06 Nov 2026 14:53:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794005618; cv=none;
        d=google.com; s=arc-20260327;
        b=kqIvaxq+o9iWfrEInl8Ww3J1auvSvThlytORMwFSb8ZJ0wCJL8MRrwEtkOrwYuzzKX
         88LlAL1SUZ29YX2kZJMikSNhyRiS6XLJb4mQUEj9a6Kl7hW/v3dpcwrVibGYn7Ap/zsY
         UJaiCuHD7b5hKFMEH6xK6XsxxjQGh4o5dKuK75YZuB5A2XbDei7sd9T0w9vUkhr9Y6xy
         8ZAFykeEOhIcVgWS4AKmWMQ9lWB8yZuvhD+yBFASQwFqSFAG+ZGM5OQn8ICTALRGpk6K
         /1UI4jgEujce/BvK5JBzgWHGoca3eaZiGa9MNtQPgfNRH/eg0CnBp5bjw9Pr/KvcV4WV
         GPYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Ajm8sLkLzuE5Epa/6nTv9uoiRj/UyFkuhiq7gPfP9qc=;
        fh=VnhGJpHs2B+b/hFTe0RqDVNtHV6xm5qoX21DDqFPQwI=;
        b=pj/j+Unupl7FHgDLaMLD2ot3s1N0lAcO14Xocsj6h6okAOabL4fDnKDXcdOMVIM+5y
         RCam5qcoBMNBzNYC3vNm7lWo/17lD3CimW7hgRpxy92JozMIbym7te15QElj38O6n1oZ
         CYcatSjWSnljvymxP0T5kDTnYjdiNWmNGxOZaw8XOfcabWWiCm/1TAbDrHCZqRJiZVf0
         In89e1gROivcz+aLLXFXkF2YDqC7iSoxpJ85hjyaYgeKsLL8n7fnk8bcKYg0blCBuKE3
         xWOV7LSbZFaQ7a3kH/w8aBTu3AJx/54HHiJTEXf8+UiwRSMOXf8+WlsRxWq2Y4TpdMqB
         78CA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794005618; x=1794610418; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ajm8sLkLzuE5Epa/6nTv9uoiRj/UyFkuhiq7gPfP9qc=;
        b=wJBHZdtVjnyUdww5Rg2dW9kDHmNtlO/vdCUPq8MA3ZlHESoHDJjXOeTVW0y0/BGzbg
         7g5ANgLObzdx6/waK/GEU9JD1mf7k6sIBzm42+tlxF3wnJ2rBSTkkBazs8pP4Ia6XLa8
         2n+iuSBpj5s+1TytiqWhoEkUku616Kd9nGolIoj6Oj2j4A+cFYZQfXZecEBhbKHBH2Qp
         JHZPL0u2c+LoGYecvAZdnCLMr5v41s+hQgdRNYwj+DoOFZ72XdYWLOfcdXgwPe/+Plb3
         xt+stC0ki5Q3BeHzVf1BaHBJ8K2dGn/Ko1HvlnKHNI65KCbdEFNUC1E5zlvPeOgJUXY9
         7lWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794005618; x=1794610418;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ajm8sLkLzuE5Epa/6nTv9uoiRj/UyFkuhiq7gPfP9qc=;
        b=zT8un7HllK9sHzcDXfjCg99Ajeoc/F2uqzIiIQysV+TWi679CMP15StLfpF+qWOQp5
         EL8OfiTQdk1KnuaasowmfI1pfRbcqkH83XwduRmxCrkM8G9tlrAOSjc7/wRaA5/NVgyL
         aXSoMDLkxa73mUWz8i4Bv10GDdYIk6OadmdpJiutIAP4HLf5j5fKV6HJFR7KRS8+ChfB
         73n+i7SmeIDxTxehY+B9aJmPRSUrzDZrsSK4CELg8HZIsR4Eo/eua+I+8g2RzpiMIsc2
         xZEpQdmimDfUsXAyF9NsZYvLq5d0gAsRXWHkztAQynWW3ze3CpJMQl4zbyCt4qP4NcMG
         VZvQ==
X-Gm-Message-State: APuU4Z9cJwxXbI8u2yDJV0hUb4S4hsnc6MUohVyS+WakKOSHlC9aoaXS
	/Iy7WFj9Y6epBVE9u/MzlUpyTGbRDsXtsn+LWAjQ9S+vJ+4myEMNBZ0xsaeffz9h/hNj7lnkp/j
	j3tWGAYmxIr9I05IuBPhat8qnQi/9h6E=
X-Gm-Gg: AYBFou3eAKIOye88Ybuk7GdnteyMfttmzfKI/RFCg6RPJ8+ceYSwo1FU+dBXOOBab4P
	4u1jkpnpjnnUselvpUgtw1j5TJISM2PYIk9hYAHYBtboxtRcLJEUpRTY8kb3MMftkluzjGZP+Xj
	wo2dBms77PfvQkW2N5Bylk6RnUqqhx4rI+EHP8630W80WqidJuxRJ71Ifg7zJpA8VPtLX+iz8xY
	Wn5/bWxlBHsSWOC29EUD7TTR1iXDKORIln0WXyj2WkTxVFcPKBc0sXJSVxeUZ4WN8RKhg7d9kPs
	ERSh6eHXqntA3dFgRNx3La0Lc3tTPMjF88hHqgIm19ZaKz64TL5+0TYuHThEuehZC7Wmd6rH/K4
	1tBHwqPMXwI4Bd97YQJohdfNha0NxC89oLSyCl4lo8tbnkDQLl0hMvpy7E/HvqZ/b1uE=
X-Received: by 2002:a05:6122:414d:b0:5c9:a60b:e5a2 with SMTP id
 71dfb90a1353d-5ecc43e92b9mr2123325e0c.13.1794005618292; Fri, 06 Nov 2026
 14:53:38 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Simone Colombo <colombo.simone@gmail.com>
Date: Fri, 6 Nov 2026 23:53:27 +0100
X-Gm-Features: AclHuK84MI38ZArBzdnoV44X2oKuSHS27JZC_ylfinDrucJDKKjxSJ7q9SXKu8w
Message-ID: <CAEVL6QtFUCs66EtLFj6dO8DQq9YE0Corvy3BTj-9HEvPkTP7xg@mail.gmail.com>
Subject: [REGRESSION] 6.1.191: NULL pointer dereference in ext4_mb_load_buddy_gfp()
To: stable@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

Since 6.1.191, mkdir() on ext4 can oops with a NULL pointer dereference in
ext4_mb_load_buddy_gfp(). 6.1.190 does not, in the same test.

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  CPU: 0 PID: 60 Comm: mkdir Not tainted 6.1.191 #1
  RIP: 0010:folio_test_uptodate+0x0/0xc
  Call Trace:
   ext4_mb_load_buddy_gfp+0xcb/0x351
   ext4_mb_regular_allocator+0x3bb/0x82d
   ext4_mb_new_blocks+0x392/0x93f
   ext4_ext_map_blocks+0xd5a/0xecd
   ext4_map_blocks+0x26b/0x47b
   ext4_getblk+0xca/0x243
   ext4_bread+0x6/0x45
   ext4_append+0xc2/0x158
   ext4_init_new_dir+0x5d/0x103
   ext4_mkdir+0xfa/0x249
   vfs_mkdir+0x74/0x8c
   do_mkdirat+0x81/0xc1
   __x64_sys_mkdir+0x1d/0x21

(This trace is from a test build of v6.1.191 with KALLSYMS; our production
build of 6.1.191 oopses at the same instruction.)

6.1.191 picked up these two as prerequisites of "ext4: fix e4b bitmap
inconsistency reports" (Stable-dep-of: bdc56a9c46b2):

  99b150d84e49 ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
  5eea586b47f0 ("ext4: convert bd_buddy_page to bd_buddy_folio")

They check __filemap_get_folio() only with IS_ERR(), which relies on
"mm: return an ERR_PTR from __filemap_get_folio" (6.4). In 6.1,
__filemap_get_folio() still returns NULL when the folio isn't cached, so
a buddy cache miss in ext4_mb_load_buddy_gfp() ends up in
folio_test_uptodate(NULL).

We first hit it on first boot right after growing a mounted ext4 with
resize2fs, but it only needs memory pressure. Reproducer in QEMU
(x86_64, 320 MiB guest, NVMe disk):

  mkfs.ext4 -b 4096 disk.img 244224   # on a 4 GiB image
  # in the guest:
  mount /dev/nvme0n1 /mnt
  resize2fs /dev/nvme0n1              # optional, makes it more likely
  # fill a 200 MiB tmpfs, write and delete 300 MiB on /mnt, then:
  for i in $(seq 40); do mkdir /mnt/d$i; dd if=/dev/zero of=/mnt/d$i/f
bs=64k count=4; done

6.1.191 oopses within the first few mkdir calls, with or without the
resize. 6.1.190 completes the same test both ways. Without memory
pressure it doesn't reproduce here.

Locally we work around it by turning a NULL return into ERR_PTR(-ENOENT),
or ERR_PTR(-ENOMEM) with FGP_CREAT, at the six __filemap_get_folio()
calls in mballoc.c; with that, 6.1.191 passes the test. I can send that
patch if it helps, but you may prefer to fix the backport itself.

#regzbot introduced: v6.1.190..v6.1.191

Thanks,
Simone Colombo
