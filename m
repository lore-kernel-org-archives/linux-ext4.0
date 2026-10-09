Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05378EEC3
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 00:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791504777; cv=none; b=M03mTAzx5zBtxLCTNWaA0TFa6nYIDzla/cMcw9OW2Yfu2uskpF+w75foAfKwVz9Rqh5wmMevaIrkTcqgXGzYe2OGbFKyr+EVj4C2cs/DKZVQCqyLBmancBCWp4dF9RY7tfoOg0Bn1xiMdaoaz6HimyUaeR+IOaeZ9WLwF2eRmFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791504777; c=relaxed/simple;
	bh=PJ0ceY3RWgNBKeVwzgnb+1tPOuqSiaZnvHq2jfmRglw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=A9X/cadOhJRttfkvncQaN2duh6IDL2Zq5306XZ4w05DGXLvYFVFSKjAbS1i38y3ChdxJGh4zUarRD4A4SQdC6RWEDy5OLYjvCLZOFgH1Gn+x4DvXjctez7rVE558FMhqhPzaHtKmUs3jiIEO23FnrfJ9WIPu/66EMjeD7DUxMDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=lODmbdHC; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="lODmbdHC"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so1972619a12.3
        for <linux-ext4@vger.kernel.org>; Thu, 08 Oct 2026 17:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1791504774; x=1792109574; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9YJOPN4xfmVbnbz7ekRVJSBTN5ZgGYa0gRTWrOPMw1o=;
        b=lODmbdHCgd//UzYNXCEVa5Nb0nqyZRGkZwpILZeiEwIsVSw8dW3sJWLETSjix6b5GR
         qxEC4N7rEr53gXkiatpswbHToc00axqIg8Pe9w+vYsC0FJ/iEw8yfIi/ag3fO8bHClgo
         XxytF7d92vVYfMkyugGdlwEABO2isc+k45Fhfw3M7W28ZVkpNkI47woeDThgblVR8rD0
         NKZ94nUARfPQR0qZlNCupadCe+YhA/CDSGNaO1mkWvytyRRDbwTXdBXoQwWQQtAMY07G
         SMxfRVQoV3H/UUOO/tBUzQ/yBOo9ML2zitGPVzIlfdluyD3Um99XLm15uPFVN+RfY0M1
         0TwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791504774; x=1792109574;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9YJOPN4xfmVbnbz7ekRVJSBTN5ZgGYa0gRTWrOPMw1o=;
        b=vqlBkTlLSDsxJ+XDvlyJOn1ZwTZ4AC25hWOP40SNUkb/d+TY7f8Zc7q0ixw9eIbrjn
         TpkA42TsGwSCgJ98mkrt9sraNSnxN+rqTcekWUOnnyIKI03cPoVOnWBH/cXxpIOXtnSA
         v+klT2RdwhPA/013KYLOa7UgNp1b6vIO4S5kOxUfogWJutL0ZWiaE+7mAO3h4Fu5t5S/
         rx2w2WeIgRKZAHIUiV+xK70t27XDSlp8hwW7l+CAeMy+nLPHuT1UyPTfENmq0UeAbsky
         8en5wnP8r7w/3EXtBDO0qkbXZ5BJzd3MLVJoo4qHiVEHHQK3hIjbtIxE16nJwc+pBRpY
         dUkA==
X-Gm-Message-State: AFq9FYJq+0kLT3Lotwfb6Tns0xk82pSCwNAucYUOgP6qhiVmxlqSHrsS
	daCcSkrYEos/owzYaGlYbms5UuQpUx5qtOVPML7FIhWnCeS7MZ21qOlqOgdF1GTSiJtWam1EsxD
	GLAxt
X-Gm-Gg: AYBFou2tN2OhYAG3hSdD9oqvxMD2l9nxQgqQ74+VrmEPB9XmkzPlB84yBm58SemXbEW
	kb/qL4V952BIv1wy4xvDo9p5E/qXakkInh6B+5KdTa5l/cHmqomz53CGsyMpTQNma7wLw52iXPl
	176YzgdnJ90oDY2eyO4KVv8DXhgzXHAUbKAIH4yTU3uTQNNNXwyEeZ56GpZjtr6ymT9IIVTlFrd
	ssYcBfDm/Y0suOMtoizhccuAOisIw6uUMG06nlDZZhWu3EeAHn3JXrlOUOS+AYUdnGOw9o+0MmJ
	AHi/Uu+XT4QSIRzt7zwM7i8LJ/mxmfbEBn3yFMN0AWg7inYCOT5aIdcO6kp9NX7YsShr4vu5Txc
	F6kxoRueStIsQOQ514KclGBotXtT6fM5vBSxxcgFOqH/KXt80QzeFM0P66V1MKOSGj4A0bzIyVv
	a+JrxDQH8m3ibOig0o0vZA26gPeCZQt61ntkJ0GkZpmw7VK5TCrqIywYMyDyGlf5v4yGkMkM1bk
	I7Y+pgDgeLqvqCaTK236ADldRoU6Q7Rvj8EDzlRPGYfUdGbtZrGJ2B2oZ+bIBTR
X-Received: by 2002:a17:90b:4a45:b0:3aa:9a32:504f with SMTP id 98e67ed59e1d1-3ab3a359e32mr339407a91.7.1791504774101;
        Thu, 08 Oct 2026 17:12:54 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [24.64.171.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36f46dfesm886816a91.8.2026.10.08.17.12.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2026 17:12:53 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.3\))
Subject: Re: [PATCH] mke2fs: tolerate unsupported xattrs in mke2fs -d
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20261008230858.87001-1-graham@mhn.org>
Date: Thu, 8 Oct 2026 18:12:41 -0600
Cc: linux-ext4@vger.kernel.org,
 tytso@mit.edu
Content-Transfer-Encoding: 7bit
Message-Id: <4DB8BAE3-8896-41B6-B4A2-97AB61854FBA@dilger.ca>
References: <20261008230858.87001-1-graham@mhn.org>
To: graham@mhn.org
X-Mailer: Apple Mail (2.3864.700.51.1.3)

On Oct 8, 2026, at 17:08, graham@mhn.org wrote:
> 
> From: Graham Mainwaring <graham@mhn.org>
> 
> When populating a filesystem image with "mke2fs -d", set_inode_xattr()
> copies the extended attributes of each source file. If llistxattr()
> fails with ENOTSUP it simply returns 0 and copies no attributes.
> 
> However, if llistxattr() reports an attribute name but the subsequent
> lgetxattr() fails with ENOTSUP, the whole copy is aborted and mke2fs
> returns with an error. This can happen when running mke2fs inside a
> sandboxed environment running on an SELinux-enabled host. Processes
> in the sandbox see, but cannot read, the "security.selinux" label
> from host files.
> 
> The fix is just to extend the existing ENOTSUP tolerance to the
> per-attribute lgetxattr() calls.
> 
> Signed-off-by: Graham Mainwaring <graham@mhn.org>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Cheers, Andreas





