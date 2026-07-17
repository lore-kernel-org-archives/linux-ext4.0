Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76B53A7848
	for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2026 05:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784267239; cv=pass; b=mxbG0Z/YDEsLSMGXy6sV1u99/Rk7RzCEp78j654jS2CYG+IAfAtneIUC+a0dIhbd2dFwqOce7FC45PzXpwS8iT/qtmkx5oUGfVvSV4W00HmuEquZjyzULq6cwrg82lqsP5Zx88Yk0KJK/l+ieM61708pKv4VsQWLXKS0CuxqSnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784267239; c=relaxed/simple;
	bh=/0yEoNbcL6E1NCkGiJMMHleLznfqzreX/5EMsmJztsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q18Z0oVqTCGnjuysDtEn47DtZkoVxAuHTOBZP9/on3erC2RLbsar1EP6iKY4nX7WoTMRD82e/btsmOyqPoMQpXRBJ1gEohJMcHoY34w+UQNYxMYaPA6F9G/MUo0mqmjhRt//2TUnaGKEIa5nbRJkt+OVaXyFYb8X9p8Drii4nGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=i9cIuHd8; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="i9cIuHd8"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c15b33f7b23so1089539966b.3
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 22:47:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784267236; cv=none;
        d=google.com; s=arc-20260327;
        b=bjPTyuuA1L8rHfKAnfnJkjeXoB/a8kKZJcdN121oaDkMPWW69N7KnZC1GQRg0tz2Bp
         Tapg+v/1fC4HAcTL5WeTNy4weiTG/XPeRxbDhKdT7EjyKsQ2nc+bPL4gpaKswDvRmqBN
         /ePInG1MHLQf8F2JDJjtjZn0iPJRTAwIgtfPXDxWF1+dmWmFFFGjHeuB/XGbFeuWC4bI
         TxEKeGdXQ2FqpWcBMgERQyXZdfiEIOesSer4LawWdcFtlPMvevpr4NWYZadT5EfaAcZo
         i2W+C+lKIj62grEV4bYsuqZUaxApEwizpFLa+hxbCDW2ul5iKaku9Qxf2UHZ0WPv73Db
         pEGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/0yEoNbcL6E1NCkGiJMMHleLznfqzreX/5EMsmJztsM=;
        fh=5ELt/mVz4fzhcETlFkHa5Qj3S5Gspa+P9DAPHRbA2LI=;
        b=J3V6H+3BvNM4edFBd/HYQad9JOJiKYaDjen3WdcClMRDmWb+nq+JdSGHonrLfr08ou
         +PO4blk7VlFISeTsx2Xe4ona7tRZ4aMxnx2D79bi9ySB5e0VT/Bvioh4zbPGlugTSJch
         DvfMttmhgTXpjde7T6Gp3IKK5CEvEozIJmVymTKuSkEFVy4bfT619gy7lngRlpHyOCPI
         AriZu1JAjZJmz5niLJ68E9Lset8dVuJWsl9cQnRMrkSvXRLwtXNCbkBwXTeZUtq761bk
         5QVptqRr7YnspI9YfvJd8J/HwM/13IwbhrQq3ZXzK/KonWKHvislmVHx1CZrm1xhxO/n
         KrIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1784267236; x=1784872036; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/0yEoNbcL6E1NCkGiJMMHleLznfqzreX/5EMsmJztsM=;
        b=i9cIuHd8rT5CGX6LXYIGbYELkHx9OCsFt4e8pMnETK6TapwQKkWBbYrDttIE2zHlyQ
         z7xA/rHd5B2vXnNXJjO3vCWUSw2O9Rbv2NAAX9q/hspH0hPA/TWtA7IAWW2IobubZNbz
         HHIrXAlhSa63ZMHUqyi5NVN5jWbnUl1+rAbMQcMir1hUS3r2L+2cFmpV7oAvQYwyCGDS
         04h+ng4G6yDxtm15xPptfIl+hhn3yn8AwDbXdlHONSY4BwSzoj7bbpfKAdWdcUAuFhGX
         /gn9N8fZ8bGlyf/9EjjwkSBrS1c4qWegpSJzKiz7aczE4gZn0GXzgaESyyP4W5QI3cgD
         2HuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784267236; x=1784872036;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/0yEoNbcL6E1NCkGiJMMHleLznfqzreX/5EMsmJztsM=;
        b=FIju9UMryQXReP3vQn9u3Y2o3zlDsLAWP3w4V+dv0xX8s9lYCDKjoO5zcGYZir5Flk
         rzRUWPnTBmgttB/4odeb1iQwDGJg1M/rww3WAaN+xDub/ZMJEM0ulgi47Uqgy/2RY+PM
         JcrqjbtV715Rirr80ZEhH6Djwr5k97AuZi5q1vfBcBCEVNophRj2KMcbmw1DMGMhSfxu
         FsScFKpIMjpdFb8t+KJ+pWqSBmfmTrrKXbcFey/+o2BG62wQpXas3fDTNBVdGYr0ATsK
         TJoBVRoo1dOVeUPNrbttlNnamzruIlV5KIMAqgvckPDcduP+6eUToygaAk9kGiQr2Oup
         FbNw==
