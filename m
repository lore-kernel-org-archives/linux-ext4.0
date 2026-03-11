Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235982FDC3C
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773241298; cv=none; b=luCS1p0wREpjzvSSDKqUgkfsA0sV0KOfZeLYF9JjKHHp9Klfa/ohcLLkayipURyWmBfong4G0Y61OTb3swAa+kKAfPrrzmWKdgLAMEwDt3hZN3wxvcK4mwWwpN0grenLC2bJykLKnu3LSOMktiHIvluvHAWJQvNZGiP/oqikrg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773241298; c=relaxed/simple;
	bh=IyLH2k+zwc82o1pCD8DMWR7DUb7VWMYDKxI51dDbhiQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OXonuFsGyuE0II5mJXXoVx0WL//7DwD6M8rtoVBf65Ppya6CQ+yCKKG0w8rZBVq5v0zTdmZ2IRw+r3nkOzPYH4Mqv+JsbSqqRPRuifOo5uBuHzoEiCUU3x/quSbP0NohPfHaM4SCZsiyhzfmeVmjpd74fRUSzRQqt+coIBjoeSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=MPnUT2rI; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="MPnUT2rI"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ae8177446fso292165ad.0
        for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 08:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1773241296; x=1773846096; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/m3APkVwaz7cnv5QQaedLO78sw2ETi+1doLeRrtzYs=;
        b=MPnUT2rIPg/iPLl6+OwpOVnhBR1zHplCvcSbsao792zIqmHOAZ7cRsxwieZL0kNcQe
         I0vaprOEs8Xm6zM1cdAYgrVYcWVAHuZznvX2j2atSaOA3AXiyJ1L5LnjUWNbyUDfcC+x
         s9QwrHvmPbzOR8Q52Cw9H/tn4WOEcZki8wptveWKPonkfv8GV8o4uPT5hc8q5IggyX2+
         ixPYoYn5fVKGwwG37Zr/bhN46cbZZPZFt1cBXF49+PWT+yDjF49UYsU/BOnbOEScr+WG
         T47csMBmFQs7PbZ/hTJd9GjRAaKzQP3Wdzxbsqy1NKfrFNnRoEMBDKRwnP3+8a64Dn6a
         y+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773241296; x=1773846096;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o/m3APkVwaz7cnv5QQaedLO78sw2ETi+1doLeRrtzYs=;
        b=k3ownezJ7NlB4fjRipaxtzNQFaKBvAGqzyLWrDsbAv1KpY2NUs7RcUt4DnHIy9z1BF
         TKjuDV9g2RWl/5Zqvd40+XN0glGsp9z0GOlkqBNBnAK/VUJ9Qm3x9/F1hJGo0OsjgRR5
         bofYvhbRpSvBMENxcMs3edO2bjGkdgskzHWshlQs/jnUmkm1hNcTV4pDlnJJoaRu5vgI
         BNcBWccm2e2I3AKueows2CEfStCjoHwmRkTEmXZkB4EFh4Oxw2WivmJaOsRCoYnyxzYa
         v7rM1kOAIwXRbxDU636rC6gwjtncGBNZKSXkBoAJnvXpjwPgdhlL797DFGevysbZg4el
         M7+g==
X-Gm-Message-State: AOJu0Yw4rPV/8Vj/9fJqUiLOdej1NggfRvNR4Z1PtQmPrMJqnePemm0f
	rCl6f1cmYshw22TMGAItu7PccmXBhCjL2sBXxYmd15xE7xDDtAuW8m8+rKlhYbHQHTU=
X-Gm-Gg: ATEYQzzF+WpdCKlfj1ooUN/iMsw8aFbA8eJc7fCiCbyY2ghRhhI2quCsnyL1YxI3eeH
	QsJVp4gZNbNz/v6BJYhJRfooSzdzM80fMd4Mzmj00ykftzjVK6AQHNUrYDn6PozFK1znCUoYUGN
	6hs03R51CLh8sIEhxFb7NhfpQ7KKMZPp8TWH8/64vT7xiQ2G4NPxlEtSr/Kcjdl8/a37GXE5NJb
	Cq9X0jq/2MBFjFm5oEKzUoGBvPdxPNCxFq9IUSKn8w8aEW58+ZsGdpM/BkgzjMqQgJYwtkmSRDU
	DboL+zAP7uHbQ+PrjJC58q5UnXiFaHrXrH4bTYKEyNCXEAgxCvryVl3xtA4JqSZNFC1JsU7KQoz
	6RiP14wF4xXjOWjDa9V0vjaGUBN0kUFunJOr4X3+eLgxbbVA0yjdNDA2NyvqcrdDbYJWCIF1Saj
	Jfoz6YlQv6+Rdpks1skjB/45tkqztkfI4C8uPBeuYSQFjcP0N/JhziXs9ilPS+Vg+B8viwvKIGj
	5htw06rXd/QzMgM
