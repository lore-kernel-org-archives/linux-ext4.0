Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D20D38D017
	for <linux-ext4@vger.kernel.org>; Tue, 26 May 2026 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779807632; cv=pass; b=hziZrBc5W0V2xtBo/lMAV9ErHlDRtNlsiOuariCQVDbgpKvMgm9IsFJATDxo7EfzQLdN6cmy29e0wg8roDEk635aUwGhr4xEc7c/vnDh5NRvKTyt2PmL8nkp+hsAjAdG65Y1slnB95/clT655M78A6u61aCWvQ7+utEmtBgCvi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779807632; c=relaxed/simple;
	bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gRFB+j/Pp0/277aZdPqPhmg9a+6q1lVgFDUAHXSjzu3bwWtxn5bMyXHdFoFZeOxHrXxVczWHHCLcq6588VTrAbTSKaX37+pPry3KUYtfjEqsi20NbWc8X8WzLq3pzHfwU6fNLjOJ9R7REERSbE7xXpp5SwmD7gpk90Pw1u/Nybw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=qiOyQfLL; arc=pass smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="qiOyQfLL"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9106ea78cd8so1669892985a.3
        for <linux-ext4@vger.kernel.org>; Tue, 26 May 2026 08:00:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779807630; cv=none;
        d=google.com; s=arc-20240605;
        b=TEbURCAg8Mmm16cqsjjV0p+xduh6rlW2H6aL8747hhCuo5BcFN352wm3nGxmMJXLFR
         Pk/b7WfVXhll7dPwNMEfBfMiIYVFwz/xulotAEIVa5S558t49rTnHNvtZhzqtxDB4mCw
         oXDJxHbEFJadX3S5NuCijruMzrBWkhQbuc/pDdJiIeUimiOMzV1MrM4rUjTTvY3Zd8F0
         bsmLpY2Udk/2s+wtDp/he3E8VgEF0L3Y1UmytxMKtD/pKfF3jYoKRdwBCBdULeSMq7hs
         bQE0HDNgKTMZH47JitvhptNI8rIfg95lJVnEm6yTjt5q8Gxg7C4f1id7JvyWXbKGzK2n
         47ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        fh=G+ivYGmVWD79HAqQeHMo3AQFLSjPIrhXR8Z/CRte1hg=;
        b=g/AB1Uwn6gl+zfV35xNWl2kAPNbNNsAcFrI/iHxRRIrBwr2AWD3w30WmzA/+FqMw8l
         XSKuPE1psW8NNae5MIxpZCiRsOGJ9d22aadayFbeVRcNTKXHQRJKgjbmggYmCG3jbzwc
         LYukfZ/La40gMc3km8UsEbg7j84AzIJHxLn9nUUT8OgTHJLsVp4tZsnNz2nmkZRS7Qec
         fXh7lFHgAWc5eb2XeiZ7/a8RQvomV0uf/ncH7UIrm4FbFB1jXl5uNx3vFGnBttPCou7g
         odXDJZ4SvNpH4WkrfAsJJywtvTpeeqeH6iyn1qH/FxMpKh78IP1l8YjXFXJgJbIP0wx+
         JbTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1779807630; x=1780412430; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        b=qiOyQfLLvQKJQFdrg3X39/qFxhQHanjRG5XN5rjdJEvvjA020GwKXMmdrbnlt+srAm
         UBvtGirlVxglxkarVFuxih4HyPPjLQOuRQUGmCiEzbu8g/MnqNor84FZTx8p3RvwT3jY
         jRMhAi6WnwmIQlszTYbGFpmfuSBdcQyEyt8Vs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779807630; x=1780412430;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        b=HAW3zrXAMHyjOj2DRgdtuMGlrcCz10hw5r0SXDXECfCYHQAnyU/o/qOSMaNBTBBUnO
         HiUEp/vsqtXbDZ1FIoq2H8e/EsydmY6jYwFZCT7av928byJ4y3c0uRBWODfZv8wH2w60
         W7CaoX5DoBZlMgql2tgp5k6ZupBFIU/+GXKpKpPRfF1jUzWzu/DjU1qBCqO55SO9XFeG
         9JRjhvaB6XJP7h/dmFHk5pnO6M5Bg3CVwDhzUfJtgdufSo4ibeKG5FQwduMDPWTCZ7uI
         RbMUvzArbgd+wCElZ6DlMdX79QlJmfqzSPywP7Urr6LnvOl+FbLq9jYPX2hJLVHBR3R0
         +NkQ==
X-Forwarded-Encrypted: i=1; AFNElJ+lZ4rVByGJiCNhEe1FA/RGzJYum+szx6m8nLaVo9bnhoZ2d0su5O1vnaeIqFd+fUHvc+z173Hxmv8R@vger.kernel.org
X-Gm-Message-State: AOJu0YxJjYJVoLp5DvLXIsR+NA9RJh06bXCeqm3zLFZ+86zRUMbwE6Pw
	RjBnDlV9LUlQbSvURZeWhwW+hphFuzt+CYkXF2DRIzr3MQBIUSNA3XCcmcavJfobTSgRf2AzPEc
	D724sXPAVZbLw1t/8wU5JbYtw/iougAudYsh0xnMnUQ==
X-Gm-Gg: Acq92OH++beWy1mPsRC4iYYQA0QVBBoETutU6DeBv5HiHVFjLPB2zrA5l4xMr7Tmlje
	nU+kB7P/MjeqWoZfe0tyJQkLIZTpZbM1fjOANU+E4YSFwBlY1EbiKbHmqfgiLr4JSx4c+ZcnoC+
	b35hCeapFusIQ6cm0V+S7moVW7TZmoxcVrwoZuRlf499fpRAqWRXZIjlzpcKB1WWXFPKBX2QGCI
	ehIgrmjejbpLSEPd08fTrId+4OmTHoUMl+spiJ7LSlef4a2d3KNrOZ6E/sVtE97hGVnYEoMFKyy
	bGxREvkAoET7izdQITP+a/clh5B6G/vklN33ujc1uULeuTbJlQ==
X-Received: by 2002:a05:620a:2a14:b0:90c:e5b5:65f4 with SMTP id
 af79cd13be357-914b48b5d36mr2776455585a.2.1779807620596; Tue, 26 May 2026
 08:00:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org> <20260523-b4-fs-v1-12-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-12-275e36a83f0e@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 26 May 2026 17:00:09 +0200
X-Gm-Features: AVHnY4KilITCIvGtFxS6FTciw1vCUm1AhcuYlYRxf5FBmn1jF7w4ka-Ynpxrnvc
Message-ID: <CAJfpeguR8uzC+GdyYfby1LS+HyB=p7=ri3J4aAmUFfZ2V06+1Q@mail.gmail.com>
Subject: Re: [PATCH 12/17] fuse: replace __get_free_page() with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 23 May 2026 at 19:56, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
>
> fuse_do_ioctl allocates memory for struct iov array using
> __get_free_page().
>
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
>
> Replace use of __get_free_page() with kmalloc().
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
