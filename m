Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B939D3375D5
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 20:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784232297; cv=none; b=LZpjHBr94PCBOEgzCvnKHWNVPsTs+Cgog5uK/Xz4m1Z4lrbK9kGA6DUet6UgaAA9uM56o1bJEQRzysUwJl/6ZfcKWe9WMbc44F0lKuTBxlu+FVAm/nNUkZ8BLclsFtjqFmaGlcAqHTXWA650+vcIV4TwLzk5HzXjGRnKcOs4Y5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784232297; c=relaxed/simple;
	bh=vth1im0y/El/KO/94DkG/bZsruCeVRbozso0j2xIFvg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=s6p7PkOR1BwGThZlKe6t0DezKvdTnfNCnpEoUcfYd5Mf7Vt9QoXQC6cFvyb5UoOK8D0B/SsXbGywV/Yb09EyBbGvcn1yJMSLWVX6XfBOIpW00AfK12vEDca28T7+B4Ko8eIjH6nFpNSBM0A2rNjwK3UW8b5Yql/VkD2+1EH8eZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=O1ppTyss; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="O1ppTyss"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso41181215ad.2
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 13:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1784232295; x=1784837095; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Md2qxdgf63rHDP6+RS9ok1HHPB/hbV6ffca/STkhYXQ=;
        b=O1ppTysszucIwVtt6kmDu5DN2d4zQI0frgob5et+9S7dzK3MSBBtcrC32qj0KvWJVl
         0goVrPVRX8oH/Foly+jIE8/tJFO76Rt08PPRNshqZcEFMfnNLtawSCi9Cc/D44Y0P7CC
         dSksqaASiHCceFXTCrL37mA3ypdkZIwTwWBSl1WFi5ZsANzELfLByn0flJuqfNCDgXyV
         lLf/cXQxshpExgJa0iHCxS8loXe47Ot3j9MXkw2T+vpDkEHtC9GukoGqq3dh/SxJIML3
         kERdwffpm+x2WsBZgmos+RBsWVJX91Q5RbSRTV2ljNE52dXpc3AMpZ5NkFnGM2kEPiV/
         MF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784232295; x=1784837095;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Md2qxdgf63rHDP6+RS9ok1HHPB/hbV6ffca/STkhYXQ=;
        b=d7dGQM0+raqXbOQto4JokrG8+T2LTn4iomL2k8TAqkOUyi6ksw+jfydKsTKa9+igle
         Us6sTDjprmZi6fls1xY6lvKhLsF+Ael0rr+WaShAlJqsh2Utao8ypUxxVIKdxsE4X18D
         +c7hRPEfJXQ68NW3fLDQWNKDpFtO/s1BzcsQtgpixPgiWS482+efnkR+zFiEkiX0HumN
         XHkkhYBPM8xJWlDZzu0WpfqqFgrV4UNXgxsynTAoRGjpvgLsjhqptnbhGZKyUwTPzHiq
         s19gXR9xLqOb03zeEupthKAJwuL3PKSzvNXN8nUk3N32t6iaCGzUC/2hDlUzgx0AkOEX
         OYrQ==
X-Forwarded-Encrypted: i=1; AHgh+RoysUnaRemdIM1Iveq9QxB5BeGOK4MBRIqXZ5FXFQ3rSuBgwK+MhVFUc62JGKvDwIXWHZ3I7hLsaKC7@vger.kernel.org
X-Gm-Message-State: AOJu0YwdAz1WRIv7lV/F+r76L+mzcTJv0khPGyr1Wk4N6MFYs/NTpWAN
	g+eLjRySUS7rMWdXjritbnc/tXrZY2VxvdmQLPzj78K2FgbhlDDFDsD9/ycKNfRx6CA=
