Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE21347209B;
	Wed,  2 Sep 2026 13:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788354218; cv=none; b=lLhahVxJfQBbrURqZ51QbA/kQ3McoBYFDtPiblW5dKGMUtWDHbN7WKtgtndZiK+IFN8zvjTWY+Rf/wbf8aXVyMlmcYvHLe+IRdS0J4cf/XeD7VpJjUKAn0jlRh84FFan9W6xF0+PvnnR/PNhyXA+dhEOq9xTiQS9GuEtJuGFeUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788354218; c=relaxed/simple;
	bh=1/g8QdCFuOqdhgC63+NGkQCYyQ/RcYQH9znnWzFeHNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=llziIQ+8A+EMSFJjCYCKv8bz5Kmy/b7GPu3kgROqd2jq+vXjr5rMQZCes9CdmOR2aAjiYe1N/5MxvP5KwtfzJI5+kgBWUq/vDbADhXtnlOwVt1Nwz6MvG4ga33oK8OTi4FoKnnN4JxFCtExhYVi73qmszxJXbCzZdfGRftGsgU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QX0B71Ep; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QX0B71Ep"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788354216; x=1819890216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1/g8QdCFuOqdhgC63+NGkQCYyQ/RcYQH9znnWzFeHNc=;
  b=QX0B71Ep+waEKMvPrq9gMptt1SMDkaPjHnutkOMRwuQCa4HOz3NjrTla
   slWQ+lrVNFwUTt5re3GZtt3dLUbYXeeT9s9+pHhC+iBx0SpqD+Bo4cclK
   p9xbhOOHr1ScknHlbOpcRA1B46IabnHC5UZLB9vKFmnR4C6nhaiPRMbcy
   E6LtYI3RFCoDjsGdJ+PUkgPXM6wowHeTqFg2lH4LMuYdiHMQWh1RSzAGB
   M5TXowSabbyS22eaFpFZRdhIW9XBO/5A4SF4wbfIo9tiIEyL5BGKmjwZ7
   u5dY57fF5kAtXXJtN0eWS0XA66OQ0fSJ3W2SWPKzsQNDYZN/M+D2cXXPi
   A==;
X-CSE-ConnectionGUID: 2eQPlpXwQKGqWY8lsHqxWA==
X-CSE-MsgGUID: 1XzokaYyTKeKuxNTm7Yzdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="88935131"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="88935131"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 06:03:23 -0700
X-CSE-ConnectionGUID: awyv3BgAS9SKIGpy3EHizA==
X-CSE-MsgGUID: cxMKTkLqSSWk4/Vvd51jmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="267647624"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.118])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 06:03:18 -0700
Date: Wed, 2 Sep 2026 16:03:15 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: bcrl@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, yi.zhang@huawei.com, sforshee@kernel.org,
	akpm@linux-foundation.org, pmladek@suse.com, rostedt@goodmis.org,
	linux@rasmusvillemoes.dk, senozhatsky@chromium.org, kees@kernel.org,
	tglx@kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 1/8] user_namespace: Use acquire/release for
 nr_extents synchronization
Message-ID: <apgek5EhgjxpDCkh@ashevche-desk.local>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-2-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902074805.398540-2-ruanjinjie@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Sep 02, 2026 at 03:47:58PM +0800, Jinjie Ruan wrote:
> Replace smp_wmb()/smp_rmb() with smp_store_release()/smp_load_acquire()
> when publishing and consuming `nr_extents`. This expresses the
> publish/subscribe pattern more clearly and allows architectures with
> native acquire/release instructions (e.g. arm64's STLR/LDAR) to avoid
> the cost of full one-way barriers (DMB ISHST/ISHLD).
> 
> No functional change intended.

Please, locate Cc list...

> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Seth Forshee <sforshee@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Aleksa Sarai <cyphar@cyphar.com>o

...(all the above)...

> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---

...somewhere here. It will have the same effect on the email thread and it will
unload the commit message from the unneeded noise.

> v2:
> - Add missing load replace in copy_mnt_idmap()
> ---
>  fs/mnt_idmapping.c      |  5 ++---
>  kernel/user_namespace.c | 24 +++++++++++++-----------
>  2 files changed, 15 insertions(+), 14 deletions(-)

...

This comment applies to the whole series.
Also note, `b4 trailers` can handle that, you can keep the

  ---
  Cc: ...

in the local Git. You can find some details in the subthread here
https://lore.kernel.org/lkml/20260123113708.416727-19-bigeasy@linutronix.de/

-- 
With Best Regards,
Andy Shevchenko


