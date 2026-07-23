Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039A3242DF
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 02:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784772386; cv=none; b=qf+DJhSOyTmpbRYgjM/6ap0HrL1uSr4PEyIvwueBEKJxQkYcuGoR/ZmbSe6g0PJeKh/rD1OOSCFckjOhW5o3l57OJa3QSlvp1z7af6KWYHN2T7f1YimG5vhaZx8VoF9GeC/8YR9ELIdrBWi/hYSyxOqv327AF0UfXyqIOLfIeHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784772386; c=relaxed/simple;
	bh=o1dAa5dlWYFIUduC4bmxRXL7QQfplW5GTsHpOMWZr+o=;
	h=Message-Id:To:References:In-Reply-To:Content-Type:Date:Cc:Subject:
	 From:Mime-Version; b=j1LTI3XatUWxuZrYdylU9glF8kLZI+I4nrMfWnafHbIYfGZN8PCySQiar7GpqkfQoDZHyEzWv7GRPaZv7UqqW8m5uhpUmRxQC1zrvszVvijtsT8r8gjvvgnBPpeWZ0IrTcI11XxGztTzKHQjSEBNbHPIzVjbJk7WG5k2ZJOE7yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=DAd5Iky/; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="DAd5Iky/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784772378; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=o1dAa5dlWYFIUduC4bmxRXL7QQfplW5GTsHpOMWZr+o=;
 b=DAd5Iky/aruibefVd1cId2+t+/8dxBy7dlhYAZxh2elmNydYWlRtbZZxYOEGuEBUcZu8HI
 3rfxvwVdVMeALoeUNaHPrHJ29KZpElzoPyoBosOASIJTYTOzKw3kumROd+vwIQkA337n9l
 OwlBgh4aEZ6wOH5TfEVZlS84sW2k0zAhqGyiK8NZxw6YdQMkx1f0bqwEOvtOLOIKAinbQ6
 lYX6FAEF1L1X3LLg9B77ezddKqytDwFhGGfElAGgiTJVALUBa1Q+b/m0l9ShOGkGxvhE2b
 g0erqT99z4+TILamPNePh8cvKpJ3QSJL3lzJcEWVdI+dzQR97v8DuyIMNypdRw==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.873180e9.9f3e.460d.9186.3caddf216bd7@bytedance.com>
To: "Joanne Koong" <joannelkoong@gmail.com>
References: <20260722124931.3159664-1-hch@lst.de> <20260722124931.3159664-4-hch@lst.de>
	<CAJnrk1Yp_X_qKgBFoQ2JwC8DgECZ09x5xsnj83iAQ8cDeXN2dg@mail.gmail.com>
In-Reply-To: <CAJnrk1Yp_X_qKgBFoQ2JwC8DgECZ09x5xsnj83iAQ8cDeXN2dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Jul 2026 10:06:13 +0800
Cc: "Christoph Hellwig" <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
	"Christian Brauner" <brauner@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, "Carlos Maiolino" <cem@kernel.org>, 
	<linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/3] iomap: use GFP_NOWAIT when application for iomap_dio_simple allocations
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+16a617718+e687c4+vger.kernel.org+changfengnan@bytedance.com>
Content-Transfer-Encoding: quoted-printable


> From: "Joanne Koong"<joannelkoong@gmail.com>
> Date:=C2=A0 Thu, Jul 23, 2026, 05:02
> Subject:=C2=A0 Re: [PATCH 3/3] iomap: use GFP_NOWAIT when application for=
 iomap_dio_simple allocations
> To: "Christoph Hellwig"<hch@lst.de>
> Cc: <changfengnan@bytedance.com>, "Darrick J. Wong"<djwong@kernel.org>, "=
Christian Brauner"<brauner@kernel.org>, "Theodore Ts'o"<tytso@mit.edu>, "Ca=
rlos Maiolino"<cem@kernel.org>, <linux-ext4@vger.kernel.org>, <linux-xfs@vg=
er.kernel.org>, <linux-fsdevel@vger.kernel.org>
> On Wed, Jul 22, 2026 at 5:49=E2=80=AFAM Christoph Hellwig <hch@lst.de> wr=
ote:
> >
> > For non-blocking iocbs we should avoid blocking allocation where
> > possible, so switch to a GFP_NOWAIT allocation here.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>=C2=A0
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>

>=C2=A0
