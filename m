Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBA9347525
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 17:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774631707; cv=none; b=sIVkYUBdyy7ZIbSzL7yUX+LEJdogbMHGhiT0H7lDNxOtc4FXk9dD1mwI0fIJUg1yp8815lgdgoImxPzwXCBIvWHxuQtaugsdgk//k6G/7DDk3UX7AB5p5R8nDNQY7LoKqNMGjUlqK1jVueGizgTa9yDt0zYp72TuiX55U2AgV3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774631707; c=relaxed/simple;
	bh=cbJKnsOsrV59t9SrTlbmeaEoWdYfWxalRf2BlcCV99w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDx83PCrw+FDAt3JZHVBBh/lwayoRzxmQDdPSWQA4ClpJs4+XtWKsZ+PCBh7ET77B4KM7199cz71QZL++ROLVkzqr2/Kmrg1qXT+RJqhJ/WV/BOKPAi2dRXaDpukehoQvUVDbq/7IIb3kRyrFEbNUuwY4QmeBsTXVjGpGJ3KuL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=nKvpVgaV; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="nKvpVgaV"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62RHEEXL031540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 13:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774631658; bh=qhC4m8+w/YUxA5P5hC5aC/cvjYIcc1Nx1K+xDs824Uw=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=nKvpVgaVDCwPPSiubMFaZGw9Y4TyBPLeT9sJlmxpjBe3BM0RYdgnZSG522ppgzcJl
	 ByDfeLPu8htrZhS4T44AohteluR6mjr0IdHl46yQI1V+z1JfxgMHZH3/PXABpUVouf
	 favcryuWlT5DuXbr96VJloMuRghdIJs+imEzVlRwO83P5MG1k8+QVlhOb5jltU7ruR
	 w4fTSYYSGsfGhWPdSQGRW45u4Rmxmww8h7ZOiioBkl+JMU/8m5MqtLX7iuNIBNXZIf
	 fBcUcuZIQKeTcWgl8M/V2ilK415J/g5X0VRjP2fE6w3ILK2MQiHhBBl4YJDDb3ND5H
	 /MjYY/zttOorA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 4A0015FA1FF7; Fri, 27 Mar 2026 12:14:14 -0500 (CDT)
Date: Fri, 27 Mar 2026 12:14:14 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Laight <david.laight.linux@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] ext4: Fix diagnostic printf formats
Message-ID: <20260327171414.GF4383@macsyma.local>
References: <20260326201804.3881-1-david.laight.linux@gmail.com>
 <acZgmKv38HLhky6q@ashevche-desk.local>
 <20260327125412.47944386@pumpkin>
 <acaQVpYREnJJuJF5@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acaQVpYREnJJuJF5@ashevche-desk.local>

On Fri, Mar 27, 2026 at 04:12:38PM +0200, Andy Shevchenko wrote:
> > > I'm not sure how your patch helps with all that, but apparently the
> > > printed data has to be NUL-terminated, otherwise I have no idea how
> > > it was ever working without crashes.
> > 
> > I noticed that as well.
> > I suspect it way have worked for the person that wrote it because the
> > name strings all happened to be NUL terminated.
> > There is certainly likely to be a '\0' before you 'fall off' mapped
> > memory and crash - so maybe they just ignored the extra characters.
> > 
> > Clearly the other option is to delete it all.
> 
> I would go for the history of the change and if it's old enough and not
> mentioned in any Documentation or not-so-old email thread, kill all that
> for good. But better to hear the ext4 maintainers first.

This is code that can only be manually enabled by adding a

#define DX_DEBUG

to the sources; it's not anything that users can configure using
Kconfig.  It *has* been used relatively recently, when developers
added support for three level htree directories.  I'm not sure why
they didn't run into the NULL termination issue, but since it is handy
to have the debugging code for developers' use, my preference would be
to keep the code and fix it up the problems.

   	    	     	    - Ted
