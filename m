Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE283A9DB2
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 11:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790161819; cv=none; b=VZ1y0RCJ4l1wCPY2T0b861bsL7b0FSj1xm/jDNS53r1dTUwGEcii7N4YD5sfARi/rIGDossIfFOodwa+7h4Hjd/R/bbK56Ccijo4HU2J6Sw96EfUSPpVVHnlW+bAVHsvqtj25U7MIjQJUokYbQfQ6p4mbZ2icJBPP7c2sqneMZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790161819; c=relaxed/simple;
	bh=A/+Sr7tx4D5ZREKYnrRAnL8aFLsHkN0hJrmaBtU7YrY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cjBXQh7l0rk1h/S2ajb4+nunoPn4NZiuhAU0IgiTpQou+DNh7u6o+b2XdyNu7AkvMTCCB4fV+pcGpN3NrDH6kb+kW05H55Q76BEXMCXijyr2dbeiBRco253BdTP3mR5y/5SgW3CnpITatO+GK1sg3ZYLUZ67c9/MnsuZ7MvtcYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=mgy7NTI/; arc=none smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="mgy7NTI/"
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc750a1482fso558949a12.2
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 04:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1790161816; x=1790766616; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Z9avEEAnjpEf+bLzxYVfU8riO/8xZqKHcMVkzWtu7O4=;
        b=mgy7NTI/3R1D/3AMop0EXt9y9YxnWS83VYR5w+jlL103Ij8Ux9J6/pMqy1NX9kHZOD
         BmFw4rtEZ2ImFnunwfOPOly/2BwNZU7j8d8BdD6pmw/waKumV4YZDzg2MplRfijSR27J
         9we+PEQPMrUUxuaPUL1h2CJEVTa9TBswXl5c1oMUwXgawturPgJ8e7LDFWFYZcmQsEZX
         1Mh83c2Rdr2/gH9j0L1OdogEKgEvodNMnTfPCce0oVoK3uPV8eJvk3GiifUek6cF1E1h
         usLT6KVoW/djsoQaqzoD+hg/7zCUKajZikNywpWPQXawUrN0p7fP2ekpZartx7MN8mGd
         h9Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790161816; x=1790766616;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z9avEEAnjpEf+bLzxYVfU8riO/8xZqKHcMVkzWtu7O4=;
        b=V8uZub9P17MbuWY49x0Wv80xldg+K+lpb7aD2PAdEDhBs3wR2Iyu56850rgqXVAG5f
         BD939aH4Knyi/yrL29QRBJGoxZWskRyu2F21lWPVvtWvMjjDFBbH1RVYvhcFmXCRMYfB
         kcPFGkklz3XoM+Muq+x9/JjJ52zVsJ99CEmzJOB4b2rZy9QSaXVVZ051fJsX12psxNm6
         g1avQlkwIoyluEH5kU6vNhnDVMjSmgLuHxtbkhFqIR6PNStYJANX820wpKOduHzWQ3Mz
         +05dgtbasc8uunZE6sn4GAStI+ZR9N0JAK0Maa9Dpdhfalydc2Z3T8gPpplWaB5fDjuh
         IgSw==
X-Gm-Message-State: AFuF++ngG1Ff3ny0Zd/ZErM8sUDHasfbIGElAacSfsB8PeC7yF0VcbvT
	qcghC65YzZG8ZPEHUYMA3NudrR3VneCZcpQ/t/ZmrobbBRj3hsAoQ31ULzJ4puCWECY=
X-Gm-Gg: AYBFou3u7watUve0R8QSPY6Ifw6o7g/mQn+XMU86C0GLf6GZVwWT/1Ty+eDGtf0+jp7
	bDpyPPuTpXNK8VESLNaLce6myA+bBNzXMvfwosNVUDk32pjjvqHHWYnFfVZORQv2t0sG0/5GCAP
	IHJ0CJ9bSoJ0IDtYgQph/f+Z/c9V2yzhnfpO1dftoLqaIesMwd3DGe/rG78Ge/ARvp5W5CrWckp
	0m36dLOu8lhgvZrDi7DOG8GpsTgPkJSYn/YYZ5bZKAbxqrUuykgx1PXFj1mQ9s9e8M+yBrzFvoP
	UCb/f25Qfrgb8syqn1Pcn7utkJPmMHHh/LsgqW9lgnF+LZ45dH8CqiUH0n6m6a5DxNXYNA3WzMk
	Ir/pQW9BEEjQB5SqQETLWLz6DVl729LF9IZ8ZTRc9KnvJ+5PROxMjOTt8xrklJYc4+Qwk76MGRy
	6Y19edIWlJKRSZdCOityzKeWbqun4hlRyEVghmShTz48xjtvwNPgaTKRFIjFTXbPQURoqt6o65t
	qxxFBSOuJzoo0I3H4FadZqg5I1CX/wDtBhMSncE1c46SdHo6/6wlLa5Slzw9BLH