X-Received: by 2002:a17:903:b8e:b0:2aa:ea8e:f118 with SMTP id d9443c01a7336-2aeae78ba2dmr30288155ad.3.1773241295656;
        Wed, 11 Mar 2026 08:01:35 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae34dff2sm27955625ad.57.2026.03.11.08.01.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2026 08:01:35 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] Fix default orphan file size calculations
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260311141150.120724-1-tytso@mit.edu>
Date: Wed, 11 Mar 2026 09:01:23 -0600
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
 Baokun Li <libaokun@linux.alibaba.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DEB93556-A9E3-457F-8C6D-F09A4D025AB7@dilger.ca>
References: <20260311141150.120724-1-tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Mar 11, 2026, at 08:11, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> Due to missing parenthesis around the #defines for
> EXT4_{MAX,DEFAULT}_ORPHAN_FILE_SIZE, the default number of blocks
> assigned to the orphan file was calculated as 2 when the file system
> has more than 2**21 blocks:
>=20
>   % mke2fs  -t ext4 -Fq /tmp/foo.img 8191M
>   /tmp/foo.img contains a ext4 file system
>           created on Wed Mar 11 09:54:04 2026
>   % debugfs -R "extents <12>" /tmp/foo.img
>   debugfs 1.47.4 (6-Mar-2025)
>   Level Entries       Logical          Physical Length Flags
>    0/ 0   1/  1     0 -   510    9255 -    9765    511
>=20
>   % mke2fs  -t ext4 -Fq /tmp/foo.img 8192M
>   /tmp/foo.img contains a ext4 file system
>           created on Wed Mar 11 09:54:11 2026
>   % debugfs -R "extents <12>" /tmp/foo.img
>   debugfs 1.47.4 (6-Mar-2025)
>   Level Entries       Logical          Physical Length Flags
>    0/ 0   1/  1     0 -     1    9255 -    9256      2  <=3D=3D=3D=3D=3D=
=3D
>=20
> In addition, looking at how the defaults was calculated, there were
> some unit mismatches where number of blocks was compared with number
> of bytes, and number of blocks divided by the blocksize.  As a result,
> the number of blocks was much larger than before when the file system
> blocksize was 1k, and much smaller than when the file system was 64k,
> which was a bit surprising.
>=20
> This caused a libblockdev regression test to fail when it created an
> ext4 file system using a 1k blocksize and had a size of 138240k.
> Before e2fsprogs 1.47.4, the size of the orphan file was 33k; but in
> e2fsprogs 1.47.4, the size of the orphan file became 135k.  This
> pushed the overhead just over 10%, which triggered the test failure.
>=20
> So simplify the calculation so that default of the orphan file ranges
> from 32 file system blocks and EXT4_DEFAULT_ORPHAN_SIZE, and avoids
> the use of the file system blocksize.
>=20
> Fixes: 6f03c698ef53 ("libext2fs: fix orphan file size > kernel limit =
with large blocksize")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> lib/ext2fs/ext2fs.h |  4 ++--
> lib/ext2fs/orphan.c | 12 ++++++------
> 2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index d9df007c4..92da4d140 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1819,8 +1819,8 @@ errcode_t ext2fs_set_data_io(ext2_filsys fs, =
io_channel new_io);
> errcode_t ext2fs_rewrite_to_io(ext2_filsys fs, io_channel new_io);
>=20
> /* orphan.c */
> -#define EXT4_MAX_ORPHAN_FILE_SIZE 8 << 20
> -#define EXT4_DEFAULT_ORPHAN_FILE_SIZE 2 << 20
> +#define EXT4_MAX_ORPHAN_FILE_SIZE (8 << 20)
> +#define EXT4_DEFAULT_ORPHAN_FILE_SIZE (2 << 20)

Some of the issues here would be avoided with better variable naming,
like "EXT4_MAX_ORPHAN_FILE_BYTES" and "EXT4_DEFAULT_ORPHAN_FILE_BYTES"
rather than "size", which is a bit ambiguous.

Cheers, Andreas=
