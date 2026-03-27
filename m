Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5123F33BBAF;
	Fri, 27 Mar 2026 10:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774608543; cv=none; b=DPM0BcGHwGyboas3RY5zb0GCpGmCZsDIhhHwJFucngXBT/B6AqCGNY4b1ZK6hRrl7W2ih6rWYGAR8RRqpo/mIN9sXSqLklY1tAlLeZyiZmXvIR9is63HfYSG70KCekrihCJ5Q4s9NYjNP/snTHspNzunkLOZtXKSLSqjpJ8NrTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774608543; c=relaxed/simple;
	bh=3mjGEhU0LeLSbKWActMArkaadnySUiC1mQUiJueQUh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djMbljE/yxqy5VL24TYp2ErSthZBnIpnwJ61ndhlke5LOTQwvW/XS3xbP/gCmjvg559wfM0LCJwzM5UPpkcpdk6AYlOHFzfKR2hvRD2Ff7yLX5x560OB8RvrrsrFpZr/aRpyneoh6T2OKGvL16fJFB7xmu+uJgb45gVappwYEwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GIcACUXQ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GIcACUXQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774608543; x=1806144543;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3mjGEhU0LeLSbKWActMArkaadnySUiC1mQUiJueQUh8=;
  b=GIcACUXQYeD4zElW6yszKY10qd4XTJZmf/sUyeezVWL89kDbeFjQHg7y
   Pkk+qLnyLFOTu+LVvGEsed2mObqKHmBYGg4qTBmv/scEnXIj0bmAfU7CJ
   ZOsNip+TZ3scblZ+uV3AXhbGT99KLa8qb4Z++ieaYn7xzZEWC6844seTn
   J08zWGWIX7dWopjpj4JWWLWVGfHG/d3oruoh0ZUr2atOsKvkfZ00UkJSB
   vRPMEUAcWVXvAj+/z2VqZtM5+RqLbfGEX+z29IXlq4VvEg4OhEjfnc40F
   lLdREWzKAkTO3LZJ4oLbaOZ5ylgRMv7GL8wtuIF7HDhPLzKOznRYr8lrl
   A==;
X-CSE-ConnectionGUID: 9Zbm32f3SH+EfKbiX5ABVg==
X-CSE-MsgGUID: OSCYDyMqTX6vzhZ1RpQ0KQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="79281065"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="79281065"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 03:49:02 -0700
X-CSE-ConnectionGUID: zZPC4c0gQNOzu84sZ8sKgg==
X-CSE-MsgGUID: DW+Fm7DWSayWX2slgATu4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="229364963"
Received: from vpanait-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.127])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 03:48:59 -0700
Date: Fri, 27 Mar 2026 12:48:56 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: david.laight.linux@gmail.com
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
Message-ID: <acZgmKv38HLhky6q@ashevche-desk.local>
References: <20260326201804.3881-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326201804.3881-1-david.laight.linux@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Mar 26, 2026 at 08:18:04PM +0000, david.laight.linux@gmail.com wrote:

> The formats for non-terminated names should be "%.*s" not "%*.s".
> The kernel currently treats "%*.s" as equivalent to "%*s" whereas
> userspace requires it be equivalent to "%*.0s".
> Neither is correct here.

This entire code seems was never tested properly and it's a dead code
until one defines manually DX_DEBUG. It also has tons of plain printk()
calls that may behave differently if the first character is not printable
but maps to the level of printk().

I'm not sure how your patch helps with all that, but apparently the
printed data has to be NUL-terminated, otherwise I have no idea how
it was ever working without crashes.

-- 
With Best Regards,
Andy Shevchenko


