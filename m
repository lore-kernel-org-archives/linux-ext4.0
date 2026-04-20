Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7353C13AA2F;
	Mon, 20 Apr 2026 09:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776677840; cv=pass; b=IIdT5tHyu+I1/Rl5xAGxMOC5dIT5FxryDzGp3TA9X95sa7TlIsr3nAlGRDUJGfTySvCzZWD+OfnOUGoRRPrehWpXo3HSS8oGcGWg0M7L6S7PHwld86ts8cGUrKgVkRr2V/aQTwYLEnpGC7xHLj0HEpjQKwAqz8aRuMu51A+YeTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776677840; c=relaxed/simple;
	bh=+Mn7HI+O1Risb5b4c09+GnfDkqMve5PgHTnlKsfVV0U=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=CQ0nLTJhr8vjD4rcjOD6I26ZsosVG3b8oBhM89UYLACYfNeYgJQAzWQhdlxCIE49NvKfqZbpTVQdKADi5MSr4rLKIMPAUUatHph+6ngMhYPF0uFJ906aPzopU7AP9WH9ILrZnM546ekmBZHej5fgMaMKUBbzvuKCzTaF8Mwej4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=sfYnBYxn; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="sfYnBYxn"
ARC-Seal: i=1; a=rsa-sha256; t=1776677828; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NtBwkSDIrYwMyyrRSRB7c4iQn5E72WMQFME8gJVoNRFZbFpmIHwpBXzcSoLjF9Qitqx9Q1+H4sX0Mf116bV4AnsWnZWfhMXmTX5iSJOqOYmZAMVzggwkXyXlKO98HsvoQx95WfglDVOg6dNFD5zHiWTPRcg2dJ9KOz81ARMQuQk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1776677828; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=3nkZU0OGVm9sAS0m+p5KNBkUjb4lcYBwbSn6ftdUGMc=; 
	b=GaOnn6NoDmuhREz6WV5hfhqhf2izF5rqUywIvKeJB5eR56R8jBVU5mWAfF7MXZPwPX9QcvilvCmH56B/NWXcV2fKTEueFgJCT1ItQsDy9cCpOQ03uq3DhGJH8h6iLUSwRkjWlj8zN8rx7iFWBiKiC2E4ulFOe43/vv78Ikxls9w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776677828;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=3nkZU0OGVm9sAS0m+p5KNBkUjb4lcYBwbSn6ftdUGMc=;
	b=sfYnBYxnTgwDsE0SmEml2NPzMsSK3elsWfk3a3uvX8ZX0e87951D1rJPg9VyxrQJ
	dIa3pm21VRP/gmXceGTOSVCU0tTDQeycYrFMCtte3rjd+UNKjXDFhw8d1VYeh1fiXcL
	2RF7DNC9M3e0MvbPdz/yRIGGFqlVr13Jm9GBm8M0=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1776677822245708.6024512424901; Mon, 20 Apr 2026 02:37:02 -0700 (PDT)
Date: Mon, 20 Apr 2026 17:37:02 +0800
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
Message-ID: <19daa401f13.167eb5bb5258134.3788270263630358850@linux.beauty>
In-Reply-To: <20260413131244.GB20496@macsyma-wired.lan>
References: <20260120112538.132774-1-me@linux.beauty>
 <20260410011843.GD99725@macsyma-wired.lan>
 <19d86eec635.f7072461135455.4960134919814592320@linux.beauty> <20260413131244.GB20496@macsyma-wired.lan>
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

Hi Theodore,

 ---- On Mon, 13 Apr 2026 21:12:44 +0800  Theodore Tso <tytso@mit.edu> wrot=
e ---=20
 > On Mon, Apr 13, 2026 at 09:01:28PM +0800, Li Chen wrote:
 > > Absolutely! It's great to learn about the Sashiko development site.
 > > I will address the real issues in the next version.
 >=20
 > Note that Sashiko will sometimes report a pre-existing issue as if it
 > were a problem with the commit.  If that happens, feel free to ignore
 > its complaint; what I consider best practice is to either (a) fix it
 > in the a subsequent patch or patch series, or (b) leave a TODO in the
 > code.
 >=20
 > I've asked the Sashiko folks to add way for URI's for each issue that
 > are identified by Sashiko, so we can put a URL in the TODO comment for
 > someone who wants to fix it later, and to make it easier for Sashiko
 > to identified pre-existing issues so it doesn't comment on the same
 > issue across multiple commit reviews (and perhaps save on the some LLM
 > token budget :-).
 >=20
 > In the next few days, for patches sent to linux-ext4, Sashiko will
 > start e-mailing its reviews to the patch submitter and to me as the
 > maintainer.  Once we can reduce the false positive rate, I'll ask that
 > the reviews be cc'ed to the linux-ext4 mailing list.  But it seems
 > good enough that to send e-mails to the patch submitter and the
 > maintainer --- but that's a decision that each subsystem maintainer
 > will be making on their own.

Got it, thanks. I'll treat Sashiko as a review aid, fix the real issues in =
the next version,=20
and leave unrelated pre-existing issues for follow-up or a TODO.

Regards,
Li=E2=80=8B

