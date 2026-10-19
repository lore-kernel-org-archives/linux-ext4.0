Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2973F4122
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792400612; cv=pass; b=uLfrLffAAV7FAppnQrnMWDHjR2qEz88uK5MR4Xj0Qyo4wTjEvmjjdxI8hx41F649QazIoQv/RR2xaDUWWvrXDyLHCjRaqdGck8r/c98CAoCCX0h2WpfFhParni74cWw6kyvrAtmKyVj5ZPiA2vvF/LpQQUFv/2yjVMmX15sgj/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792400612; c=relaxed/simple;
	bh=fuxqQ+tD7DylDffylfpxIVNQwIoMDvXpxPmzZop1mxM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=uZ7ONiE/pKsl/+Ah15QGGIomqE+Tnscv3MSBMKdOQ+27WN+tz4BCdUQBvmlAtsULBgPPH1hMvP82yEOpFsSfmwVxDz1W1+SeZnsHNWelcNAKLfKlLEHUbWTuUJtoKSn44KOVtLEvhrSkDGWtmeeQtbIgfpKB3E57gTPub+B3DvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MnHymimK; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MnHymimK"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c20ce3c118aso340639766b.0
        for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 02:03:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792400610; cv=none;
        d=google.com; s=arc-20260327;
        b=KnnGuvDyC3cccx9pLbWMCAhwSOOwRSJKJ/AGHVlq/uNmY+kCTQqMK1OsaiUP2k840m
         6a4/PH7Xw4C9gcD/Z/QKuxU7VqjaJyNN3hA6JfRxIYdDu86XoU9FIQFMlgwBd8ueDwkJ
         e09JX8VKtjH0scna1bTb3EpruqDQfClV64+gNcIKlr5Lh16vA8nzE5MfqOBK+3EzBRPg
         DEAL8CT85exQdJZuNwzBsYXauHEgSeQNrAjPjwdOWxXPJufv7JfO5IDypDzKZGXGVod0
         naC5lXYdjN/r8wJtfZXqg0uSZx12J6Rf3jUbVKDmTUJoeFJHHN4nR7GBd9GesIJMOFQH
         0Riw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=btI5b4NYBKhWiTT7g2SaCW5SPW+H1/AeKO+HgacT8Bw=;
        fh=vpN+tPZ6y8zIOLe3VPnGYLIdyZA4NQ9WPTB/wrgFZ1c=;
        b=UivA/FpCI49dwiN1WrSrTYwdkGu+9lubx/ICrw7LFuPfBFcLiNiymBUTN6Mgi8tZYu
         1tSLkkxPdc8KvEuCdN1xN7qK6sNunMZ1vegaoIUYGEacHwC7w6mrdRV7E/a4uxA6nDC5
         h8FrlwclujwIJvLJ304A0JvRK2dOK1VyZYm8+RRB7YioGbW4ucQQW7tN6Jj0aZNJ168E
         X9ghKKOCyrhMvsP4LykzwdoUVSCTKEM6uuG5whae2WktSlthE1RB5Kpy+64GWeduarKI
         2OTEPe/YBYJCQQtEfGcemCABw0fqnzLV84jpQuutVWw7bLm6+xWHT6IYFCrP9meDIYXg
         0ClA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792400610; x=1793005410; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=btI5b4NYBKhWiTT7g2SaCW5SPW+H1/AeKO+HgacT8Bw=;
        b=MnHymimKCDg2vDblm3yT0A+pvzWDJ1gI33YFVI/PSfsUXMQaypxERtofuXMMpdpQPr
         FbV92P9Bo8gdDJR2dGEVuheUoar0ZwhvSupQ7wtGXymAdVK6kDnFOQXaObXSJTsih/VB
         Uo7qcu9QSaWPB/evCBH2TSBQ2BSkH30zc1Sm+LBppiI1GYMFm3GhTUE5wiUTsUKlNgnv
         cv/Dh2mzu2OZ8h65DY6wpIoDScWEjQ3koubONdX9GlA/hGVOPP79E7v3izibVZ6bU7k9
         L7UakgGM+/Q6pQYsdWvI9/9DhJQSbEDk9P3RkbXYqzaxZZReLX6OpcdXyLQC388GbglJ
         xbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792400610; x=1793005410;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=btI5b4NYBKhWiTT7g2SaCW5SPW+H1/AeKO+HgacT8Bw=;
        b=HQEIvnnzUIfGN54Ysk9qbbBLigjv6vxjagJsb5fv99Y9UJxG7HVDScK9YO+jab2mZn
         O/qsaFno4XNubedLaiJKA5eNoof4kBb5pd5wLf2yAs+mInsMhgEnHvyLp5ldYifL0NTN
         /7ctjcQJz6zfCKjygExki1PbZvrvM35F14VhIQ1I8gDYGOyAotVhvQA3g7fgrSIemPd4
         dqiqyrDidqtMgTnxJUUWVMqOSCDmwoGxb+nS+C8OSnGdPGJxhPOH+anaTpYgiGkz6MiP
         iGDH+xEqujyy3s/GwWU9ej7gh7vt0+iTzEwzmsYAhupHn45FgLDi/quKe/4VN+nTvnC2
         zxfA==
