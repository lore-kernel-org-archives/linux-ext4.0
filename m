Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795566148;
	b=Z646zmChcZMPgk0kGIdfeymTZ7f50pJxtXUpvGkKDIPp26RjOOYC1yPshBfWd3vrB4ts
	 c0UkYD51iyZ/KX6xZxDTQ4TqkvWklRCQQ5SDHSIC5EGswrlMNjYcaMrDb2CNWJPHH79oj
	 vPIhWSA9Niw+Wbqxr4MrVNn8t7cRRm4TLvISGIhS6nFovy/BzEhgg67986SK8UqoRGzMp
	 2Ny746iGJepMpEG+2ZEFWwqsdknV4c+kJiFnBUBNPjbFnSgCFFTaNGF483lQAR2FLTdTG
	 MSy3xHZDAYdTkEay2JOiH0lHRd0VnhnX+TPW85fesU6RY9+Q1t1PclJkIS5r15Xa3Kw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795566148;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=bc/LtaiYQEAZO2B8ClYQtOpygjqUseunn8GqjcNTBj8=;
	b=XKBhyFyovtmP1FqtKOudCr6cgYSSU+i7PiTtZX/bIj8Pt0sifkscYjfOw+J27LYtlmt0
	 IeMK3B55vMxKdD/L4TaeXygyZteOBms89ZOkDvxjInMlu18aI6zjrZNC4DHGyAPYaaYth
	 7CU0/dQ89/PpERCzsZK0UvxwlnQmDiNQUXlkI6q+Z1GZ9a0ON6vOc5CWWd1GMHqMGP0n3
	 YcP4n/waZIAjxrQz0yVpQOobWrTS1VoBphAKGJ8tHFkCjmiw6WdjulmfyBGoKqBpqxgkE
	 i6+2XqE1INqmZZJ0Jo+uTmRHFk7J1XZx2GtHF8Co0qalOglvoKAMGlBUHKX0xBzWBMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uber.com;
	spf=fail smtp.mailfrom=uber.com;
	dkim=pass header.d=uber.com header.i=@uber.com header.a=rsa-sha256 header.s=google header.b=zQCH3I5r;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.171
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7D7606A321
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 00:22:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A7D7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=uber.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=uber.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uber.com header.i=@uber.com header.a=rsa-sha256 header.s=google header.b=zQCH3I5r
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b503e2a87bso55133837b3.3
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 16:22:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795566147; cv=none;
        d=google.com; s=arc-20260327;
        b=idCsE5ie6T3UTNG7AC0TDZuuVtRXEYViRXUPuSFDk3F1qpEC0Jsb+JgB+sGPOwtWR1
         /fZZaktxOHz6CBq7DyfM5K/uHY4QyMXx2NdeyWuprICwdS0z9VvUXGxc+rdJqeLRqOG5
         KE3aVrzHTHEvv/rbnahKaxPq4xc/NOcMbKIcGFnIE15+PVe01OFSHW1l0m4leoS6CIje
         wdfvXQtH1oQ12n4z63CC6vvv9wF10a21ht0+u6kmi3mbeLDT8xpwS49H5dQHbCE3wtKB
         VJe0VqELL64fIrZgpOm6LaefwIheQrFP3vUfb1qivtHqVsBboOmyTCg1WdqvwJREUc9m
         xrjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=bc/LtaiYQEAZO2B8ClYQtOpygjqUseunn8GqjcNTBj8=;
        fh=cW6IADii+Zqrd+hhGpLE7uv6lyObN3fYJwr690ID1wE=;
        b=M/lYX3iDU6A+OpMpGUFEPneUUufOqbUg356fAJ1o82T42UwxJY75l4gDESTByqTqn/
         WhelWYFmeNJM3oCgSu/3rF3aIY8TYgfju8qWqMwtMujYkX04S9AvN49DCVETH7KxAryY
         jnD4ItOIiTUbC8QR/GuKLkTVpZYPaW72ewgCoW7XqCTl0vpszlmfqz038kropconlAjo
         2AopWtXqEJHLI3yL16fiH/UHxyxR3hplSyEGhdcM2Lz7gZaBU1S/47RtfsYCDyxdIn4a
         VYdU/kX8lARhv7FZAcbJbMkVBAsdrcTGJa+6kdNakt9mS8/nirUvAd/L6uycdJDa6VSr
         DyNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uber.com; s=google; t=1795566147; x=1796170947; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bc/LtaiYQEAZO2B8ClYQtOpygjqUseunn8GqjcNTBj8=;
        b=zQCH3I5rOxMX/s/D87IWv3fBD/cKvZ/Z0OCmkQqB/xBEKghjJpPmrmUNZ4j1eLAtu0
         F7jY57ZVS2W1wOeQrL0jvtnfR2vpOYtuCHtlrakGDYuCle8ApyJcRKL6BjMlO0Bl44US
         0FyWHlWNQUUDm3dDSwxndv37IE4V/zv9PNHQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795566147; x=1796170947;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bc/LtaiYQEAZO2B8ClYQtOpygjqUseunn8GqjcNTBj8=;
        b=YM84t60LzKBhHN2e/YK3x5ZCyF2OgGK56mJjB2+opSnpIoUrWJFFKSsVInaPYPNsQl
         H6LpW0r+/vvd2fSiT9syzRva9sGVaFPdIOuXW1lFcg+8IzHvAWOiw1f94LGAfxsdNYoO
         jM6HYgdc2btrRAho/pw9NxcfkrOZngs+lsBTViOYROzAy4UTeoVDqM7VigFoiJSs26JV
         IU5E9tdT4kYxgRqGU6+KdSiy0JwGzav48ejfjSJUi+1Fs3rwUlnAXk49UXRMNyP2SlKZ
         uql6cdnkS2X53o678UA3AVjdBWl2q+noohz0gbU2zB1EGNWbz1nyp09aX9ceNmtScU9U
         Vumg==
