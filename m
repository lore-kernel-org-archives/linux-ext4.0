Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEA51A8F97
	for <linux-ext4@vger.kernel.org>; Sun, 29 Mar 2026 13:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774792126; cv=none; b=FxOhXCZ3opWw2APaVtTOYet5qAPHXiscm1VduSzGqDoDJHz802xH7QYaUzn2s/TS/hz70h/6S2JBE1oTVN42jrpXFqFoX40plUVgHn3Z0yeQKhQsZTF78YHXYeJQLJW5TSHz1+xl55tQh7ZKth5TDot9z1cToLovMG08dsdalaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774792126; c=relaxed/simple;
	bh=K56OFzg4/SNLrnzoV/wCAdYaff+37yevlVIivpvZOAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UlJ0P3O7SzlTPnd/0FphUhPUWEyxhCXHIE0YHqIBN9Dts0f6MRJZjYMNs+BNQuoMDLRX68+Lp3L6/IztTY70JAIzk4LiCNeL8ult9zateLJemXWG8ASGIGileesn88RuuklE1SjLk6Zl6DEVRhc6NNY9aQWAj5ZRvlEv3B+MVx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=fOOSpueT; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="fOOSpueT"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62TDmWHP002925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 29 Mar 2026 09:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774792117; bh=83LgLx9srnI2oUFHOLJUjbL2JTAbDfZdqDVG1bM9Sak=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=fOOSpueTsr4p2afEM+l58P2zXyvPZ+ez9wlulVAYl2ENWzPhpMtDQLfIw1Rnna3ef
	 3Jl5QiZfoWzmVcq9QkIyuqTHJdCb2BYJiJhpDrmy9PIHXBAmxXGx0THdZu5ELslSPG
	 yQGSIMEFu0ygiPFTbxel/xUtOsbfoUpiZo83oclFA22EiXK1LD2EI7VRylqcWagL3Q
	 ywmiL+1+dpAOSx9e186an5RHs1pTUjSp1KPIK1B+PBB6CDff+iF5p66f535pPDlUhL
	 EXJXJ6msNxZcdYeOVQgeE1Tq/FP0v/w2Y+cuTP7XjTPHT/ZRkGWN2EQnyF6DGYmYeW
	 Yns0+w+Tu0QhA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 57F295FE9FE9; Sun, 29 Mar 2026 08:48:32 -0500 (CDT)
Date: Sun, 29 Mar 2026 08:48:32 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, syzkaller@googlegroups.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Subject: Re: SYZKALLER BUG: messing with a mounted file system via loop
 ioctls (was: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get()
 to) prevent out-of-bounds access
Message-ID: <20260329134832.GA8782@Mac>
References: <20260224231429.31361-1-kartikey406@gmail.com>
 <20260326054718.GC4383@macsyma.local>
 <CADhLXY5E_4Hi=Uzu3LPwg_YNgcFR+UcAbfY-XzwVnmFBaJqjkA@mail.gmail.com>
 <20260327163135.GE4383@macsyma.local>
 <CADhLXY6QjWHiyY2MkUutzJK8utKghMTxjG9C8X7e=WDL5xKvYQ@mail.gmail.com>
 <CACT4Y+ZzbnD_puTRMx4MpcACpp5m3aMhQYvH+1LAyTKOz6otEw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZzbnD_puTRMx4MpcACpp5m3aMhQYvH+1LAyTKOz6otEw@mail.gmail.com>

On Sun, Mar 29, 2026 at 11:47:44AM +0200, Dmitry Vyukov wrote:
> Thanks for the report.
> 
> https://syzkaller.appspot.com/text?tag=ReproSyz&x=17a43b3a580000
> 
> Do you mean LOOP_SET_STATUS64 ioctl? It's the only ioctl in the repro:
> 
> ioctl$LOOP_SET_STATUS64(r0, 0x4c04, ...)

The loop LOOP_SET_STATUS ioctl is also problematic.

> Does it mean it should also be prohibited under
> CONFIG_BLK_DEV_WRITE_MOUNTED to avoid kernel memory corruption?
> Or at least some changes should be prohibited? E.g. I guess changing
> lo_offset is equivalent to writing to the mounted device.

Yes, that's correct.  LOOP_SET_STATUS[64] can set lo_offset and
lo_sizelimit which effectively mutates the loop device while it is
mounted.

The fix is something like:

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 0000913f7efc..c1d17e2bbd0c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1238,6 +1238,16 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		err = -ENXIO;
 		goto out_unlock;
 	}
+#ifndef CONFIG_BLK_DEV_WRITE_MOUNTED)
+	/*
+	 * bdev_writes_blocked is a static function defiend in
+	 * block/bdev.c, so this won't work as-is.
+	 */
+	if (bdev_writes_blocked(lo->lo_device)) {
+		err = -EBUSY;
+		goto out_unlock;
+	}
+#endif
 
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {

Turning this into a real patch that exports bdev_writes_blocked() is
left as an exercise to the reader.

					- Ted
