Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1536743D51A
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 09:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134358; cv=pass; b=brCVuE4gjRdPAShsg+K3/bz08hwHOeY+zwkmbnVf/yBT7/kFIL8NEmvOx0Hm4RnHD64uY5Rav6IfpVTNmwBoaefLIpC/M36SUw+ubz1H9j+sVvVpCnZcJGFe1XueiIojbc0kojYw1OQxPXDCiFuzI/SwAcMH+1SxL2XU0neBBeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134358; c=relaxed/simple;
	bh=LXHYyHUG9v6B6ilUTFvYqIkqq8vayk0tM49Fx8+xM+s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=SmU4HV8RAMJ7XQGxXp1p6AcTF7l+r/1m9JY9Udgcdbao2sFD0Dy+QwNVOfbOFbs//r9879G48FM2lHkFyfxQyHq4MjdP+i3FaJat+YiCwT81rbrzYgBySlZQGGdevZdGBJZYro0lFSrDUHfXgp9u50sh+Jv1hmM2sG1PCfhrES8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XXpMaHcP; arc=pass smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XXpMaHcP"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ad4d639db3so55944025ad.0
        for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 02:19:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773134356; cv=none;
        d=google.com; s=arc-20240605;
        b=X3Pq/A/2+dhjEIMBNWescPN2qHKlFdxvTeVHlB/tvcegCvQlNrAOVnf7m69AkfqQm+
         gY40r+Ef0hDVQpcaY2YsHHD7iuWyGdOlStV8TqZHA/kzwCnwPr6jYuzgOEVsxhCrp8r+
         8f1ScX8+EzDdM9h/D+AQIn/uT22zuaok867yLq7ae3bsI6e03jbNSLSfxlZtlNuotrw/
         MwWBMOZwE3X6imBvXcI/UDfyUWel4XoqM5GjGl75+KAna5MXJjzysKCO24KWKLpbP4+Q
         j5TMWPpyUbSI6UldwvXFh//GZK79zPd6dhpSlj9rbcIRsLyUT/fRqSOQ5qTXAHaxTH7l
         vGcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=LXHYyHUG9v6B6ilUTFvYqIkqq8vayk0tM49Fx8+xM+s=;
        fh=pmkVfUgLzdt+J9AZpT3bWzrWKZgWat6oL6s4AJI0/H4=;
        b=QhSJ9QJx94gdhQOqHWLr5FARTUN4JrPbjDszVfL9lDug7LiacccOwRtgDGFNbXAFYT
         u/7PK3a1KRFAlGdU0PuJoT0A7uyHfUXETXdQ/PuzIk8P2IeqLdLB5t3Vy5gVjhq6OQXw
         48SDVYz9CtEQmRIN5/ZaDc5P1Z/jUknWigy0H/JT7/Cdhel5MEC+FSPsXfM2wmt3BN7w
         Q8GVjFgYyag9EHyOCTgpGIpf7DQH9pTYIwA8L7IFYkYAR7Pz2/H6JUBYe9JPuQAmse2k
         Yw53FFAtCvx6OASasZkRyxiB1Qk1Zq7kAisOmCHY/x1ycDhRIiRiZM5/ZmIWj2Jdeoxd
         s0MQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773134356; x=1773739156; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LXHYyHUG9v6B6ilUTFvYqIkqq8vayk0tM49Fx8+xM+s=;
        b=XXpMaHcP46cAOFEww5rxPrDKxsgcQ6nwl+BrjWjAm6lMdxLIPqRZh8mRGVvylSa5s5
         PgIbWC6tyoVtNw25fSQJPXD785Gtooh4BNkGj5CiTgkv7aUgnnpZpTvndhc1DQtTr1qg
         QX0IBNU4ziFtgF5RZC78Gl6M0C2CeM0zB8n2zL3JUtnPJlGau4Vv6d7DgmkVeu/hO01g
         0e+p90QRMI2cZs83sNQyKMnMuDeBJWC9Eoj+RZeqIy7P0R0In3J55ANSnnDYXc2JVkiy
         fIOKoxIXcWwbEYdX683QK5uZbN6yGMInaHx6cJ6M/2sJ84MtmoesmvUgtvDzHzwcJlts
         Z+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773134356; x=1773739156;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LXHYyHUG9v6B6ilUTFvYqIkqq8vayk0tM49Fx8+xM+s=;
        b=UiK7Jb9VBMogYZSmP/IfhBWua+BsPyHFkkjaUPpxfktPbg1z8CZl8EKh7bv9Kot0/D
         WhQbadOXv5WPDJh6ArsLK4r3jpMniyRmQKS4fS368Nk/eBs46XvuaV11+gRBlnUHAEdt
         VaKLGHAexyLeEkk1BfR8FEY1uQoqUcT+XIui1Cc8tWCfHEbjZ4uUb2ABpGwodmEjxvff
         voFmIdFIj1MQXG+y7lxMD2THhmsVQFvwlgqu3rDG2Awh7pybd93gnsm8o84AuBNgT8gg
         BbceAI+ITOBiR6wTVIgMLwk4WzLmTCVguGLKAN7QGFYlJSJPbqXCZK1NcMaQGndbnpGS
         e2Cg==