X-Forwarded-Encrypted: i=1; AL+hErGEdOAdSUf9mdOaenskuhLc/6OnGnclEnfDO2mPIlR5ZljQUe2SqOTjNw//aS18TFMoihUK4n6LmL/L@vger.kernel.org
X-Gm-Message-State: APuU4Z991VhfC14DKePZUGvzh73tm41aDen7gLd99hk4n5LBukSNT2Fd
	lk+GhdW/irb6y0IZNRqkCjXEud5dho7FjtYK2Uqh604qI+JLpqeru1Ilm56jzq7DOzqtz3HULQ6
	5ZH/loNYUayE24WyzJaVvuyoyKo89ddnUe8kynnujMA==
X-Gm-Gg: AZFdTZdUY2qomKchxHfvADgID0NZijJxBiUkENcPD3ZsC7dAHQJjEv5rsICda6xjo8t
	lT0X5Amob7KtSSrHo/6rweeu7EL2gXVKE2BZ+mfT1whyGJWC+G4z4j8cQ3JDUq2JWuadF8tZfcs
	EYBhzlgGHt+82Ap67sMp41EFaxfhP5iGxx3wESEJkEO99EhxNBoFTjfgEFHblTH0WmC810YIKdU
	k/Ui9Coyee91p6UMOp+Zy6ZXsd4jNVvL4UcpatRPrc1apXkXs+MwcGcyRac13EBreLI6X/gEUQy
	te3WgYcy718BaPYr8D/GBUtyDSYcWSdYYWlRtYQb4jlbtE5YYBipkLWWrVfMDmnf55ISIG8jThy
	67KopI5UVn6YN/UwTeI2v+l5JziUvzg8xO+1aWYsECc3tLfAwWSkXdJmUx3rqeGPXle+ipg==
X-Received: by 2002:a05:690c:296:b0:8ae:a9c6:2740 with SMTP id
 00721157ae682-8b5204dbbf4mr77972427b3.48.1795566147017; Tue, 24 Nov 2026
 16:22:27 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@uber.com>
