Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948E5415F2F
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2026 07:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791359024; cv=none; b=RwGXUSYwBIxy6lTJIHOhGFF/Ri096gWYDPO1z+/2nRHMZMFwU/sNocIP04y1BaKqBac6m4Ua9mbrm909hS0n0ADYvkbBDdvXTTDWzo4zkOeQ8yeUTEcXGX+Os1BeAeKDsSm8BBpdkObtrbX7hrfh4ufNB+dSxscoREmNhLPErTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791359024; c=relaxed/simple;
	bh=v3zE8BK3Zz6jqBFdVmUbELCBSt6bNUgzEtIjKD6mfx4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=NTQN5qtb8csJ5rc1cTTOZOBzLtL2YUj8ELeOIsLy450neErZMburEwZN9ehTUBggZJYhE+hX8q0nwr1yuTIck3fR+oC6v4ufBAC+Bs7gcloChPR3sbIkiPGpMUZPAzQIgomfso/8HRlssnl6SJZehmb6tpCUIBruwBkX4oASonc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=Dcn7f580; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="Dcn7f580"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-398a4dcf289so1151660a91.2
        for <linux-ext4@vger.kernel.org>; Wed, 07 Oct 2026 00:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1791359019; x=1791963819; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GQicjEcdlh1TnS/6Ie/91AXB9eJFWVr14slz4D5RAfI=;
        b=Dcn7f580/tezpEauzZyhQF3dV4U7j9V2Fv6oSQCRJLJDw08UZ7dRT3LY4D8rVoAzfA
         B4Efao2l/E83+3VIegy9IaLQggDV9G72DLYG3t4WaWO8AnaxS7I8IawOVyLMm5BM41Xl
         2NsGfc00yhJoDQPqnlPJCp0hIAjalLsQu2SD61YSLPbdAFUpW6sC08RYZoiA7oJytCrU
         fh90HhZ/eGKlCGYXUIrFDLB/ueKu8tPUVrMcEbCTpVMYBebmdoj450J5zLtZkPAEzLnJ
         8lnWt4UNtFA3zPnTaAC+oz0AAoJRq5kpMBLlCWpr2spEgBwhYWoi2YiuPtI5CQQ8OOrk
         lKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791359019; x=1791963819;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GQicjEcdlh1TnS/6Ie/91AXB9eJFWVr14slz4D5RAfI=;
        b=dWCNegZwodQP6qx9wl30A24x+MGQJUq8KfKL7c1ZpSlwLyfhOtO/c8zjQDKb28nqbo
         RCBY3ghLOYgOObEQqENxuN2ettyiBXowPfN5El98WZtTxQLszyNjPXSD3NJxzA4m7evE
         arelVTJeiPZ//6YYp5BpJ4kQzMvzpyViZkDY7fJvf+VLGBQtTrs4xkj3lk7fbs+gd/f4
         uP7nfCM905uXnAWrjgX/1Kf870USXL/Iawbsjjj/Z7m97RpZSp3feDjg6Yg0mViZgk6b
         d8Beo+0waB1/M2khEfSL4RZTyTdtneLTE/Nqh82H6Tjs0h8l7XivAx9OxsvmPZVLfiUw
         0gSA==
X-Forwarded-Encrypted: i=1; AKwUvBzxf5nQa5ljrnnMPWGhc5MwMb8cqhBMitBBhK3atl6V+BVL8g+tS3y+VTmCLET2+G5VG4sxKHMwifQK@vger.kernel.org
X-Gm-Message-State: AFq9FYJbA1ixaCXo38RuAxYwqU1K9sr9/DQr0P56gm+qQrwuOivaJ2+Z
	e62QDO5s73QqHis4t39H/uQ1BnEKqSWYJjeOjCi5sFxgEaKydyVb0S6NafBEM97GZxU=
