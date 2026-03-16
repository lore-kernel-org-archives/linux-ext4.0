Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CC033A6F1
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 17:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683796; cv=pass; b=KGfojLw961Lup37/CZRMqY5nfHU5GXrh0wm2njRSv+b7o6oUydng+FfSdWgQ5gSejUH6Y9z3G0MuckejLsG2Qywyr+qHXxJAbRBJd/Axhs41mwn6vKyAV32RTnt5/QRZDH4p/bDrie4ObLrNGoSSBKbIUw9aQk1gM5jECg2sp5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683796; c=relaxed/simple;
	bh=I1vbAzFZtc0KG+gZfLVD1SzRI7ZL+EQR3nZxbZkmL9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UpQSdpyaXk+IL0Ul1nkDZ/KHJvm4TvZPo6mOZ+bT8DdJc7o1LLkIWuJM1IkPIx9J5st9lNE7DKu2NECIh4x1rTvHOuGHSr77ninXtVppyjdKz9fCtrU66QSDk/PPmxw1c3k3A5N2ja2Cuy0exaf7WprkOnwcrqHdJ0el2Gg6EV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VbqNu+T5; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VbqNu+T5"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43b41b545d9so1926035f8f.2
        for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 10:56:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773683793; cv=none;
        d=google.com; s=arc-20240605;
        b=Zv7BBjvfZz2LqaTRBI4HZu16kiQBLklNcuCoPkXdNvmCe2EYqxINJ/9YAxXFu7ITem
         QzJYuZdRAlrLfM14LGKQMtpT3CMC8b63YrvSbNAvXvpeXAtQ3JyXz40f5CduMMzY9Jmq
         IOcNRIe1WyI17sAX7BsjGdrKoc/juufe7nRthVQr41ADqy4OKlouPl3lef7rRRRY/sis
         JsOt1HHdcZvGvLU5NSv4Zb0KBE2ZCDb7Rq+PjW9cpmsn3XzE/Rjn3yhCWup9ZdtiGE5E
         e64t7/DrAnWl7ewwhO+at3SNt4YvsOQTibgrlGn1tDnquiwFjY2TVAvlnwboKeHRXvaf
         nMFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nLN8x7h3gKI0NxYeYvj5GuYRQATdaCAiSq+73Q3o4Nk=;
        fh=GuUYVvbSVFZH9cAVPQy/Fr5HMXO+hKdqxCNudOtMLjU=;
        b=asTDNjzoGwB55lQrOjqqZuCn3cSV0HL/bSAA47TVD1QHUxLt2qr0hTpZMDGRcsR1nV
         6KGELVvACPwO/C+7uNFBuqR3cVFjdEakmNVTVv9YhbkPa15Ar5xLq7S2X+CXZ+pfX8Yx
         SfF0ec1VWCrnRv/PWpOSpiD2Gv2Z9LdyfTtbq2JjJoNWN7ehuqXPvusvnaEkniqRmFHM
         SzQ9AZuvTAnz3fg1nayAYDIq4tpgo36Go/050r9hAemBfgugb1UEUXfVVPW7GXQkksTI
         p//9Qp6b/Ld7lYUcUxx8OvXPzDG4x2qdZLzttfWLBMn0hyh3sR6qjSTdQMkUkM+OWZOQ
         8oSQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773683793; x=1774288593; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLN8x7h3gKI0NxYeYvj5GuYRQATdaCAiSq+73Q3o4Nk=;
        b=VbqNu+T56XiJ5b6lsaCKvhkwWlyWO/maLFnOJHzDC2lyZ1i3OblWQqeaP2TokZTtco
         B2kbxC1MqknfA0jskEMTyn/BudH6NvwOU1WVCbIEt+eHcn/wGfGe5he8OpSlbouIgsP0
         zJHKHfYYbdqxqVj6XNv1ckge+NSwis+kPk3/Itz2KCPROhV97+GBlt01SLLhG41cqb6I
         htah7i1/JVmrHTjQ7m7S95XVbK194A72YT9ts98q4tBiD/ItplDdP9V7Ox28VXW3n94Q
         +JLOg26S7EaP6u9UwCne+Xr9+MShZOw1etgkpFpQYTPSw+D/y8Otsd/+Sw/I4vcAKqoc
         KsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773683793; x=1774288593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nLN8x7h3gKI0NxYeYvj5GuYRQATdaCAiSq+73Q3o4Nk=;
        b=OGGilqZT8wCyVnoqZx7G7uCUMzVVwlLHgPdjd4ePPGqLqQF8xUm6LdhAhZ/SY5F+5t
         Y/ING3LkuLJkOlHstEdPv/rw0TNIvpBY5Yn72RVn25sIVuejKk6e0ocB9KwYPGmqVG7+
         KnAxl7WIV10JsqSdExsrq4PqxlMzowvsyx3OFm3l7jkhBfA+K4jZOABF1Z8olGwmIfDz
         ygBsL2nDSvFaZL3Yo4jCQQCw2Vt9j6Nl5cZYAFVO8QlWXYTASSxQ2xqqCcjy5Qx1NCKm
         2TE1hp5JgEXiCeEcYiT/ntKy68+Sy9VvKakZyBjPrKmZMAr06uTA3HrqXDuGJqSLJMsS
         CrYg==