Date: Tue, 24 Nov 2026 16:22:10 -0800
X-Gm-Features: Aa3M54p8n4dC36ulVt65K9EGAEv7euEY3OSPYGP1viuFvm1Gc_x7ydbMd4pdg5M
Message-ID: <CA+w=M=R3eux80Cz3-ObXzQODAq-Pukj8R9gqG+zfCNqB5Wv+Yw@mail.gmail.com>
Subject: [PATCH 6.18.y 0/2] ext4: fix transaction overflow during writeback
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, 
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>, Zhang Yi <yi.zhang@huawei.com>, 
	linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Greg, Sasha,

Please consider these two upstream commits (in v7.3-rc1) for 6.18.y:

  25b2a7e8d420 ("ext4: teach ext4_meta_trans_blocks() about number of
allocated extents")
  46e8e31771f4 ("ext4: fix transaction overflow during writeback")

46e8e31771f4 carries
  Fixes: 95ad8ee45cdb ("ext4: correct the reserved credits for extent
conversion")
and 95ad8ee45cdb went into v6.17-rc1, so 6.18.y is affected; 6.12.y and
older don't have it. 25b2a7e8d420 is its prerequisite. Both were queued
for 7.2.y (v7.2.6, as c391af5743a4 and a22464c5df58), but neither has
reached 6.18.y; I checked up to 6.18.65.

Why we are asking: since moving a fleet to 6.18, we have had
production panics on ext4 roots mounted with errors=panic (default
dioread_nolock, 4K blocks, x86-64). Three hosts went down within 14
minutes of each other, 47-57 hours after the upgrade. No I/O errors were
logged. The signature is:

  WARNING: CPU: 14 PID: 516083 at fs/jbd2/transaction.c:1562
jbd2_journal_dirty_metadata+0x211/0x220 [jbd2]
  WARNING: CPU: 14 PID: 516083 at fs/ext4/ext4_jbd2.c:368
__ext4_handle_dirty_metadata+0xe9/0x180 [ext4]
  EXT4-fs: ext4_convert_unwritten_extents_endio:3859: aborting
transaction: error 28 in __ext4_handle_dirty_metadata
  EXT4-fs error (device md127):
ext4_convert_unwritten_extents_endio:3859: inode #96132149: block
85533573:
    comm kworker/u194:0: journal_dirty_metadata failed: handle type 11
started at line 5070, credits 18/0, errcode -28
  Workqueue: ext4-rsv-conversion
  ext4_end_io_rsv_work -> ext4_end_io_end -> ext4_convert_unwritten_io_end_vec
    -> ext4_convert_unwritten_extents -> ext4_map_blocks -> ext4_ext_map_blocks
    -> __ext4_ext_dirty -> __ext4_handle_dirty_metadata ->
jbd2_journal_dirty_metadata

Line 5070 of fs/ext4/extents.c, the same in 6.18.65, is the
ext4_journal_start_reserved() call in ext4_convert_unwritten_io_end_vec().
The 18 requested credits are exactly the reserve that ext4_do_writepages()
computes after 95ad8ee45cdb, 1 + ext4_ext_index_trans_blocks(inode, 512)
= 1 + 15 + 2, for an inode whose mapping allows order-9 folios.
46e8e31771f4 replaces this with ext4_meta_trans_blocks(inode, bpf, bpf, 0).

The two backports follow as replies. 46e8e31771f4 applies cleanly.
25b2a7e8d420 needs two small adjustments, also noted in patch 1/2:

  - fs/ext4/ext4.h: the prototype hunk does not apply because of
    context differences;
  - fs/ext4/move_extent.c: 6.18 still calls ext4_meta_trans_blocks()
    from move_extent_per_page(), and that call no longer exists
    upstream. I pass block_len_in_page as the new alloc_extents
    argument, which keeps the current credit estimate there unchanged.

Testing: both patches apply to v6.18.65, and fs/ext4/ and fs/jbd2/
build with W=1 without warnings.

Thanks,
Alireza Haghdoost
