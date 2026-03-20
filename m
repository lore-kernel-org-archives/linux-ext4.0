Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052C1335571
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 07:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773992616; cv=pass; b=t3CvtSDM5P3EAPmRrE57PjadKqXVkq7qEaKK26Qc7Q5oCgn4Cvp9WrexTGWUeHKSSqsdD5KxgzX/QCNNXGrjgG9NZST2FkM0Fdu51QythOKgS34+B45isbywpF3hEpqB/VCnCj4yxgxVvoeFlRWZWkACSHqcr6LTIxPqGDBffA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773992616; c=relaxed/simple;
	bh=RlOnalncJRXIlyYuLKjmVtEW17H7itzj7J5Hhw9r4v4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LEcQCg3NsA1PNXwCGYZ/UgfwmL2cU9hucODUn/n5317JN2Y/RRXiPZ0qeShKoRHUSkFqc47Yc74ZJRhPFMwiW+X5voqk4NlJ64Jq/0TiGPZEyTWfMVtA31VcKQEI1ZR+ZWdMWSNlRQuqbVNgDingZPWJPqPIAa87MNGC3XhoOp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7jkzBdX; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7jkzBdX"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6686d06c411so2501355a12.3
        for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 00:43:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773992613; cv=none;
        d=google.com; s=arc-20240605;
        b=fBcP09VG0OB7Vo2xydf+1Ju5CQAWvOXMTfNbMtuj7yXSCMhh9H5mK9KY9+1PXb7Bu5
         caFXpAZEDiN8XBCRVBprAaQL2CRKeJTcpuobEoqrytCFuqIkJRHB0PePMBUqr2VnAmNR
         5tXlASzd63J3fBwPqdV6mVuvnm14GCd/Yk9wa9V6tCGf5ttQl+NsW2/bNfVoKOkgbSVc
         jCNhixOu28T3Xp9WUdnQS652Rqv1W42ZNuXPdWx1mgB+PYhpSUMcGhync9ZhcGG1W0jS
         Li7KX9fxc1u650QbacRY2l7QlsxeChGVy2ZA5RtOpZ+puG5+nPiNftuQyZM/isvAMPRa
         lnjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZnmAAX0F5BvT7Ekm6/q+ZVK3TkJKOZIX6rvlGFkJP6s=;
        fh=eyV9H2Mu6DaM5BCooLkFZkfIwI4JuV9QtvdRsh0UmhM=;
        b=b1L1fMp7WEdPcunTRHbiJx+bBrsnhqNw0T6eUyHJS5Qf9ocDsmnBQtVPBwWarszN1t
         vxLIJzjybLVoFNnswuIbOItb2pEReAWTXbNhZ9Lzg/fgDuG6s3l/ZCarRtX6vy8NpbEm
         ECKWrIQRtS2E64K+J7M6cYY+rDdyzWKLkclYJ21kw6MmT0swrhjiG5/WrpcvLLG9Wrv0
         or/j9ctWI5TLTGkNf9OVstR2lXS9r3T/wJgW1s3HWxI2Bm7SGPUZRBfkbvWhjJg5Drd2
         DwrzKI2k2pj5ib9SZhuR2OVRYkczDAroK6cXJOWXOqOYT57LoEbvFbljgO4L4CQMxIzy
         OcFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773992613; x=1774597413; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZnmAAX0F5BvT7Ekm6/q+ZVK3TkJKOZIX6rvlGFkJP6s=;
        b=D7jkzBdXkP3tLzYL4LGjl+OEHNm2ok/lUPkV9AR83y/D21yqUpd4MxLyQTLX4OgB25
         Ub7PVrxT1AXvKO1XqHm7Rk4evgjsi8OK/1TD4/4QYs/aQg4lKOBQGNcBY31TmsIJhocU
         PulzubrCA/HRiMeOqvepV7M4fFLK1AguV7KJrqd3VKBVYE1LRqhDO6o+LrWQkiMkkKRh
         7npzUMqLL4mbBofhWfgpsCLK6GRE3Q5/erfdbBx8siDH1K4nQLJ9+ZUqyJfGMfLVXDP6
         PCLI3d5w2WhPe/Qa84Hu2DqfyrlUARcI7ugiEBagnj9QiFCg6Z1WqTPQWy27C+9rWG5o
         EDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773992613; x=1774597413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZnmAAX0F5BvT7Ekm6/q+ZVK3TkJKOZIX6rvlGFkJP6s=;
        b=NtEQe+7qyo3Pv1t4yIv1Aph3Tjdatkf0+zeLs7yDuUevVBrYZVJ9Qfc4VNq3dBRcwi
         Sun75taytDyiTZfOJBM/CoeW7TUAIe1n1ZDVzYcERAM0Z3S+GKWI4Cin4Z6TA/1Fj5/x
         Zd2/AsDvoLXmYbWKfeem1Nrnpkj7rECcjkd7PJq6LPtf98C+iBSokLJzkT4I60a26AA5
         Zg7PtSemBXcUeJNut4o8OCbyK7IDT8UEg46VoNhMKrm1CW6b2LUhoG8bMGDbBYH+/IJ7
         7BO6DEjLo5B4rcok7V0EOdTn00I3chaABa0MaP08rrTdKMfgjaHUuKgey0jQv4Qulvgt
         t/+A==