X-Gm-Message-State: AOJu0YzWHK39E8tajI1rS0PyYe905sWHqqHoDv9m7FNFei9xJ8ibITx+
	+cuHEFNGUd+jmM905oWPxDl4TnLVBqNGr0fx+HwJVH/9WG1dEqRgveoxbR/r36sEDmeIpZumfsh
	sqftYNMy+96/Aatg3IbPjFUewzxc3Jdo=
X-Gm-Gg: ATEYQzxvYjQiVS3U+2gq7LYWqtnxq/ddWnq/pefdSBrm9+zfzNeaMf3T1ybuAAfIcHD
	H6/WSbELCNJlU59zpJXC7uJi1syVXTLu6jshcrvbhOpcvHGGzBBZPSQNiLxAW4twyTsGHfwoQgf
	A5MolmExrJ7ymcJ5owk+bGJUu6haC+BPZz8wfNInG43VQFw0kzxolAFj30XLtplce5J1tbel46p
	oP8mMC1vmDRif58Ab5jmR0ADA7kS5+s9j9kIRmiVnifF2nNwXUTuJlJNWL+xDvcrSW7E2FITyvo
	bvTgcts=
X-Received: by 2002:a17:902:da91:b0:2ae:3cf0:3aa1 with SMTP id
 d9443c01a7336-2ae8244f6bbmr152695895ad.37.1773134356379; Tue, 10 Mar 2026
 02:19:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zw Tang <shicenci@gmail.com>
Date: Tue, 10 Mar 2026 17:19:06 +0800
X-Gm-Features: AaiRm52ZKFzsJmve8DusZJ2e8qzhzWQRQNnOje6G2IsQQ2RLly2WmMQvUBLTJpM
Message-ID: <CAPHJ_V+TU-HB6qbQr+6U_fpfpCV=j_Ohjk_xOFBJp=ywLsyE9A@mail.gmail.com>
Subject: [BUG] KASAN: out-of-bounds read in ext4_xattr_set_entry triggered by lsetxattr
To: Andreas Dilger <adilger.kernel@dilger.ca>, tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a KASAN out-of-bounds read issue triggered by a syzkaller
reproducer on Linux 7.0.0-rc3.

The reproducer mounts a crafted ext4 image and then calls lsetxattr() with
"system.posix_acl_access". The first crash is a KASAN report in
ext4_xattr_set_entry(), coming from __asan_memmove() while ext4 is handling
the ACL update and expanding inode extra isize.

This looks like an invalid size / boundary computation in the in-inode xattr
update path, likely during rearrangement of xattr entries or values in
ext4_xattr_set_entry(). The reported read size is 18446744073709551604,
which suggests a possible integer underflow being passed down to memmove().

Reproducer:
C reproducer: pastebin.com/raw/amERrUV4
console output:pastebin.com/raw/UgESgjBw
kernel config: pastebin.com/raw/FdALgYkg

Kernel:
HEAD commit:1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
git tree: torvalds/linux
kernel version: 7.0.0-rc3 #1 PREEMPT(full) (QEMU Standard PC (Q35 + ICH9, 2009))

Crash log:
[ 83.052095] BUG: KASAN: out-of-bounds in ext4_xattr_set_entry+0x1343/0x1ce0
[ 83.054679] Read of size 18446744073709551604 at addr
ffff8880109065d8 by task repro/244
[ 83.058624] CPU: 1 UID: 0 PID: 244 Comm: repro Not tainted 7.0.0-rc3
#1 PREEMPT(full)
[ 83.059041] __asan_memmove+0x24/0x60
[ 83.059067] ext4_xattr_set_entry+0x1343/0x1ce0
[ 83.059194] ext4_xattr_ibody_set+0x3dd/0x5e0
[ 83.059237] ext4_expand_extra_isize_ea+0xa9c/0x1850
[ 83.059481] __ext4_expand_extra_isize+0x341/0x480
[ 83.059511] __ext4_mark_inode_dirty+0x5d1/0x790
[ 83.059765] ext4_set_acl+0x396/0x580
[ 83.060113] set_posix_acl+0x25d/0x320
[ 83.060189] vfs_set_acl+0x405/0xa20
[ 83.060227] do_set_acl+0x80/0x130
[ 83.060264] do_setxattr+0xdb/0x1d0
[ 83.060384] filename_setxattr+0x149/0x1b0
[ 83.060520] path_setxattrat+0x1c8/0x2a0
[ 83.060875] __x64_sys_lsetxattr+0xc9/0x140


Thanks.
Zw Tang