X-Forwarded-Encrypted: i=1; AKwUvByjT4YHQQSO1HK5fzvu8plvDvkxT8KQxfXROi3lsQg/WMX1Qgfv/vfc6IucBZkf4d+craJjC9mgnofX@vger.kernel.org
X-Gm-Message-State: AFq9FYJVAMUwJ9jajLkCcEsEHPKF7w3+tX8AMfg0ono99a84LojxoBhj
	y42nyHXSQFDJJySKa1LFme7tW0nLKMz6mLFk1x1FF9UOm24DhK0bUsGKdCPOVfT4aaE5kbxPa2o
	GhHIqNNpP6BsUdQP0Qzcq/WuNWkqOZc8=
X-Gm-Gg: AYBFou34fPdW/g3wTyjJtm0IU8lVlDzK0Ps1/vNZ9rSOkIvuS7kxj9fYeUw3+P9xjeS
	6IJMWTKcSinRoDBqGonVOVDba6wFA/NuVlZU3bacBwVdmhFfxSWF5g7NYRBqvWnTqB1mAWhHu/L
	HUsf6rlqUWs4srpe5hu1aA+cZzcBSMMkO8bC6pILG5uaeHvj2pgdVv9l3/eO2NV9sCEN/KwawAi
	uH4G3I2E9nHN2MbWpljrheCBVaOEBFNUXN3mieqLLmlHKy4MK+1TCtezrWX5ymnELI3jYcuL1Z6
	A70nPOU80zchzCoZ4AXeeiFv5SbtYN7rwUNkPfAQhqI47FBZ/DMof2WxJF+bPDXHgF9SSlHltBj
	R6EWzroouzs4R
X-Received: by 2002:a17:907:2d94:b0:c42:4557:452c with SMTP id
 a640c23a62f3a-c4245574af6mr347230866b.8.1792400609324; Mon, 19 Oct 2026
 02:03:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Claudio Fernando Pinto <claudiofernandopinto@gmail.com>
Date: Mon, 19 Oct 2026 06:03:17 -0300
X-Gm-Features: AclHuK_L8gqHgvPTdsvh6QXtOxLsYcgjeNl5xe03pNlJ309cbPzfcQHTAVmU44M
Message-ID: <CACs2WyyyGBxznvnJRDYWziAbzz8QROr41CF9Wtu9fOj7jX1fDw@mail.gmail.com>
Subject: overlayfs: unprivileged writes can use ext4's reserved blocks with
 the default resuid
To: linux-unionfs@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org, 
	"Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"

Hello,

ovl_fill_super() lowers CAP_SYS_RESOURCE in the creator credentials with
the comment "Never override disk quota limits or use reserved space"
(fs/overlayfs/super.c:1511 in v7.3-rc7). On an ext4 upper with the
default reserve owner, the second half does not hold:
ext4_has_free_clusters() grants the reserve when the allocating task's
fsuid equals s_resuid, 0 by default, before it looks at the capability
(fs/ext4/balloc.c:654-657). Writes through overlayfs run with the
mounter's credentials (ovl_write_iter() sets .cred = ovl_creds(sb) and
backing_file_write_iter() applies it), so with a root mounter the fsuid
that reaches ext4 is 0, and an unprivileged writer can spend the blocks
reserved for root.

Reproducer, a 64 MiB ext4 image with the default 5% reserve (1146
blocks), the same user ("nobody") filling it once directly and once
through an overlay mounted by root:

  direct:  reserve=1146 free_after=1146  (reserve kept)
  overlay: reserve=1146 free_after=327   (819 reserved blocks used)

v7.3-rc7 (24a19b953e2a), arm64 under QEMU, writer uid 65534; the same
on 7.0.14 in Docker Desktop's VM (1148 and 331). Script below.

I ran into this in an out-of-tree stacked filesystem I work on, which
copied the overlayfs approach and had the same gap. There I now run
data writes, fallocate, clone and copy_file_range with a copy of the
mounter credentials that carries the writer's fsuid, fsgid and groups
(built the way ovl_create_or_link() builds creation credentials, and
cached per file while the same identity writes), so ext4 decides the
reserve as it would for a direct write. I do not know whether that is
the direction you would want here, given the per-write cost and copy-up
also allocating with the mounter credentials, or whether this case is
already known and accepted as one of the behaviours that cannot be
implemented with full fidelity. Is it worth a patch, or should the
comment just say that resuid/resgid still apply?

Thanks,
Claudio

---8<--- repro.sh (run as root) ---8<---
#!/bin/sh
set -u
cd /tmp
for case in direct overlay; do
    rm -f img; truncate -s 64M img
    mkfs.ext4 -q -F -b 4096 img
    mkdir -p /mnt/low; mount -o loop img /mnt/low
    cd /mnt/low; mkdir -p upper work lower /mnt/ovl; cd /tmp
    chmod 1777 /mnt/low/upper /mnt/low/lower
    target=/mnt/low/upper
    if [ $case = overlay ]; then
        o=lowerdir=/mnt/low/lower,upperdir=/mnt/low/upper
        o=$o,workdir=/mnt/low/work
        mount -t overlay overlay -o $o /mnt/ovl
        target=/mnt/ovl
    fi
    set -- $(stat -f -c '%f %a' /mnt/low); reserve=$(($1 - $2))
    dd="dd if=/dev/zero of=$target/fill bs=64k 2>/dev/null"
    su -s /bin/sh nobody -c "$dd"
    sync
    set -- $(stat -f -c '%f %a' /mnt/low)
    echo "$case: reserve=$reserve free_after=$1"
    [ $case = overlay ] && umount /mnt/ovl
    umount /mnt/low
done
