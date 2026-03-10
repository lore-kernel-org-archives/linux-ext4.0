Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43C62E2EF9
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 01:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773107465; cv=pass; b=mx6pcfvh7slfc5nNIUcZyCFKtmCY69I4mh0pWqxoCXFCbPbx2RGscKOtqv56HFVmfAOxFU3k/aAFnKPud9f6PDAR8JXpYeqyy/CwfpvzuIn3gwfQyIfNTGM535m/uQzCLQqlOBxjvHoWMuw9HwAx+2ItHczF7sv27BRihtZn1jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773107465; c=relaxed/simple;
	bh=5Wy7vs/m911oWggF5GDbYxDkcicngc2nA1xqoIpxDH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oC+5GqMtyYgeTNjPtxd53z4EpNoG2/TKbMNbi7Ob+jqP00eiwLW5q0SZMQgjGScaUUuJhLtlhwbMUhK3DLYMVHeivfKTlHBGWrugBUmLl1ewHjuCyHY0NgEal15TxsYG2pXvibe75C/h8MF6KXvQ3CvfOdLYOGDq0OplZjq4iOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SVd3f1DI; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SVd3f1DI"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7985d11da10so123215397b3.3
        for <linux-ext4@vger.kernel.org>; Mon, 09 Mar 2026 18:51:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773107463; cv=none;
        d=google.com; s=arc-20240605;
        b=N5ep/V7pVVLpqxX88jpGWldj+oShDLEZPST8MQ3mBKVrxWvBc5vCFGivkRCLOkt3AD
         v4bw5kHKgLcNYfCnLZvf3s/gMCjcZKCzRCI8fTjbJEZAA6zSlQgODV0wglX4LOPZdpqe
         ySp4JjZPP9uZJxlNPSW1EfaYtFy6GJY2GqzQWmw3uQuiiKcB4WymZGmNyzSwQ2helDHz
         gvOJ9PSIYTM/0gztVUIuuB4cb+x5BipmNxaW5aW1mRa/3j9v0I+m2fvqEzCerwyAbJXc
         Wws14EI2Tv/rlSO8kPmZhNta+pKmtkUZdZwb+RhtXcLholKG+5Xt2UMt+Ij5QMB7yGD/
         qcAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fb7dErrFO3aRtodXU23dX6jGWP4lTBbGdJXc5WtUxy4=;
        fh=fS6mglL2fr/EFmkxRh3z435EfqaHVTVRTkKKqES8JZg=;
        b=gf8eLQe2dfhsKl2zzUkRScYT4hsYmi6L9xQ8U+cMYPf1M9+HCWRJeMqYMzYwbwEAsZ
         uDvtoRKXBpY/olo9PHHhOFWt9WhtjZ9AU2DrVkV+m9rcan1JP/ZWl6WsecrxWKnbFkRT
         M3YHY7jey0odX9jmxbASM7pN812j3j7UewwwIu7fYeBcYRnWyeyh6zSB5/rD+ZmcXP+X
         jzyMQ91EgTvFXWvU1Z01IrLR8rWalYGKNgI23y0lNzavggeoHSMGoHYej80ADI47ECgQ
         VsK3LLKTSsDOj448mRh/xfMoR4pSlnF8f9KzsPwjO2GqBiBW3q24Auu+PxhyTvBBCbPs
         yteQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773107463; x=1773712263; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fb7dErrFO3aRtodXU23dX6jGWP4lTBbGdJXc5WtUxy4=;
        b=SVd3f1DIzsPk41MWaZuQH8Cpn/oNSXMN5Uw+Dv2WF4AWAnikY9kvJ3EdBnk0EzQ9Xg
         kIqhSNrDsnBRRIygzBK+TxTI/+115715Yt2kNtmyhAqsGZS50uKBztSdG+n46YlaFO0B
         R1Dt2t4do7Dt0P6IYI2kakyy9lADlBVN3TXlwj++EZyyWN1HmIJwSwY0V68Mc/xu6BEO
         qc2vRySvPFfiGMwsIYmTwupp0lNlZMY1tADsNZwnHeOAQjs7QtdW93tfmkp+UfHdP2cm
         v2lL8TgWZteiIXES1++rmHovXlhxUwn60DfAkTuezEeqPBvxhjfsss3f5dCHiJKIZ5eO
         qeyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773107463; x=1773712263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fb7dErrFO3aRtodXU23dX6jGWP4lTBbGdJXc5WtUxy4=;
        b=jfIz3XBqZqK/7xRZC8zK9OgUYyv8pliO1GHPmg3TsfZnCqKui18cfN5vrHTaUQ0Thk
         C9oxtOe1/EwbmykgRN/zp7sjj+XaORpoQ1Q2oZNGsz4I07A9JYmpx6Dq5jPdMkl+++P3
         hP2DMotee+W8Dv59OnEnrr8+xVfezjbBIQ9Dr2CeXjztACG3cJfnHwwYSFA3ZXTD43rS
         e6A1jzV0PaqiRgzYaqVPZu0EVanxjXF2wr+u1GfPypHASUO60lGMypc0RnBSqseFSXRp
         uSC5aK1SeJkd/AOYv593en1Ff1I3q2/nQM0Vqrc8EcwnT3RRY3KMFA5koQV8eFoeZ128
         KP9Q==