X-Received: by 2002:a17:90b:3806:b0:3a0:4146:2955 with SMTP id 98e67ed59e1d1-3a07e693c71mr1949123a91.61.1790161815923;
        Wed, 23 Sep 2026 04:10:15 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [24.64.171.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07db882a5sm4644779a91.1.2026.09.23.04.10.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2026 04:10:15 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.3\))
Subject: Re: [PATCH] ext4: clear in-inode xattr space before adding the first
 xattr
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260916084723.877552-1-r772577952@gmail.com>
Date: Wed, 23 Sep 2026 05:10:03 -0600
Cc: linux-ext4@vger.kernel.org,
 tytso@mit.edu,
 jack@suse.cz,
 libaokun@linux.alibaba.com,
 linux-kernel@vger.kernel.org,
 ojaswin@linux.ibm.com,
 ritesh.list@gmail.com,
 syzkaller@googlegroups.com,
 yi.zhang@huawei.com,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <50CE75D5-930B-4DD6-B0DF-7B956EBA0A62@dilger.ca>
References: <CANypQFZzxTAH=4QRRDoqH6VAw1daAq88NDWiQKoM7QTOnP40sg@mail.gmail.com>
 <20260916084723.877552-1-r772577952@gmail.com>
To: Jiaming Zhang <r772577952@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.3)

On Sep 16, 2026, at 02:47, Jiaming Zhang <r772577952@gmail.com> wrote:
>=20
> An inode can hold extended attributes in the space that follows its =
extra
> fields, whose size is given by i_extra_isize.  When ext4 loads an =
inode,
> ext4_iget_extra_inode() validates that space only if it starts with =
the
> xattr magic, and only then sets EXT4_STATE_XATTR.  Without the magic, =
the
> space is treated as empty and is not checked.
>=20
> ext4_xattr_ibody_set() passes the space to ext4_xattr_set_entry() =
whether
> or not EXT4_STATE_XATTR is set.  ext4_xattr_set_entry() walks the =
entries
> there to find min_offs, the lowest value offset.  That offset decides
> whether the new value fits and where the value is copied:
>=20
> free =3D min_offs - ((void *)last - s->base) - sizeof(__u32);
> ...
> void *val =3D s->base + min_offs - new_size;
>=20
> A crafted image can leave non-zero bytes in that space without the =
magic
> where ext4 looks for it, for example by shrinking i_extra_isize.  =
Those
> bytes are parsed as entries, and an entry that claims an in-inode =
value at
> offset 0 sets min_offs to 0.  Because free is a size_t, the =
subtraction
> then wraps around to a huge value, and the free space check passes =
although
> the value does not fit.  The value is copied new_size bytes before the
> start of the space, over the inode's own fields and, for a large =
value, the
> memory in front of the inode.
>=20
> On a kernel without KASAN, the copy corrupts memory: it overwrites the
> inode's own fields and, for a large value, also the memory in front of =
the
> inode.  The bytes and their length are decided by the setxattr() =
caller.
> Nothing is freed and reused here, so the use-after-free in the report =
only
> reflects where the write happened to land.
>=20
> Triggering this issue requires mounting a crafted image, which needs
> CAP_SYS_ADMIN or automounting of removable media; after that, any
> setxattr() on the file reaches this path.  The issue was found by =
fuzzing
> and has not been seen in production; a reproducer is available in the
> linked report.
>=20
> Clear the space in ext4_xattr_ibody_set() before calling
> ext4_xattr_set_entry() when EXT4_STATE_XATTR is not set, so that the =
walk
> starts from the empty entry list.
>=20
> Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
> Closes: =
https://lore.kernel.org/lkml/CANypQFZzxTAH=3D4QRRDoqH6VAw1daAq88NDWiQKoM7Q=
TOnP40sg@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Assisted-by: Claude Code:claude-opus-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>

Looks good to me.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/xattr.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5c310747b965..2e5f39b710bd 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2274,6 +2274,10 @@ int ext4_xattr_ibody_set(handle_t *handle, =
struct inode *inode,
>  		if (IS_ERR(ea_inode))
>  			return PTR_ERR(ea_inode);
>  	}
> +
> +	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
> +		memset(s->first, 0, s->end - (void *)s->first);
> +
>  	error =3D ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
>  				     false /* is_block */);
>  	if (error) {
> --=20
> 2.43.0
>=20


Cheers, Andreas