X-Gm-Gg: AfdE7claumFJtTwMyx6hiW/qOSuNI6Qwq48cOd+Wr9pIIOiVPd+l82iwirmCuhthr2R
	Ya32+k80S9RMzeC7mQQq49MpSHbtAXBnHpVUjaiPR+0KEq5EJlHjMbZtJxV2CfEnZZaMFKhWlnG
	doOGfCl54GgUBg2x8UeU+7Fhgecfn9pFDSbKXZy3qHm+r2dOBWhUZOK0qYHRY38m5jYFYqrPIaq
	O8arnCqkFYSFbFj6AXQs4bsoc7DTF8m0MGqEkVxY5DDN+2ebcKmBLlmpcZrQwOFnfwWQMv1ygJG
	Rn15FhZ/1oCjGLzFb2sv09ZLy+iaiKX4LYglz3bX/g8T+E0+eM9ISLdw5rFTNyoHOHX5SKSNgL9
	sjjOcRbXRHI/IF+JEpBpanzzUKd8QvMr80kMDaI5gfAwCbySOA/oPWLkk9wrL9otSRubYMYu6j2
	KJopf1ZRQwAWcDCIOqqRLzEZEZvEt/nIU=
X-Received: by 2002:a17:903:3c28:b0:2ca:4cfd:a6df with SMTP id d9443c01a7336-2cf2ec96549mr8299005ad.43.1784232295051;
        Thu, 16 Jul 2026 13:04:55 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:3854:7eec:417a:89dd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf100e395csm25319995ad.17.2026.07.16.13.04.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2026 13:04:54 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 1/2] jbd2: check need_resched() when skipping busy
 checkpoint buffers
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260713102229.1598812-2-max.kellermann@ionos.com>
Date: Thu, 16 Jul 2026 14:04:42 -0600
Cc: tytso@mit.edu,
 jack@suse.com,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E3B8944B-6045-49CD-A72B-0B8F6C42C713@dilger.ca>
References: <20260713102229.1598812-1-max.kellermann@ionos.com>
 <20260713102229.1598812-2-max.kellermann@ionos.com>
To: Max Kellermann <max.kellermann@ionos.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 13, 2026, at 04:22, Max Kellermann <max.kellermann@ionos.com> =
wrote:
>=20
> journal_shrink_one_cp_list() skips busy checkpoint buffers when called
> with JBD2_SHRINK_BUSY_SKIP.  The continue statement on this path also
> skips the need_resched() check at the end of the loop body.
>=20
> Consequently, when a checkpoint list contains mostly busy buffers, the
> shrinker can walk the entire list while holding journal->j_list_lock,
> even when a reschedule has been requested.  Large checkpoint lists =
under
> memory pressure can therefore cause long lock hold times and leave =
other
> CPUs spinning on j_list_lock, resulting in soft lockups or RCU stalls.
>=20
> Route the busy-buffer path through the need_resched() check so that =
the
> shrinker can release j_list_lock and reschedule promptly, restoring
> parity with the clean-buffer path, which already checks =
need_resched().
> This does not change which checkpoint buffers are eligible for =
removal.

One question I had about this patch is whether the list cleanup could =
get
into a livelock if it becomes too large?  If the iterator is processing
a large number of jh that cannot be freed, then `need_resched()` is hit,
if it restarts from the beginning of the list each time without =
processing
at least one jh it will not make forward progress.

Cheers, Andreas

> Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
> fs/jbd2/checkpoint.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 1508e2f54462..5266017565ac 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -389,7 +389,7 @@ static unsigned long =
journal_shrink_one_cp_list(struct journal_head *jh,
>  			ret =3D jbd2_journal_try_remove_checkpoint(jh);
>  			if (ret < 0) {
>  				if (type =3D=3D JBD2_SHRINK_BUSY_SKIP)
> -					continue;
> +					goto next;
>  				break;
>  			}
>  		}
> @@ -400,6 +400,7 @@ static unsigned long =
journal_shrink_one_cp_list(struct journal_head *jh,
>  			break;
>  		}
> =20
> +next:
>  		if (need_resched())
>  			break;
>  	} while (jh !=3D last_jh);
> --=20
> 2.47.3
>=20
>=20


Cheers, Andreas





