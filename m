Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CA942AA6;
	Mon, 13 Apr 2026 13:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776085300; cv=pass; b=XpeLQGERVbpN9O5fRD6BKQy14lrq9QHNuZ7EhWAkMZQLFeI3RkLufWPQXD4Ku1+B9wov+6nu07puFXJqkuOmGZbcus6i/eHEZsEEZbXpR10nUUGKk+PJb/YjMF7L+yU1vTl0qyTOmdLokRbQt57YK0WUpdhUVHIvBJGsK7oEdHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776085300; c=relaxed/simple;
	bh=1rtlhsY10oj7Ujm4LTeHA/e6R6PYP0B4KybPDkzRuCE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=s5U/3VdMT3G5gIrLD0cepSJDvSVQarYbK7rsk/40BaFyk3lwlZLIgUdNknDD8SZwkP6GLcViS2PZWZSoEHsN4UQXu9dVvxKKMS+UAE1NQ7LNSFw1sWlODNaIjmk4lnCQIDXSXXDYnBv1CK0fXdgTjHjMKZ9DptmH4/PnxILC+UE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=uFRCqujN; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="uFRCqujN"
ARC-Seal: i=1; a=rsa-sha256; t=1776085290; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fQrNKi+Bt6celFB5pDaZH6m4ElCqV0bglig0oxwapb9ub4oXZe7+omiQbQaOKb068rn4fK9oVZ8LB0G+JWTKEActsDZokhpGLopV/3wmZeBeWi5NIKkHmF0JoQdvSkneZ9tt4sn2rO+NyQ4nC5RTmLX14Fy9uX7hTdPwtZ2mPPM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1776085290; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7zX6X0tk3N383rYfE4eeh8P3zefqfv5oZE/0Nt4K2iE=; 
	b=LPWszeh8vd7kbet/Z5bD13b+EBcXLql5jIgASqsvvdvIdzmZ1YPzj5PnPoWONL3JKWPpbwDDownmlOqfjsDyRbHA993YSFt7vNGukSrG+sO3o4G3km6u0ZdBPIqo9ahaICpvcqcEuhspK8Giy+PyahmdBzQVxLaDVYiMf0+c7IY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776085290;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=7zX6X0tk3N383rYfE4eeh8P3zefqfv5oZE/0Nt4K2iE=;
	b=uFRCqujNOlt8o+/lu7Al+OddtSJJsqyRrVIiqGFv7srpYK9nqV2J3Yil+JseVYMP
	0xQR+vkwXxRByr0LPjD4LDdaW7yT2SeRm8j77fuDIoW2ZHVfHpZm4thOOPonJk073kK
	5LB9yS+E4R7QLyDQ9t1E7rybRYvMGe+Dt8quEyig=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1776085288521295.69770301591234; Mon, 13 Apr 2026 06:01:28 -0700 (PDT)
Date: Mon, 13 Apr 2026 21:01:28 +0800
From: Li Chen <me@linux.beauty>
To: "Theodore Tso" <tytso@mit.edu>
Cc: "Zhang Yi" <yi.zhang@huaweicloud.com>,
	"Andreas Dilger" <adilger.kernel@dilger.ca>,
	"Steven Rostedt" <rostedt@goodmis.org>,
	"Masami Hiramatsu" <mhiramat@kernel.org>,
	"Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-trace-kernel" <linux-trace-kernel@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19d86eec635.f7072461135455.4960134919814592320@linux.beauty>
In-Reply-To: <20260410011843.GD99725@macsyma-wired.lan>
References: <20260120112538.132774-1-me@linux.beauty> <20260410011843.GD99725@macsyma-wired.lan>
Subject: Re: [RFC v4 0/7] ext4: fast commit: snapshot inode state for FC log
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Ted,

 ---- On Fri, 10 Apr 2026 09:18:43 +0800  Theodore Tso <tytso@mit.edu> wrot=
e ---=20
 > On Tue, Jan 20, 2026 at 07:25:29PM +0800, Li Chen wrote:
 > > Hi,
 > >=20
 > > (This RFC v4 series is based on linux-next tag next-20260106, plus the
 > > prerequisite patch "ext4: fast commit: make s_fc_lock reclaim-safe" po=
sted at:
 > > https://lore.kernel.org/all/20260106120621.440126-1-me@linux.beauty/)
 >=20
 > Can you take a look at the Sashiko reviews here:
 >=20
 >     https://sashiko.dev/#/patchset/20260408112020.716706-1-me%40linux.be=
auty
 >=20
 > There seems to be at least one legitimate concern, which is the
 > potential cur_lblk overflow.  There are a couple of others which I
 > think is real; could you please look at their review comments?

Absolutely! It's great to learn about the Sashiko development site.
I will address the real issues in the next version.

Regards,
Li=E2=80=8B

