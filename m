Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6B4470E9C
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 22:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784760941; cv=none; b=q3LN3KeEptH10c6si/6x8iOgUjq0tB187Wn5UUkvsMDtVnc7b9sl3jS8EI9L8rm0DxSYwLt2NjjjLduVEdx12uEPPSkVOTs4WjZzajNSRmCphkRl1OdNGelnqBrfOcocg8xgP4Vrz7tST9YUe/IsSBOfVuihu2RDvitPl5VvhlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784760941; c=relaxed/simple;
	bh=acopFJOSLpSXtlkRLUNwgl2pEsHjS+2eUuZNPGjmL/c=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XugR6KYu2jj8wZiWbej+dkrAEIhTM4PmSPHrxtIMlQ01H4enGIyNn5yW+fsbZMeemzXeEJuKbLrQo5fDwhrcmtR9qgLzEdxxU1rM9AEXTeqczLq1OW8tPAngN/JAhozfEA++OjdW98vih+m4LCOxWH4HoXFlAsWhuRn1V2j5uZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=c/2he3ko; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="c/2he3ko"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-381216921aaso4961a91.1
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 15:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1784760939; x=1785365739; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TiUt8cxrJr33ojxgz5FmHFeQcgtWRdgFyYurbkoKMv4=;
        b=c/2he3koA0/H3V2Zd2oTubTI3cW7qKvVHO6fBA4bKp5obA1lqP9/niMSRy1exqoWca
         PdeFrnAT4Icdom1yN3NrkiCwwKekAmdDHfvVKfiMjevG0iG3hhYmb7lq+RRMDSzq1IeI
         nWyofoa3aouRmshj7F6YtV+dZfJauPfxaBwpRtjb5IkjcXhzyHp3eRSy7exhw9Sx4lZH
         VFSGxBcr4M9JBbRxE/GKiFTOwngi1elLRQCEA+n+e+9eFLqvH9DbFRpuGsFUHY6hIjFE
         eJ9DFg9ctmlFKZpGtLdYRyocNDUUK0/3RStrkN9zFaMvp1T7tmDQ6sB5eg0blHsw1kvb
         k+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784760939; x=1785365739;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TiUt8cxrJr33ojxgz5FmHFeQcgtWRdgFyYurbkoKMv4=;
        b=dCCQvtvVCDg6yvgo4tWnRByRXg8s9e4gEiOIZEpG17ppWPsZ0V+FxIV4aekDBtsD90
         qC5/+YW0qCLdLYWl2Nqsrx1K86VpNLMJm7jXL1gyQ6jllR6E/fpN3D1YsPEFdbj1dbNi
         SkWoTooOJYv13XPyecBf4Usd0OXWBifOPq0GgbYHA8qn/+6Mjs9PbxIhB4Jk7P01Pqyn
         RjF//3OR76LdWhK5p6mxZAdijBXz5pOdlQMQG5bxLqoaXTlcAJPUCm4e5nmhOi10O8ZM
         uOEdCwBKhOLyFxgRZP7oZk8F+YOqq3OtMa/M/Hlec4tJYWEnaHFDvCt4jg/aE0q2cGi0
         mdBw==
X-Gm-Message-State: AOJu0YydffJWNgJp94MOER92RqlBo+O9pscdSUAFKZKZwMcLa0jfRzYO
	PB1ciK+06pDifcyLLB+YLSFBf3mhIvvS8MDWbIIaRfaLxwmLYqfcbo0MnOKwKI34DZA=
X-Gm-Gg: AR+sD13mkxAvwM1weg2QkXYIz1vjiH45sPgxHY3ToLni91OSbFrXU+Vd8jfGU9UjdM1
	zdguzidRk1UNzFuY/DtBmv0Oi42dl2GYCQf31u52FapK0AwrBJ6YqOFDCoSmSxXd3aUIC1ZJPQO
	rgUN7tWW6snlgyO4Afc28usGBB340a2iZGD1ujZVVQnSPerBPRPJlPhA6O6wxr5MuqM0rwSExus
	fLZ2yorXVzIuOEBiNgv560NaW05ZY5qPPRQMUK4qX1cj2FaFWi8xIVwFFenBrh6uq2V4L77kjik
	Y4yHXKUE7ozSRmxptIuff6P1xbk2BbhkWzPNn3TU9zyFOhICH5y8hrvcVdxmbKU6V2CH1RPncjT
	lfNi14CPWcmMEJkMKrmJJXyNbZglhQ1BXiUtsDVrLfm1mE5bAD7egdP3aybo9Mon+G8JyQYwmCA
	WBlxTWlN8YW+ZSIRoo1FsqELWJzfxJ2CE=
X-Received: by 2002:a17:90b:2b88:b0:38e:ab33:9551 with SMTP id 98e67ed59e1d1-38ec66604ddmr590123a91.42.1784760938772;
        Wed, 22 Jul 2026 15:55:38 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:912d:f53b:2118:2665])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e91cfa6c2sm4011849a91.0.2026.07.22.15.55.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2026 15:55:38 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 1/2] ext4: enable scoped NOFS when starting a handle in
 nojournal mode
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260721140152.461286-2-tytso@mit.edu>
Date: Wed, 22 Jul 2026 16:55:27 -0600
Cc: linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <361DCC39-74B3-4376-9C4E-CD550115CA4A@dilger.ca>
References: <20260721140152.461286-1-tytso@mit.edu>
 <20260721140152.461286-2-tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 21, 2026, at 08:01, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> The jbd2 layer enables NOFS mode using memalloc_nofs_{save,restore}()
> while a handle is active.  We need to do the same in nojournal mode so
> that it is safe to remove GFP_NOFS flags while a jbd2 handle is
> active.
> 
> This will require that we actually allocate a real handle, but with an
> h_invalid flag set, so there is a place to put the saved memalloc
> context.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Reviewed-by: Andreas Dilger <adilger@dilger.ca <mailto:adilger@dilger.ca>>


Cheers, Andreas