X-Gm-Gg: AYBFou2PuTnHBiLla2u6qa7wlQxUVZskpeA6+8GUF2GtNa1nIrNjbYbjNgrvxNCWF16
	BrTniO0wy2W8Dz00DWbeGffqn3dLzCMfmyeTHnEceCy2E74XJb/P0pkvjQSEKoTaAPA6XKLZCoA
	d9rEImfKnbCOh7kZbWD1foVQ7nSgDZgWU0qMr0HYvgIOxEAfZsLXNrJbuU1hnUmjDI9qQQzJGpu
	d6bIvaAPDByvO4GaSuaCxVJvyLGkf9nveiFWLUWK44YODqro+m8SAsAx6tccm+8qHy0GEk4i+Tf
	zPfG8VhFfKD9sYwO7ek64DU70O2DpEaizqeAVL/YYVLJpz8Jrrb+Ez708NHPhyi4k9gc0kgb2P3
	aDkg3pCL0g5JgSWx+f7ZGp8u4mHob6lL5/RggiJaMJVfHBYwfmpU8z9sSo8T53jzkxe2L1wPLHq
	kKITfaMNbMZMtCLVmKjtHX6C9/y5+JFpZcV71C2JxYAgzjxgKG6N3p1GTMulBMpKa5wDiUNGOgY
	039ES/28hgRQPpAnhbe4Szz5IoMVJJ+RFHjfWV3DtJJSaGWSg8YxQ==
X-Received: by 2002:a17:90b:1345:b0:3a6:d94d:e147 with SMTP id 98e67ed59e1d1-3a8a0845138mr867138a91.15.1791359018649;
        Wed, 07 Oct 2026 00:43:38 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [24.64.171.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8533aba95sm9993693a91.2.2026.10.07.00.43.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2026 00:43:38 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.3\))
Subject: Re: [PATCH] ext4: do not accept rec_len 0 for block sizes below 64k
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <qvaeibtro3i7xxpxbgomjmsvnaejtlo5if57lp5aeowl42e6v2@x3ckk5ovep4s>
Date: Wed, 7 Oct 2026 01:43:26 -0600
Cc: hengyul@cs.unc.edu,
 tytso@mit.edu,
 linux-ext4@vger.kernel.org,
 libaokun@linux.alibaba.com,
 ojaswin@linux.ibm.com,
 ritesh.list@gmail.com,
 yi.zhang@huawei.com,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E54F7146-77CB-4E75-832B-F760E289584E@dilger.ca>
References: <20261006111546.3252481-1-hengyul@cs.unc.edu>
 <qvaeibtro3i7xxpxbgomjmsvnaejtlo5if57lp5aeowl42e6v2@x3ckk5ovep4s>
To: Jan Kara <jack@suse.cz>
X-Mailer: Apple Mail (2.3864.700.51.1.3)

On Oct 6, 2026, at 10:16, Jan Kara <jack@suse.cz> wrote:
>=20
> On Tue 06-10-26 07:15:46, hengyul@cs.unc.edu wrote:
>> From: Hengyu Liang <hengyul@cs.unc.edu>
>>=20
>> Commit afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len
>> conversion") made ext4_rec_len_from_disk() read a rec_len of 0 as =
"this
>> entry covers the whole block" for every block size.
>>=20
>> However, this special value only exists for block sizes of 64k and
>> more. With smaller blocks, a rec_len of 0 means that the directory
>> block is corrupted. As of now, a directory block that has been
>> overwritten with zeroes is treated as an empty block. The kernel no
>> longer reports the corruption and can store new entries in that =
block,
>> while e2fsck still reports the block as corrupted.
>>=20
>> The issue can be reproduced on a file system without metadata_csum:
>>=20
>>    mke2fs -q -t ext4 -b 1024 -O ^metadata_csum,^dir_index img 8M
>>    mount -o loop img /mnt
>>    mkdir /mnt/d
>>    for i in $(seq 100); do touch /mnt/d/file_with_a_long_name_$i; =
done
>>    umount /mnt
>>    dd if=3D/dev/zero of=3Dimg bs=3D1024 count=3D1 conv=3Dnotrunc \
>>        seek=3D$(debugfs -R "bmap d 1" img)
>>    mount -o loop img /mnt
>>    touch /mnt/d/new
>>=20
>> Before commit afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for =
rec_len
>> conversion"), the last command fails with "Structure needs cleaning".
>> After that commit, it succeeds.
>>=20
>> This patch makes ext4_rec_len_from_disk() return the on-disk value
>> unchanged when the block size is below 64k, as e2fsprogs does.
>>=20
>> Fixes: afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len =
conversion")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
>=20
> Makes sense. Feel free to add:
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
>=20
> BTW, the kernel never allowed larger than 64k block size so I'm kind =
of at
> loss why we have that strange code trying to accommodate upto 256k
> blocksize here. I'd just delete that code (not really related to your
> chnage). Ted?
>=20
> Honza
> --=20
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

I think Fujitsu was using 256KiB blocksize on SPARC servers?  Something
like that, but I never saw any patches for it.

Cheers, Andreas





