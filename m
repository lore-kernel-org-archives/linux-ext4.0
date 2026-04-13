Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB04391831
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 13:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776086053; cv=none; b=TwYJbnR9XrznU6iSNnoshzEEehXL7RqLIXhBM8wM4vlmQnSO/y+AgsG4UyFdf9hDXiHbm7Boi8FhGexr8XwIJjmNYBKKAQhLaRLy07UyVxBq+UOu7vhxIro7xqHP8yPEjuRQEBPnR973vbkwfMQFAyTxb0AkZfkKv+P4JEsEFr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776086053; c=relaxed/simple;
	bh=2AuBWIFvC7/nquJkHpvRixm9ibvOCSk5O0qQhIFfOcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsxS7OwnI6HYOizl2Lbl6xG0GmltI/BQxVvJhB84gW7dMeybBIwdFKzqeQa1zGbSy2glhoQ0sJo8L/OhG5MxRSXBWU85qeWeGGW/wX+dmEU4BfRRGAI/iNr970udb7WFzOryphyWJLrgqIpxneGJq+URAw4OpatnWcSQfKi5eiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=KHnK4LK1; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="KHnK4LK1"
Received: from macsyma.thunk.org (pool-173-48-113-10.bstnma.fios.verizon.net [173.48.113.10])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63DDDj5b029103
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 09:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1776086029; bh=Yumz4VVI2CvZaQiNYD8g1kkjxRQ41MO3HgLPa2OvHuE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=KHnK4LK1T+bzkuou4AsvWt9CpkFtM1jkjdo0jSsBgdbD5xAnoIgGO5DrXRD064xEZ
	 GKnOGRUH0ukUsNo3lxG3kTAa/p0CPFQPSkOHlWyB8Rjo051v5i6DfI3Y4yNPaUAKNo
	 skqUkyqZmGjibkZEMzwLjSx9sOdqcSa+b3xpPVcCWfCsFtQjzDhEwUF7ZLytv0GguR
	 c7T7D5t+DzY2exVF889bhRH7pDASdKNjo6Jg/pa+wP1CPeuJYIICBvpHcUt3pEGesN
	 m5MFLKwU/z7KCoK/AsDNofPtLd03bsVVXX7TEbIGSMtvRCMFsU9wI+VIKUXGR7vFI/
	 Jy/aWHPpT3ZvA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id D1F3E62DBF45; Mon, 13 Apr 2026 09:12:44 -0400 (EDT)
Date: Mon, 13 Apr 2026 09:12:44 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Li Chen <me@linux.beauty>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-trace-kernel <linux-trace-kernel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v4 0/7] ext4: fast commit: snapshot inode state for FC log
Message-ID: <20260413131244.GB20496@macsyma-wired.lan>
References: <20260120112538.132774-1-me@linux.beauty>
 <20260410011843.GD99725@macsyma-wired.lan>
 <19d86eec635.f7072461135455.4960134919814592320@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19d86eec635.f7072461135455.4960134919814592320@linux.beauty>

On Mon, Apr 13, 2026 at 09:01:28PM +0800, Li Chen wrote:
> Absolutely! It's great to learn about the Sashiko development site.
> I will address the real issues in the next version.

Note that Sashiko will sometimes report a pre-existing issue as if it
were a problem with the commit.  If that happens, feel free to ignore
its complaint; what I consider best practice is to either (a) fix it
in the a subsequent patch or patch series, or (b) leave a TODO in the
code.

I've asked the Sashiko folks to add way for URI's for each issue that
are identified by Sashiko, so we can put a URL in the TODO comment for
someone who wants to fix it later, and to make it easier for Sashiko
to identified pre-existing issues so it doesn't comment on the same
issue across multiple commit reviews (and perhaps save on the some LLM
token budget :-).

In the next few days, for patches sent to linux-ext4, Sashiko will
start e-mailing its reviews to the patch submitter and to me as the
maintainer.  Once we can reduce the false positive rate, I'll ask that
the reviews be cc'ed to the linux-ext4 mailing list.  But it seems
good enough that to send e-mails to the patch submitter and the
maintainer --- but that's a decision that each subsystem maintainer
will be making on their own.

Cheers,

						- Ted
