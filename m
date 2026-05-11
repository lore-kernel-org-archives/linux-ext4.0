Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70F436895D
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778502983; cv=none; b=fNnJM/y3EPkQdpjgpcT078ymOPE5oyhGpqU3AAhwHr5PHLb7osTgqye/p4fqYRB5eaZqIeK4wPcrGXcUOTwJiVNDTiMmdZZsZs2/UILayz3dU0AdwzH7JELa2EShCkL/4rTaNP500WzVOIWazKDYdSLswT7gru6ELQm1RR+clyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778502983; c=relaxed/simple;
	bh=LnYr1/Cze3pikba9e2nBisqWKsyalcxTm+QXQWL/03U=;
	h=Message-Id:Subject:From:In-Reply-To:Date:To:Cc:Mime-Version:
	 References:Content-Type; b=QVojHPm9holRrsVOHpempT7cEpEO7berN4gHaE53gW1PDhb/afv+LnVxUy17ImfXCHH7yEwvwJOAIkDqnuNRw7VR02hgA91OLqx9o4RClTEsO6g1LMEYhrOQgt+T/K9YrJtpiP+xQwPqgugy1PzWYkMJ73v6nf9qfD4vpjLyYcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=VXfXcMgX; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="VXfXcMgX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778502976; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=LnYr1/Cze3pikba9e2nBisqWKsyalcxTm+QXQWL/03U=;
 b=VXfXcMgXf5PezoFbHmqDG546UXE5DVOMq8J+wki9opzFfS5FTPW51Tcl1MbnqeigNnbzZs
 m8QnuH4gWVJVQqTNUtnAPmp0f03NdTgTw9YEQ+Sxcu+nNSF3H0NMdfdwMLfbf0yWXsKy6u
 AyPm6bwryxgQrVftraAXN9kD1Nny+c5Vl5cCPdx/+PHyLVmbYQZT8+dG5IZ9Euge8Z9zZT
 l52twwf0s/TbukJzzD7hJdPl6b3lwfielKNiADiSUx0jZJ4orhweQnyU/rcMmebqc6yjFA
 ZdqqrZwiueLye8f8ccTWEu+frIIMr24oh0HZdTc+TX6BjRVpYY+K837aGlrT9A==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.919415a3.f115.4675.9766.1280cec4aa93@bytedance.com>
Subject: Re: [PATCH v2] iomap: add simple read path for small direct I/O
From: "changfengnan" <changfengnan@bytedance.com>
In-Reply-To: <agHJoGlwx4MxTQbr@infradead.org>
X-Lms-Return-Path: <lba+16a01cd3e+beb1c0+vger.kernel.org+changfengnan@bytedance.com>
Date: Mon, 11 May 2026 20:36:12 +0800
To: "Christoph Hellwig" <hch@infradead.org>
Cc: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260428114730.14384-1-changfengnan@bytedance.com> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.4a56b91c.8a12.4668.b740.76ff3633f48f@bytedance.com>
	<agHJoGlwx4MxTQbr@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> From: "Christoph Hellwig"<hch@infradead.org>
> Date:=C2=A0 Mon, May 11, 2026, 20:21
> Subject:=C2=A0 Re: [PATCH v2] iomap: add simple read path for small direc=
t I/O
> To: "changfengnan"<changfengnan@bytedance.com>
> Cc: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, <ojas=
win@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, <linux-f=
sdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-kernel@vger.k=
ernel.org>, <lidiangang@bytedance.com>
> On Mon, May 11, 2026 at 08:09:51PM +0800, changfengnan wrote:
> > Ping.
>=C2=A0
> Assisted-by: AI slop is at the end of my todo list sorry.
Get.
>=C2=A0
> If you take all responsibily for it and understand what you are doing,
> please drop it. =C2=A0If not it'll need to wait until everyone else is
> served.
I fully understand what I=E2=80=99m editing, and I=E2=80=99ll take full res=
ponsibility for it.
I used AI to help me review and test this, and I=E2=80=99ll remove it in la=
ter version.

>=C2=A0