X-Forwarded-Encrypted: i=1; AJvYcCUBOd18nVu1rKInqofrso1k2LCkw3JyRTrOhoz7OiCHgPcwETjx6PyiGhH479t5tRyq0/GSAmExH8Zp@vger.kernel.org
X-Gm-Message-State: AOJu0YzW3jAGRL0237KLjAJxHSJB8jyU1Kw4MnInWDD5TM5iokUkszN1
	DINBc8j9HnIAFAr8f3kwPjV+qtjn2jheDjG6dt2XMj1tlMkx6tBBlVUS1uO18OM6XmcmE9q2BZz
	2+jPPxGkCrnlcN2B4wDE34Gonvs1+9ng=
X-Gm-Gg: ATEYQzzkHAjFRcT0xXEbtQWlFcGmkihdi5X3Y8ZUwL5LTOJ5Za7AAJPuY0NQ+GDWywe
	9FT0Q3GmRJhrA27Ft0sNx2dageM5fnfRonPG55JchWE7SB72tpAXG4lEtJC4/QVm+/C9WIzpiJe
	igkis6nONd8GKDz83koRsmNX/gOZEUuSGpA1SFCxij8GGkXdQ5o13KPjAttjF8azJQzDNzZZ7Zf
	4AHoL4oeCHuEvZwiSzuhu8Z70QyN4W5SfAVIpCpiXmIX5Oh6dN4okHbqp1SxjHAtcoCdw0oMNrS
	OAr50Ntrdhp8HpE1LcrhwLmHbmENUlRqO//LLwk9U93rqTvqPS0qVVg=
X-Received: by 2002:a17:907:c30f:b0:b98:33a7:d5e3 with SMTP id
 a640c23a62f3a-b9833a7da38mr92239066b.8.1773992612858; Fri, 20 Mar 2026
 00:43:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318075842.3341370-1-gality369@gmail.com> <20260318144509.GA82331@macsyma-wired.lan>
 <CAOmEq9Uq5xMvhT7cyoY2uhSBhwSEEJ1vYRY36N4sxZSPCO1S8w@mail.gmail.com> <20260319135826.GA91368@macsyma-wired.lan>
In-Reply-To: <20260319135826.GA91368@macsyma-wired.lan>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Fri, 20 Mar 2026 15:43:21 +0800
X-Gm-Features: AaiRm50Kae10smYX-Q49h1EZ7iONGnZgBSsOmlgQkjHk0D8vD2D3MhNxlmOLYf0
Message-ID: <CAOmEq9VAW_a7RsSPquy0_eJOLP4aHOWvwTtzmeLUPXpy85xJvw@mail.gmail.com>
Subject: Re: [PATCH] ext4: xattr: fix out-of-bounds access in ext4_xattr_set_entry
To: Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, tahsin@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2026 at 9:59=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote:
> We don't consider bugs which involve modfying the mounted filesystem
> as valid from a security perspective.  In particular, I don't want to
> add checks to hotpaths to try to protect against these sorts of
> failures, because they simply shouldn't be allowed --- and/or if the
> attacker has write access to the block device while the file system is
> mounted, you've basically lost already.

Thank you for the detailed explanation. I understand that runtime
modifications to a mounted block device are considered out of scope,
and adding checks for such cases in hot paths would be too costly.

Our original understanding was that a filesystem should handle on-disk
inconsistencies gracefully, so we used this approach to simulate
silent disk corruption or I/O errors at runtime and test filesystem
robustness. From your reply above, it seems that this understanding
may not be correct.

> That being said, we are more likely to accept patches to address
> static file system corruption, but the checks need to be done when the
> metadata in question is first loaded, and outside of a hot path.  But
> trying to defend against dynamic modifications of the block device is
> really a fools errand, without completely trashing the performance of
> the file system.

There seem to be three layers of defense: fsck, mount-time checks, and
runtime checks. Would it be more accurate to understand the boundary
this way: once the filesystem metadata has passed mount-time
validation (even if it would not necessarily pass fsck), the
filesystem is still expected to handle later errors gracefully rather
than crash?

More specifically, for inconsistencies that arise at runtime, is the
general expectation that they are outside the filesystem's
responsibility and should instead be handled by other layers (for
example, lower-level storage redundancy / RAID)? Or is there still
room for defensive checks in the filesystem, as long as they are done
outside hot paths?

Thanks again for your time and clarification.

Best regards,
ZhengYuan Huang
