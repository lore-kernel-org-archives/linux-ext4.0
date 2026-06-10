Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406071A6814
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 03:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781061419; cv=pass; b=g4nPQKB8HtVqq2TMd91JmtnPISqD3GMdvVlcTx4SeIuQZl/N1/C9wHYDOHXJj3QFvE9f+5lII13Qyrmlo0GHuxloBrCgNUMQe+ZY7jBJ5k27G3qkO4zuEfOzrlvtI4KroECU8bJPh1kan7USif2ibN0QvWNPfGXBIKlSqe8/6Dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781061419; c=relaxed/simple;
	bh=6ivu6G+abonV8rFlC/Up7NjXHcRzSyWTsA0ccngp0IQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PTJXjWfpIuYbpqepgXUvXWdXxaOdshW6MoW2Qgy7aCoz07YMSNrVvnVgnq9i9IgXtB+0Nc5NwGlN5HnT6N2DwmyDanIU25WMRnjSVMsZH5bHf0qGX6b8Y04mUeMEEowSovssEFhQQfW/sNxqt+GyowH3wyy3QlWuF5fCIaOdLt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H3MfmEzl; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H3MfmEzl"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bdb3fd39045so918691066b.3
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jun 2026 20:16:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781061417; cv=none;
        d=google.com; s=arc-20240605;
        b=ZEZ/reDmAPqRlwER9E/t9FcudIGr/K22GOnibUIZdNrO7GjeuXhhEOsJcPqyL90MwV
         gEAcqKP9KvznNxrXCpMu02x4z+xmg8lNl/gYbrQPJXDtyuWglbbdGQaEy2Im3191TDgE
         vBCt1ROzPGFbFQdSeH3bRKAc0gE7jPpDQ2iJ61qcZd8ijL87dGI1NmL4yFaN/Oh5KzvW
         O7/x2qcka2gFIrxN/1EDO7C38vpiQffMSz6OVO087ZxAgKfoKLGb5GxmBmkDJe+nGDxp
         UZXjQaSniar42FyNQYVsOgzOZ+qwniFUD2OtmetzpX1Uv6w9g9Jglo8+WrrRvzVXEjGM
         m5wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6ivu6G+abonV8rFlC/Up7NjXHcRzSyWTsA0ccngp0IQ=;
        fh=AI+B5ZpTtR0TlKDZd1FM3firQjS+JgdDla2BQ1dtdLM=;
        b=Hq5g8sq/e+tlkLEeyvD0aK3HVE8duwT7HIitFPLEANGQ7UyuuQONvbo40vv5zoeWoc
         80afs6kplNx402pNlj6ma8iCNPO/csbwmDtOqmZy6+6wcHw19lTdkVsDGRqhNaUkvXtf
         99zrqmXtKEQP/iH/t/chuwny9Fgy/425sr9zX/L29SMkCcmBQWCiBKMB81AMKDeYiD1f
         T5FMdbbhoCjrYt6lfBd4JhOxSQFDT8TiFbOOgQCet8+rDwkv1PuY0NngrXGrkZOnKX/5
         4VCnwQgXBvGeK6EcyaXMSJQ9vC/25cHh6o500Lszv/Uaog6o7Lxw6tCaGpANy2Bz48q8
         QxuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781061417; x=1781666217; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6ivu6G+abonV8rFlC/Up7NjXHcRzSyWTsA0ccngp0IQ=;
        b=H3MfmEzl7d1APfW9tVXC7PN/26hXINTKJCo4QEgajXz+/ysGSJnmkM6otdsVmTvv+z
         l/7/0Ih83N3VhHOqhOKxAyFFRt/PRArQH2lcnLwwZC0KNKyGGNSnfL+YYZ6muN73kYsS
         XPOcV3Si9boJynTdWyqk8Brl5EPXtVC8j3rBiDea7E8CeVX+DWTyFJ7MoKUg+6mH1fSq
         UmCUfjomUTPZQb7TwEPmHGdn5DeH/x0QdIM80sjg+BNxnWw+mKBtUNuePBJT2eLcoIY5
         Xk9lTb6Bn+wVLuOkCTqZ7MpM3y60h5Wy8zZZk3FL7BwByruEQumxzfAdgLzrBzcKgt2O
         Kx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781061417; x=1781666217;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ivu6G+abonV8rFlC/Up7NjXHcRzSyWTsA0ccngp0IQ=;
        b=AQvUfijwBvhzQakGiD/42Kn7g4W8qAQrURaZBNs89gj1PP+lNhNLO1gbkdJtKBb+ZW
         d8TR3vkYGcnRL/ZRClWfXyJSqHvvNYPeJDCKS2XH048tsg9l9/Z5ObmvHpT6JMmMpONs
         Rl8ynqoiT/9MYqXBFjHnh+Z/9zaOT0c2l+tp/YIBXVOyKD9Ztph0gs7DPODYm4i0jbhF
         On8v9y0n4MO3Quk27GoyKOFWap90qkjTBaMQQF9jSveveYIXT0eLKaOpQuqtuw/qc9O9
         S0A7ypPYx0T4pQ09BAz3J1P1pS4KxhEKa0XGCgWiNG4nrUrJ0/6xEHxrpbAptk/qOlyt
         ohhw==
