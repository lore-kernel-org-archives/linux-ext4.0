Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A541D345CB0;
	Fri, 27 Mar 2026 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620766; cv=none; b=Rh8egzJ3cQoV7m39CEVqMd540cMUeIzOtj3pjWCrEOUay7OvSliLKiEbT/HBHDGP/MxoeODZ1B9bFMdhujnbeBl2e1+jC3hVLnBt2HyITJKbsMGRIcz6+bf16E/1GveD7fjYmAoYYfRcAHMtuIBKZ4E85kJTcAfDAvVtqtcS9o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620766; c=relaxed/simple;
	bh=swqcJwBXCwupKVvIY8SRloO6Nit0CeeBem4ZEVvNEVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhXh/uJpJxT9Vzo99AevTGDRQXkIOf49z/LR93UPwY6RpNOlicjlFbrL0JfmXOn2aMEiRWgVIfNWFyXHkdXVTBdDzVvue2VXrqMzN51hqnexgaWXOQPcBdgf9twzIhVbo/2yVxe9kdptyyiEnjUesQUqkpQcnTboglok+xmv0dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FtYpSXxE; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FtYpSXxE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774620765; x=1806156765;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=swqcJwBXCwupKVvIY8SRloO6Nit0CeeBem4ZEVvNEVo=;
  b=FtYpSXxEQ1XMGGUeSPApYAhKrUGaB9NFJv8/+ZH6WPe82hVWUG+fiuZQ
   BtjunAW52wdL5d/7q4PF/dNQOGv4mcy0mvMS3NafTiDdcm6CS8vqXLmgm
   Hex9NcH9RuOTf6KgVWFej7QV/TPhMbGyRymlN+YjEjoqxv/cMCZeNgEJR
   BASBXuHIdIc4jeTfO0sZwT+Mz75z4nN5E8T67UMnOjBOpjgbL1uy5Bs3h
   H4+tZevdPDTqO67N4vCFlXSdBrzGuQB2iJw8QaNuK/mAsh9IobuUWalwU
   EwzMQuYtMSSnuQ9mT1IL5f5ylUi/ySU4JPBjZgv6bDHEZIRM0rCFZg0RI
   Q==;
X-CSE-ConnectionGUID: 93vYYldKS0C9UxlveWrD3A==
X-CSE-MsgGUID: IX0LwdbuS0eYR7MAkEVpRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="75891758"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="75891758"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 07:12:44 -0700
X-CSE-ConnectionGUID: m+gJ2oHERhuBgV3Yfrl2gg==
X-CSE-MsgGUID: vevveTHrQaGmYrzJLGmm+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="225246571"
Received: from vpanait-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.127])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 07:12:41 -0700
Date: Fri, 27 Mar 2026 16:12:38 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] ext4: Fix diagnostic printf formats
Message-ID: <acaQVpYREnJJuJF5@ashevche-desk.local>
References: <20260326201804.3881-1-david.laight.linux@gmail.com>
 <acZgmKv38HLhky6q@ashevche-desk.local>
 <20260327125412.47944386@pumpkin>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327125412.47944386@pumpkin>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Mar 27, 2026 at 12:54:12PM +0000, David Laight wrote:
> On Fri, 27 Mar 2026 12:48:56 +0200
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > On Thu, Mar 26, 2026 at 08:18:04PM +0000, david.laight.linux@gmail.com wrote:
> > 
> > > The formats for non-terminated names should be "%.*s" not "%*.s".
> > > The kernel currently treats "%*.s" as equivalent to "%*s" whereas
> > > userspace requires it be equivalent to "%*.0s".
> > > Neither is correct here.  
> > 
> > This entire code seems was never tested properly and it's a dead code
> > until one defines manually DX_DEBUG. It also has tons of plain printk()
> > calls that may behave differently if the first character is not printable
> > but maps to the level of printk().
> > 
> > I'm not sure how your patch helps with all that, but apparently the
> > printed data has to be NUL-terminated, otherwise I have no idea how
> > it was ever working without crashes.
> 
> I noticed that as well.
> I suspect it way have worked for the person that wrote it because the
> name strings all happened to be NUL terminated.
> There is certainly likely to be a '\0' before you 'fall off' mapped
> memory and crash - so maybe they just ignored the extra characters.
> 
> Clearly the other option is to delete it all.

I would go for the history of the change and if it's old enough and not
mentioned in any Documentation or not-so-old email thread, kill all that
for good. But better to hear the ext4 maintainers first.

> But regardless the format string is wrong.

P.S. A bit of off-topic, have you seen this?
https://elixir.bootlin.com/linux/v7.0-rc5/source/kernel/stacktrace.c#L33
Is it correct use of %c?

-- 
With Best Regards,
Andy Shevchenko