X-Gm-Message-State: AOJu0YynzjBwLa00SscbdrXIOv0Pgdohn3Zyw7AiZU/n093SDV4NVv/X
	1ArDcvjSOJP6nweJjcOBUb0i5HAwcjXX+C3Zl04s5d/hoLAcuVGy1cSotnlYLE3knVkrXvUjB5o
	oatCDoKF2aNym6BBI5B5S47/WfR5PJpwUgZQ5MUI=
X-Gm-Gg: ATEYQzwXTIrjsClHiSN/n9v0bNeDqG3EZaGziwegXk8ZjO7m5vRGgjyFrWFuv9/VBxf
	x1VXUu69ea6MBZ0YODT73V+Z9w/hyPv0NFe750MmDGSIw9vR8E1SWP/8MTczaRd+tZyD+esOhOg
	mI2MsI4XUbIVOWIgU3CPwIidw6H2592BWZAyQor0WNFLYgV/4bFVl6yn01j3A41GME4Na6KspFn
	ZpLD2WkMzF7CYg1oAk6j0onAzTTJG642wGLTla2BEJBeVIp+kBmqZEmotaA9HdQZd3wysaeXJnH
	qQKmPkHnq7iSHmws9E3f2I88gGrowJHsN6A+Dw==
X-Received: by 2002:a05:690c:f06:b0:798:6e69:244c with SMTP id
 00721157ae682-798dd6aefa6mr127965557b3.25.1773107462877; Mon, 09 Mar 2026
 18:51:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260207043607.1175976-1-kartikey406@gmail.com>
In-Reply-To: <20260207043607.1175976-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 10 Mar 2026 07:20:49 +0530
X-Gm-Features: AaiRm52_VqhSMoAuZK4g5bNDeZP7949gamkiGT7tYharPbNdDUVmBn9d_-vtfyU
Message-ID: <CADhLXY7Lot+J2UTYCgBKLMR7ht8Ye+iqPfERdzCw_aZnQ5gk5g@mail.gmail.com>
Subject: Re: [PATCH] ext4: convert inline data to extents when truncate
 exceeds inline size
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+7de5fe447862fc37576f@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 7, 2026 at 10:06=E2=80=AFAM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
> Add a check in ext4_setattr() to convert files from inline data storage
> to extent-based storage when truncate() grows the file size beyond the
> inline capacity. This prevents the filesystem from entering an
> inconsistent state where the inline data flag is set but the file size
> exceeds what can be stored inline.
>
> Without this fix, the following sequence causes a kernel BUG_ON():
>
> 1. Mount filesystem with inode that has inline flag set and small size
> 2. truncate(file, 50MB) - grows size but inline flag remains set
> 3. sendfile() attempts to write data
> 4. ext4_write_inline_data() hits BUG_ON(write_size > inline_capacity)
>
> The crash occurs because ext4_write_inline_data() expects inline storage
> to accommodate the write, but the actual inline capacity (~60 bytes for
> i_block + ~96 bytes for xattrs) is far smaller than the file size and
> write request.
>
> The fix checks if the new size from setattr exceeds the inode's actual
> inline capacity (EXT4_I(inode)->i_inline_size) and converts the file to
> extent-based storage before proceeding with the size change.
>
> This addresses the root cause by ensuring the inline data flag and file
> size remain consistent during truncate operations.
>
> Reported-by: syzbot+7de5fe447862fc37576f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D7de5fe447862fc37576f
> Tested-by: syzbot+7de5fe447862fc37576f@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> ---
>  fs/ext4/inode.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0c466ccbed69..c3dc0422ff95 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5901,6 +5901,18 @@ int ext4_setattr(struct mnt_idmap *idmap, struct d=
entry *dentry,
>                 if (attr->ia_size =3D=3D inode->i_size)
>                         inc_ivers =3D false;
>
> +               /*
> +                * If file has inline data but new size exceeds inline ca=
pacity,
> +                * convert to extent-based storage first to prevent incon=
sistent
> +                * state (inline flag set but size exceeds inline capacit=
y).
> +                */
> +               if (ext4_has_inline_data(inode) &&
> +                   attr->ia_size > EXT4_I(inode)->i_inline_size) {
> +                       error =3D ext4_convert_inline_data(inode);
> +                       if (error)
> +                               goto err_out;
> +               }
> +
>                 if (shrink) {
>                         if (ext4_should_order_data(inode)) {
>                                 error =3D ext4_begin_ordered_truncate(ino=
de,
> --
> 2.43.0
>


Hi Ted, Andreas, and ext4 maintainers,

I submitted this patch on February 7th to fix a kernel BUG_ON in
ext4_write_inline_data() reported by syzbot:

https://syzkaller.appspot.com/bug?extid=3D7de5fe447862fc37576f

The patch adds inline->extent conversion in ext4_setattr() when truncate()
grows a file beyond inline capacity, preventing the filesystem from enterin=
g
an inconsistent state where the inline flag is set but size exceeds capacit=
y.

I wanted to follow up to see if there are any comments or feedback on the
approach.

Original patch:
https://lore.kernel.org/all/20260207043607.1175976-1-kartikey406@gmail.com/=
T/

Thanks,
Deepanshu Kartikey
