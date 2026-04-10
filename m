Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5973E023E
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834349; cv=none; b=hp8/MsBauRRFRplXf966eCOME6DkMnl3LY0Okkid9hAo9vBQ7BoXknm9bo1yUAKOds+q9BJhwtKi0RmAgm3NGvQZapLM6LkaIzbdED1OF1i2euGY1fnttE0NuiukV2nZaUNisSDDcOq0Vmc2JMzTtzqIUg/iKwxBI8JhNIoTq50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834349; c=relaxed/simple;
	bh=sFz28F1BEZH0cmlxg0aKV7LqrA4yFyPxL8MrhsHZgGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jIdyS0s2Wh+XVvOhYIUhguAxtVafA+K+RT5B94zKIuQVBv55T1MMhFKW1n2gk9vsYHUHusmopSt8d3fpXtGNunN/kyOEifLguNMakpnjR1ruvlV3aIlfUbfBuAA4kEwTF78f868r3qqTMhwgDBG8RA8lC8xCNFNudi/C5pApr40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=ChOg29cs; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="ChOg29cs"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFImbq015766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834330; bh=6/uFGAFYFBOL7alP9AK9MNbcbsBm5dSCoxjV8F/bfag=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=ChOg29cs7xnfpRdKrmqVd0RDNZZPERGX3OLEdoiec2aTUJhkyAfM2wzSB13Gdr4PR
	 SNhlgi+2hPlOGEjGquhMJvKBL04Wqpn/L+J2Z2iUZZeWUJ7y6JZizzLNrU/1qzpYvu
	 u0nfqidzmMq2ClrklG0n1ivhIcaJKYtKLpqcpqOYe7kNxI0dOByXp+goVzpgjVdPRL
	 xK9Mo4g4ZvOPyVN0WrOjGM4L+qt9kYerZBP5sbPTh2zUF9WdtKqcCmjnZvyFfnmunz
	 girjH8NjtddCOJszNuXfCQ+8hz8pZY1/JusZDr6Lw9TNNQk8/gLFCkSILZoHdR+n81
	 mMPOgFdvNjlhQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E62F52E00D7; Fri, 10 Apr 2026 11:18:47 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.laight.linux@gmail.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] ext4: Fix diagnostic printf formats
Date: Fri, 10 Apr 2026 11:18:31 -0400
Message-ID: <177583430874.2758959.16475419991117229940.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326201804.3881-1-david.laight.linux@gmail.com>
References: <20260326201804.3881-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 26 Mar 2026 20:18:04 +0000, david.laight.linux@gmail.com wrote:
> The formats for non-terminated names should be "%.*s" not "%*.s".
> The kernel currently treats "%*.s" as equivalent to "%*s" whereas
> userspace requires it be equivalent to "%*.0s".
> Neither is correct here.

Applied, thanks!

[1/1] ext4: Fix diagnostic printf formats
      commit: 6ea3b34d8625ef5544d1c619bd67e2c6080ea4c2

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
