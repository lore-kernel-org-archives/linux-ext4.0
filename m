Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C3736404D
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2026 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779283489; cv=pass; b=cqHTJDHmZg36YAXnN0Emjp3hWYMnXbuKnYZKcC5nbAZRAuSWyR2knkBRenfj1NuwtL09Dq9Pxn6E1HPkH/S7q1uWIlo0FFNNvNMGPH1BzsUyjV5JSjj2HNw9fvsNUCqNhFO8TGRYPwzTpiWKD12G5itXxeSa2uvKm4oe+HMROFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779283489; c=relaxed/simple;
	bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=le11A0ILkHJzVjpJ0Aam3pvMf02u3HJ8tsk4OPIvQeitNiwqIjeQDqNIBhtj3UQZ1JYYSlDmPRhoLQhxYNzz+DNg5NWg47ViucB16/u2UJ30sFsCLh9tlzlyZHwYhIkh6uu2mBF8+A2KVeiJ9onvKRXqwIOePmzEcrSpXtfWKd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DwKoCw/P; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwKoCw/P"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67c4aaf76ecso8281871a12.3
        for <linux-ext4@vger.kernel.org>; Wed, 20 May 2026 06:24:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779283485; cv=none;
        d=google.com; s=arc-20240605;
        b=Nrg1a4dhTqorso29bbnjnNmtV+Xp/LFcVrfWcwXXGZlXICkGvvBwl3nEiPY+v00qpl
         FNpHaGizdPRc5azRJDsLvy5lG4gBTXdcnpx0qMB8lw9W+VQ+VdHgQJgOzzxpJ+fyry/C
         ToETrvvG97Q8TLf2zSlITevFy90hsgwYplCOXcryjC/mUXbO1pEBk+zR0tiVvnH6ePLw
         0himREM71bcbEG8+tD8mbxxmuLiGNIhjbgwCZ2WZq8qelY+kmMjgdJrvbS9wPgQPuXRK
         x1QQJZrW3IqjXQ8Ene6OZyJmAElXzH2slhl0C9tY5GPBVPMcSBGT+r7GW3YySyqO/g04
         lb2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        fh=1ZxpIg7aXsjiLS+dOjbqvByMYJ23CX/EYEewDliNvZk=;
        b=ieKZxKDuXc1Do0H1e2yKTGP5sJMrq1hsn55BK/W0doTrvUbfZAjAcccDWYuOqwgX3u
         WCPRehiwWkvxEeA3TAf58jXshTMTuVvH7VOLJK9StC6LUfzg9nV4MD0rrqHylra3AkCq
         goQU4K1UUADAcOTFKDsl4/9nkuMgn+zqJTqfputZDXi/IXuB24o9jFz7BVlfuudkG175
         878dU1carRRn57Y8A33EckOMzvcev2QKSHV4sYoALFpFq8iyM5eneaaJvUtvBxdMl6Kb
         HlKHZZua0uH6MCRCZAuXoh2OeUcnv1S+ICz8azGVTxgtOguw0TtQouHkL+15uyd0JG20
         gzew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779283485; x=1779888285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        b=DwKoCw/PT7mQ10vNBMUrsTEgJ/KD0xilvxMKeI+aiO7GBDvQq7XKJJ6kyNOOhWPRFC
         qAQRff8dLVNruj1MIMY+n75FGD1FnYxldtzIkNgu+HLnxNvGPuCim/abv25tCKOX0c4M
         B90eJODV43Mun+Az+kck902Vl9CJYMttimw0RXk+sRWyhFsmweKWF99SC7Mwan6wOHFe
         ECm4lVjQVlTWgUeeELJ94rOZn5g2GnGibbV9qeU8cfV+5qB+iTfrqeWOwpY9JiXUFeT2
         qwR5fHpfjh1a5z5kJLq0R3QIzdIesXZWyZHMBltpqUvmJGhNMGt1egwYWRwxhVmDRO+w
         Lh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779283485; x=1779888285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        b=P+WjAmVbgJz9Ck2kazzhb0UOgrEdqliJr+cp933NZuIw9EYfxjqSiWDOKwaVxSnDc4
         lyzfVO7kH7tGuDGsTsBgGL5H+snkiA7zIqv+PYd1nCXjwwYJ/wGMVz10/qrZRUNQ7h5+
         QuczDe4K9vOWt8eiK+EwHTG51nXO59FZoDvUl4KlqcuxIva8u0HLkoE4khV0416TqJbX
         5vem0onTbqdP5WyAyNXHLIDTW+10cUnBzNCwnxwyfYL2btb6TQlReVJC4RWYal9Klevn
         7UQjQ+6MEvDyI1Z5vdQ2tSygA+VqNLzW7Fjk/tpUTzkxzwhtsJt92lwzM7mxs8CiTUAi
         bk6Q==
X-Forwarded-Encrypted: i=1; AFNElJ/Ure0sQEyvkMujG6TWwtBUcdwwoxlqcd2iAoK5Z2lfG8Piflnq8dulbNWnlI9jYnOUC21BpWx/vPOx@vger.kernel.org
X-Gm-Message-State: AOJu0YzBn4JGYnfLz/TAITZZ5IpHarw9X7RFZOIaAld11EGKtRU2Q7IQ
	EUC9mS1EGCSOwfieViJSRfJPrmLlAIb+ceZ0VFgAf8m49osP8gwRWa66QaKTNatBL0FFsofim4K
	6UNC4aXGsiMgBUuOWB2g6/GT0JnzYPeA=
X-Gm-Gg: Acq92OFrioJQJAZHJAdOsAgNCgoIF49vCTZCX/2Jm401+kWvfWJYFTueeQrd20mWwI/
	TEGYzNrYOpJcos48rTyLi0hZ9er4H48GVooEyxFvECGRcWgBhj/2ob6nEgH735qEVaZE7fpiDmU
	YTXtFdujBlNRxGkw0bueOsEQ1T3JabxVHevqtDylPGN9jR0tV5sPjWoODidLII2dHg8k2tui6x6
	qvzfv/JS7zQgrDwWXWqZgI1IJDg5Fd2FYUJj3Z0Rt/BcinyZVJwuEndt0gSVGiEchtXQArPnT3S
	hzn0PDxGsd5Je2uh2ZSpFGQzAUogCmnQARh4T4sadKSFsMZgUkWf
X-Received: by 2002:a05:6402:4313:b0:687:285d:44a3 with SMTP id
 4fb4d7f45d1cf-687285d465fmr1620985a12.15.1779283484506; Wed, 20 May 2026
 06:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520123722.405752-1-aalbersh@kernel.org> <20260520123722.405752-4-aalbersh@kernel.org>
 <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>
In-Reply-To: <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 20 May 2026 15:24:33 +0200
X-Gm-Features: AVHnY4Jb9lW17aXG5JPAYjGDiGqwrTNH7OJH9zvcsbDKfZCeeZ6RTdTNxiDlapc
Message-ID: <CAOQ4uxiNN3U4datJb8kxxGVp7VNRFZB6_zEnO76kh9oEjE_-bg@mail.gmail.com>
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 2:54=E2=80=AFPM Andrey Albershteyn <aalbersh@kernel=
.org> wrote:
>
> On 2026-05-20 14:37:01, Andrey Albershteyn wrote:
> > fsverity now exposes fsverity_ensure_verity_info() which could be used
> > instead of opening file to ensure that fsverity info is loaded and
> > attached to inode.
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
>
> Amir, Eric, this is the last patch missing a review. Could one of
> you have a look at it. Not sure who should review this.

Feel free to upgrade my ack to:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
