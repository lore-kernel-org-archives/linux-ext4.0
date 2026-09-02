Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4520E3624BC
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371154; cv=pass; b=QjTbo5RV8N7pZSvJhWdZLoXuT//hGz5Q9QBLCta/tHZaNYxToQ60aolM+V+OqWrDpKFHVhsH1TPrAMvsdEH35x9bWiAZ3dDa2dcWcXrEjenn42pfRukIep+p+TCjYOQguP7kZlKuna36EFYMiP/MrcXK0p9NjdTLP36Tini0mQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371154; c=relaxed/simple;
	bh=K0HXSYdoGd6S9dM22plvKSCWPk9aEGxVwTcguAvww6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PLPkQqyPFbxieujClOpfkO05VrgIqaWc8UNUP4VKgCl4Do242pyGacbE38r0uGaEtc9W4aFk0kO6QcRXpa1Q2InzJtO41GfRS6lhygTzCL7fdn+AP1KWiauXUs8PRPkkCCXWFgeetnuA5w2jNHRuvfWzuCjINOVgmIxJ6CwR3OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VlsTot0D; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VlsTot0D"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-482f2ee53e7so883507f8f.1
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2026 10:45:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788371150; cv=none;
        d=google.com; s=arc-20260327;
        b=s5dn5BG0XmYowLaOXuuISmCXS+NwFX+4PfcX/4iKtUXQtbf92HlrJjQSXgvJQNEBb+
         K7RFJsBtTyUyb10tfd+GW7m+drnWFJ7eJ57Fo3klC8GVdYCtkQOUQp127dLFbavSSXyb
         iySNvw8b5QYbyUTyCbc1rmyxpGNSv/OVdqHb1GyguXWX8OWC1lQJTEXICvDV0WPjjkvL
         ezVt2O9LaD0NEyEDOkACN4x0MzcBshlidm+pIFArLo4kxPTawZNx/m5r6Pwfa0uIwxlS
         VR01z1j3MHf6R9lAKHHoGP/86xHVqbWus+7w84X/yK7cfcji2lNbHssFY+XkrFzMd4ma
         3L9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c5v4QLo29+9sYIlbxOvZxTqf1Ctg+I+izJ9dnI+b66k=;
        fh=7LXQ04imIF0DlmuDHNqpI8b62OrG19xNDMvsszScMVw=;
        b=X8pfuYvZO2Q/bFpxt0jKVtzvNeC8zHlomJuLTzN0Py2qQ9uJTzUxuNBg02eQFXcuvC
         6aIf7MN3RsAtgEiQc5KigIQX31uxX7V1F8ApxddRkLFrZ2g+q8eKW9A1FA5Cem4Ix0gw
         5dEXPmj1uYJDJbm8FeVoXo1ct+yZN4dNZ4v99KRMwXKIoxEmBVHvVPwXEvBuCzm15uus
         NCCOoCB27Az0ZrrnHL+QlK2uOXeEbSp+v9d0OzjHHn6g10il0YpgpYB3PE2oP18PFRpZ
         p7VXWOjkU24d/8cufDj84ckf6CkeWd1KXvEAuOWM5sxrkqYvIpPb+D46BYBbaO3jNGr0
         +1Pg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788371150; x=1788975950; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c5v4QLo29+9sYIlbxOvZxTqf1Ctg+I+izJ9dnI+b66k=;
        b=VlsTot0DuYqoC1uVS0+e46rqEw54gX/8RoJftJey6uS4qtgDyq2L42tIag4JLFES8b
         e3SxHmU3++trX1P8SBayIhCmUWHGU2UfEmpfswvTXYROB2pyACACd1td5jpy6hx30FFF
         NzjzBKb74P9EIc/I72L/cR+5J7mkkJSphddDr/VBQ9edji6L5bp8n9Zwqjldd6kD8pG6
         n9eMbLMjt6OgCbjxzXQeiVMlGFXar+2+n3PQqV4/mQCgH6Nm2Oe1cUxp/Fb8h7bNSekx
         kSU91cyvRwriwlXN9VvExNqQzsVNKDHJkn1KmM2X9ovsVYdbd/22I6sZeNs6L6/BkgBW
         ugOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788371150; x=1788975950;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c5v4QLo29+9sYIlbxOvZxTqf1Ctg+I+izJ9dnI+b66k=;
        b=mS9diQF3BMAksbjBrGsPZaVJ4aCkc6Fx4WXLU6vW4rkjg5WE1OfXenS5k9isQ+z2qP
         265a/ldr2Nwae6UNYus6x911zqarSoAzCwXmbuo4ag/9Ntp5MDBQx/mNnmYguH/mP5BH
         WKclbWn1qjPVTmsb3lp5cupYQ40MLX78lZPJw3TamE76xOfw/Nz0+HJ08rkcmzFj5dQi
         GusONO7WrWHTragolxp1nfIvw8d1GHy8gJWsra1Co8zmaiNOrRfAGbJpq4RkhhoR48/I
         Lo6m7f19leHFRThDhVmofQ4DzeSeUlGHwWFVGcqGDNxzOr1J2cgLB6e27RkuV2ulwxZE
         VaSQ==