X-Forwarded-Encrypted: i=1; AHgh+RrbKgQ+bwOw5mh21ZD8SoUIHF+qD7q9c+iuHLdOW8sxxZZG1hXmF147iAFaf35Sgtm5G5uxSs6F/5jo@vger.kernel.org
X-Gm-Message-State: AOJu0YynqyANxb6HXpvPZhbjTcoHwryp4hjPnc+DletMq1zEFyXX1/tm
	IF27Fz9QiUTsEXKdVy6OCwpsMbxajv45psANOEQQf2RF4mkAscX4Pf61ghPTTaMmXMvIN0z6N+K
	MTNFKClHuq3mUGTWbCksY8hpev480hBId60BEcbGLCg==
X-Gm-Gg: AfdE7cmjavmxM8/G5vSKDiARc0LIFBHTDTco2sqYPd0X0Ler1fIWzcWHlZjgaDdLRN9
	Eth8JKhVVk1oMbtPVYIxCeHV5XQO9vufBYvvCy4zLxWudxUOwRf7pJJMMdsfogJs72TX5qGXL1c
	JlIe0Fd3NsZT1yHp69SHtb3sFJbbopWFXDss3+x8UoTlB5QdsA9I8lJHoVB7k9trhumli3w7b0Z
	qA+B5M94asfTyjerZkFvSEnO3SoKOUXx+UHuRoIOyWm60g8X3A5yVgj97W7ezyzM6HiR5u2viWa
	CM3rH71SvDGIiXo=
X-Received: by 2002:a17:907:c20c:b0:c12:85c2:3604 with SMTP id
 a640c23a62f3a-c16b4887e58mr36632566b.63.1784267235923; Thu, 16 Jul 2026
 22:47:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713102229.1598812-1-max.kellermann@ionos.com>
 <20260713102229.1598812-2-max.kellermann@ionos.com> <E3B8944B-6045-49CD-A72B-0B8F6C42C713@dilger.ca>
In-Reply-To: <E3B8944B-6045-49CD-A72B-0B8F6C42C713@dilger.ca>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Fri, 17 Jul 2026 07:47:05 +0200
X-Gm-Features: AUfX_mxEf1vqViqxCK4SGqcO38mxaoDUDybvsfszFwktj7Km6V64OcOHWuqM2ZE
Message-ID: <CAKPOu+-ATGd8A_CeO1bW2A2sN3K_cbcimwHO5M-HY-AChsOmuA@mail.gmail.com>
Subject: Re: [PATCH 1/2] jbd2: check need_resched() when skipping busy
 checkpoint buffers
To: Andreas Dilger <adilger@dilger.ca>
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 10:04=E2=80=AFPM Andreas Dilger <adilger@dilger.ca>=
 wrote:
> One question I had about this patch is whether the list cleanup could get
> into a livelock if it becomes too large?

It was a livelock *without* this patch, because all CPUs were busy
inside this piece of shrinker code; one of them holding j_list_lock,
all others spinning on that very spinlock (all CPUs busy), and actal
I/O was stalled seemingly forever.

> If the iterator is processing
> a large number of jh that cannot be freed, then `need_resched()` is hit,
> if it restarts from the beginning of the list each time without processin=
g
> at least one jh it will not make forward progress.

If no progress is made, then this shrinker call just wasn't able to
free anything. That was the behavior before b98dba273a0e ("jbd2:
remove journal_clean_one_cp_list()") and my patch restores this
behavior. It's not a problem. It's faily normal for shrinkers to not
be able to free anything.

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group