X-Forwarded-Encrypted: i=1; AFNElJ/XomAg0a4yBTg8A40cUlTbRBXqvPW967NKtZksPEZVVUSbBsr4mG3mH9uAxKxztBoOx0VL6Ztox3bX@vger.kernel.org
X-Gm-Message-State: AOJu0YzHVle6QFhVbn/+rf7dIQxxeERrQXbmkQVeyPfTXBTC5v+ZQZ3K
	JTaKzydU//V3oCEDgPHbUQ/4LjdAZ8V5J3//a2T5P6KaD6rEBHjPBJlFKPisgEjJzm45gqrFWfb
	ra08YOd6uNAJkH0It0iGvzT+mPfZ7X5E=
X-Gm-Gg: Acq92OEX5YfNcppK2FmuXBqfrpLho0zV9m7arcfbUVtwPMPiDGrdRCo4iHOyGOK8reL
	RzyecYQLTMI6yBMbu+qvdOFOEV9MiQ5KxV6Ntvx+a8T7VG1jVa+iIrGWW/ohcw2BmKT1HmJ+NEW
	WfiCD46Xb4JUdtaqn20dnfdts/xCfTh+D4qD4qbDfUhytv5zWMz1GvRJ44HkpdvQQ0TSy2snwRo
	rC5Z+rYZ39zNsU3YID3wafQn6+rHonWe4s3aWZ/o2/ZOY1MNrwcLlVaypqJtXkxIzWdZxdXTEBQ
	phSXx2ONtLFlkny3rOhcfBHKGkzQ7ennjmIylCHrlokhSGC4pLHzx+jZakZ+LVU=
X-Received: by 2002:a17:907:d40e:b0:bed:4545:8bfb with SMTP id
 a640c23a62f3a-bf372e1f898mr1139353866b.40.1781061416521; Tue, 09 Jun 2026
 20:16:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260608065227.3018-1-aditya.ansh182@gmail.com> <w7zmtkoa4ieb676gkl6m2ax5hp76dxr2rhkfzgqvlydvw4hpfr@hixijfpumliv>
In-Reply-To: <w7zmtkoa4ieb676gkl6m2ax5hp76dxr2rhkfzgqvlydvw4hpfr@hixijfpumliv>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Wed, 10 Jun 2026 08:46:46 +0530
X-Gm-Features: AVVi8CdmHTdjmzm-xXekP1RWa0tQhnpmr79eDmKg8jlZDk76gqFK198UsyBagV8
Message-ID: <CAK5ssPMvamn1fuz4ss5RUkErC79GpdgVs0AZgZky8CPhsMof3A@mail.gmail.com>
Subject: Re: [PATCH] ext4: fix kernel BUG in ext4_write_inline_data_end
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Jan,

Thank you for the review and for the Reviewed-by tag!

Best regards,
Aditya Prakash Srivastava