X-Forwarded-Encrypted: i=1; AKwUvByEMSjncE5kIzwXGkLqpi8/Ky7Fn+2DUvZ9lb44Nm+QhM7Rh6KFE3WPlDr7uLEeusqb2GyU8pNYC5HK@vger.kernel.org
X-Gm-Message-State: AFuF++kts6n0LGNCs4qfXLfTbb6aGu9jcUYGZzN0JAOcNUHr8U9Tqm7L
	T1uAvyLH907zKz0/PsuHtnTqTkVZv+KNmKWGznwhfI4cvHUtCQF6sMImfZFolXkmyHjiIdGtCWN
	yRJyFTDOui1PKUmehVjy0sDAiR32eRzw=
X-Gm-Gg: AYBFou3+TZ+c8Gs3QDfVD8Sezj13axxiLMkh78MLRrKeLGJiKFSYahQRkhSiv4ZXnpv
	YotGpAFsMeZKyYNNeYBqjUSVBL4e5eyeXrCoYF3IfQjS6/JV/WAZAnmj6GobqNU9TYpxSlwRcdv
	RudeY86Bbnx6RSS8faNJ6zP2QgMTRizkc3Jz2R61+FuLrXYRAz0pFqvwiFO1tQlWnkm75/602JF
	u5ofTrx+9E7aVk74/Xg/vGnoHU9HGd+JuVMmH/EuDj2BWVo5LXmhbk2e/X3LOO5OGjXbP6Zjycs
	zCtbtUAWBr+w9mVhLExWNRH+71KWa4py7yVTxBHnv23HXSESuWLhnEnQPBXEDmnX01fR9jmOtCA
	VdSCADFeNilkklyuA1oj8iF1s4hE=
X-Received: by 2002:a05:6000:b8b:b0:484:4874:db4e with SMTP id
 ffacd0b85a97d-484913b96damr9005716f8f.17.1788371150252; Wed, 02 Sep 2026
 10:45:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
 <20260730-habseligkeiten-adrett-axthieb-e619a48325ad@brauner> <20260731-hirte-hacken-atmen-bdecd01097f1@brauner>
In-Reply-To: <20260731-hirte-hacken-atmen-bdecd01097f1@brauner>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 2 Sep 2026 10:45:38 -0700
X-Gm-Features: AcwNN1VeQfLr-lGWKTHuj31ux7CqT9nCh6MBY2zMFOnFauLHmsLD9R1qSF4ix5E
Message-ID: <CAJnrk1aX__NiZs-RE1N1MzDVeCsRt12d_mwX_K7Eq2bHtNfdYA@mail.gmail.com>
Subject: Re: (subset) [PATCH v5 00/22] iomap: convert to in-iter iomap_next() model
To: Christian Brauner <brauner@kernel.org>
Cc: hch@lst.de, "Darrick J . Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, 
	changfengnan@bytedance.com, kbusch@kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, bfoster@redhat.com, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 6:40=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> > [20/22] iomap: remove ->iomap_begin()/->iomap_end() legacy path
> >         https://git.kernel.org/vfs/vfs/c/0210c4ba2547
>
> That accidently slipped in. I have not dropped this from the v7.3 merge
> window. I'll get a v7.3-rc1.iomap ready with the last three patches.
>

Hi Christian,

Hope you're having a great week so far. I'm not seeing the last 3
patches as part of v7.3-rc1. Do you think it would make more sense to
have it be included in rc2 or to have it be part of v7.4? I'm happy
with either, just wanted to flag this in case I'm missing something.

Thanks,
Joanne