X-Forwarded-Encrypted: i=1; AJvYcCUAiQA2mFtqxmKvmJkHjL4JZDD8q8ZfCTSjehWS4xRaagU/ny8NB6YRse6fRwTQO3RziE3z0HlQLaiR@vger.kernel.org
X-Gm-Message-State: AOJu0YwvFw4pvHEy3UhwI65n/9A2FQVDrW+4zjCcLHzvFH079P4clTyP
	LUoDOcRsp4HQ3NzVtQWFeqWk6TYinXTc48giRbu46a0D+skYS/LrYR2X02uVcygZVXpDR+i7+eb
	elYIZ7cSis3bi44x2Wvy5r3DEXJjYJ8lPE7aYJ/8=
X-Gm-Gg: ATEYQzxek/8j1Wzcy+16P1bRQvd6QLU2ugfMJ5jiNJt2BiJ7gMA5IeBt/yYzo1XoDej
	vp4qvY8nU1YOQAPcltYsTb9elQFPvSXOhO9iY9p/5X2cTfWJs5CtqQN8FVGeoUda0p//l+bEOqM
	UgStvt5K4D5bXQH779VxW471u3gqpWp+DSBZu6BkeEJgnM7/NGube5YQtMh3Ut+Ce/ZfjbvMRxp
	M75hy6LgRq+j9gOUKAkMKmNIXCkgXq0TfofQ2OeYXu9ccTV99YGQFcuMAFF8QhbOvwYddcJuDR7
	2aM6aQ==
X-Received: by 2002:a05:6000:1787:b0:439:c6d9:7fc with SMTP id
 ffacd0b85a97d-43a04d95261mr25316775f8f.25.1773683793152; Mon, 16 Mar 2026
 10:56:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223224617.GA2390314@frogsfrogsfrogs>
In-Reply-To: <20260223224617.GA2390314@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 16 Mar 2026 10:56:21 -0700
X-Gm-Features: AaiRm511WAGRtITI8RxyWj-xfdb_uS3eh6Gi0osoQrCb5u55mxyV9n1ZU3-bjXI
Message-ID: <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bernd@bsbernd.com>, "Theodore Ts'o" <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>, 
	Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, John@groves.net, demiobenour@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 2:46=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> There are some warts remaining:
>
> a. I would like to continue the discussion about how the design review
>    of this code should be structured, and how might I go about creating
>    new userspace filesystem servers -- lightweight new ones based off
>    the existing userspace tools?  Or by merging lklfuse?

What do you mean by "merging lklfuse"?

Could you explain what the limitations of lklfuse are compared to the
fuse iomap approach in this patchset?

Thanks,
Joanne

>
> b. ext4 doesn't support out of place writes so I don't know if that
>    actually works correctly.
>
> c. fuse2fs doesn't support the ext4 journal.  Urk.
>
> d. There's a VERY large quantity of fuse2fs improvements that need to be
>    applied before we get to the fuse-iomap parts.  I'm not sending these
>    (or the fstests changes) to keep the size of the patchbomb at
>    "unreasonably large". :P  As a result, the fstests and e2fsprogs
>    postings are very targeted.
>
> e. I've dropped the fstests part of the patchbomb because v6 was just
>    way too long.
>
> I would like to get the main parts of this submission reviewed for 7.1
> now that this has been collecting comments and tweaks in non-rfc status
> for 3.5 months.
>
> Kernel:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/=
?h=3Dfuse-iomap-bpf
>
> libfuse:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/libfuse.git/log/?h=
=3Dfuse-iomap-bpf
>
> e2fsprogs:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git/log/=
?h=3Dfuse-iomap-bpf
>
> fstests:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/l=
og/?h=3Dfuse2fs
>
> --Darrick
