Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8733B2F39CE;
	Sun, 29 Mar 2026 11:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774784240; cv=none; b=oxXTBHhK8hqMxz/QzkTUBIIicAufWUXSkZcwJNJv4YYolJsEPXhgeSl3bw2dHJnMG/4CWiCi0VeiY/rKp1dYvZTtCUDJNgrbk3OeYfOxrbMcNBTdeGQP3JvfMZ0x+LPb0lNBFV7xWXX67H2IqIZTrL7ACQsti7tbFZaD+MQqNOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774784240; c=relaxed/simple;
	bh=Y94YKh9JUyszCHMsByFr1LncXynXg/XtLg4NM3fV9po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3Emaa6FMlgIOxoRywg6Zroa88c0G/w6vn8dj2JBt35gvziL7q43Qa2P8byUAWY8h0ldHCrzO9uMFkcu6kUC5UnTZzCyXk+6reJVigd8Az6LflX931IL/Z+Zt99arjhfP84ZU9Rhiu6hmA7SYHmGwa1WXc6PtT0n2VIlEEhqnzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AQFQrGK6; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AQFQrGK6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774784239; x=1806320239;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y94YKh9JUyszCHMsByFr1LncXynXg/XtLg4NM3fV9po=;
  b=AQFQrGK6TYkUWvmbnG9BjoN3DbroGpYJ/KeXDWP0nJ6pzxX/OaSOa8KH
   o8DVBhuEu9UsVZiQ3NCHskyxcIV/XHR6t4lRHDNAbkASkcE9syBDN4i2B
   1K/oHdP/LViWo4YLMr21MXxgtptGaDzCW0ljMpOvga9MgwNQSH5vGPsBr
   n9TVCSzcmtt3lpqsNG/kJ5Iu3qYa6YWPgVJO/EnjTPMk3ctzHpVDJTLeJ
   h4xrkdHfloXvGf+UK4pK1Rz1S8wCyKrgkP2YGVz4lwZlPIiowit0rTSR7
   QOHlQE8ZhYMOUb2ekpLOieuDwCRem/nnqHngAzJ63CaqsWtc+c9qZJp5S
   g==;
X-CSE-ConnectionGUID: ItqqgbdbRFu4AbSVOp07rA==
X-CSE-MsgGUID: l5B7CYIPQd65NGyVgP/8bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="86872229"
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="86872229"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 04:37:18 -0700
X-CSE-ConnectionGUID: ikcMtWVpTQSc9S15ygXoJg==
X-CSE-MsgGUID: i5dxabq3R+eABJqTeY2iJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="221378089"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.29])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 04:37:15 -0700
Date: Sun, 29 Mar 2026 14:37:13 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Theodore Tso <tytso@mit.edu>
Cc: David Laight <david.laight.linux@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] ext4: Fix diagnostic printf formats
Message-ID: <ackO6fL5l2xQxfLN@ashevche-desk.local>
References: <20260326201804.3881-1-david.laight.linux@gmail.com>
 <acZgmKv38HLhky6q@ashevche-desk.local>
 <20260327125412.47944386@pumpkin>
 <acaQVpYREnJJuJF5@ashevche-desk.local>
 <20260327171414.GF4383@macsyma.local>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327171414.GF4383@macsyma.local>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Mar 27, 2026 at 12:14:14PM -0500, Theodore Tso wrote:
> On Fri, Mar 27, 2026 at 04:12:38PM +0200, Andy Shevchenko wrote:
> > > > I'm not sure how your patch helps with all that, but apparently the
> > > > printed data has to be NUL-terminated, otherwise I have no idea how
> > > > it was ever working without crashes.
> > > 
> > > I noticed that as well.
> > > I suspect it way have worked for the person that wrote it because the
> > > name strings all happened to be NUL terminated.
> > > There is certainly likely to be a '\0' before you 'fall off' mapped
> > > memory and crash - so maybe they just ignored the extra characters.
> > > 
> > > Clearly the other option is to delete it all.
> > 
> > I would go for the history of the change and if it's old enough and not
> > mentioned in any Documentation or not-so-old email thread, kill all that
> > for good. But better to hear the ext4 maintainers first.
> 
> This is code that can only be manually enabled by adding a
> 
> #define DX_DEBUG
> 
> to the sources; it's not anything that users can configure using
> Kconfig.  It *has* been used relatively recently, when developers
> added support for three level htree directories.  I'm not sure why
> they didn't run into the NULL termination issue, but since it is handy
> to have the debugging code for developers' use, my preference would be
> to keep the code and fix it up the problems.

Good to know!

But what is expected input here, i.o.w. should we assume it's always
NUL-terminated, or use fixed-length strings? If the latter one is correct
the current patch may be applied as is then.


-- 
With Best Regards,
Andy Shevchenko


