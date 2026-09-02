Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F3748663D;
	Wed,  2 Sep 2026 13:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788354308; cv=none; b=pwk76g/Wwi/CVKHrhBpbGvOSrtyZyFxgku7XImbSATJf2jeV+eKCQpjKvKzW15/2/jlpLSf9ZLZG/elIuxsBA4MPzZfBIf27/fvDMbFcXIMcFLeu7HHIqZGV/7NMQ08DwENzKqNd4jHaLmU1wxPOqQtWyXARg47QUDn4PU7euuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788354308; c=relaxed/simple;
	bh=nuGiQpVdQXM62iqN7zRrQ1PDjyq0FozVNQtWBQVuEoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttz7meYz2IvxLFO5+S1odwvgwKkoeR5g9dRpMeJyeF2ca6xJBa95zWpqhIcoNhoTP6LiYQRpxBWWfdolhkMX8UIqKDa37DlNvwMdO0UOCaNvlbMiJMIEx0enx9uXP3599JjRnN4qchOhk+PKo/04ODlrI+1t3ONVebS/+JLwGkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RI9XTGbG; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RI9XTGbG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788354307; x=1819890307;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nuGiQpVdQXM62iqN7zRrQ1PDjyq0FozVNQtWBQVuEoU=;
  b=RI9XTGbGl2UhS1hUpqpVE744r12j/2PdT9uClFlGseOKiqwa2YG1ACvO
   qpkWq8mBohZ3IZwbUzxy+/85KaiP61xVfotKeNx8606BnfL0KiBswR8gS
   zwatYLfV4AOFVd8A480zIG44PgAfaijeBReS2PxhAk+VyfdnVVZQkM0y1
   mkLoVAzsIMxyqcKk70KximoKQEdcpmJcdAqpeCljXrrPVtca2JCjVIegM
   XnojAqxq1jZWi+O25ghJAurUd36fpHLTgUOFUrP95Mq5kS3O8Mb81tkPy
   5CSUwoNe7moOZuacz8Az3RRabfm/tdAX3Ca09Az68hQx8FBDpKYdznCJo
   w==;
X-CSE-ConnectionGUID: +JdhoEllTw6myc8hRQIsNQ==
X-CSE-MsgGUID: fq51iaPMTpuvye66tJL9LA==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="88858096"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="88858096"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 06:05:06 -0700
X-CSE-ConnectionGUID: f4YbeFikTwSzmAXirWXbjg==
X-CSE-MsgGUID: yRpphcw+T5yDxdF2uEC8wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="307617041"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.118])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 06:05:01 -0700
Date: Wed, 2 Sep 2026 16:04:58 +0300
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
Message-ID: <apge-t-tp00Tl9TL@ashevche-desk.local>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-2-ruanjinjie@huawei.com>
 <apgek5EhgjxpDCkh@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apgek5EhgjxpDCkh@ashevche-desk.local>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Sep 02, 2026 at 04:03:23PM +0300, Andy Shevchenko wrote:
> On Wed, Sep 02, 2026 at 03:47:58PM +0800, Jinjie Ruan wrote:
> > Replace smp_wmb()/smp_rmb() with smp_store_release()/smp_load_acquire()
> > when publishing and consuming `nr_extents`. This expresses the
> > publish/subscribe pattern more clearly and allows architectures with
> > native acquire/release instructions (e.g. arm64's STLR/LDAR) to avoid
> > the cost of full one-way barriers (DMB ISHST/ISHLD).
> > 
> > No functional change intended.
> 
> Please, locate Cc list...
> 
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Seth Forshee <sforshee@kernel.org>
> > Cc: Kees Cook <kees@kernel.org>
> > Cc: Aleksa Sarai <cyphar@cyphar.com>o
> 
> ...(all the above)...

Important remark: this is only about Cc, the regular tags have to be
in the commit message trailers (such as Reviewed-by).

> > Assisted-by: DeepSeek:DeepSeek-V3
> > Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> > ---
> 
> ...somewhere here. It will have the same effect on the email thread and it will
> unload the commit message from the unneeded noise.
> 
> > v2:
> > - Add missing load replace in copy_mnt_idmap()
> > ---
> >  fs/mnt_idmapping.c      |  5 ++---
> >  kernel/user_namespace.c | 24 +++++++++++++-----------
> >  2 files changed, 15 insertions(+), 14 deletions(-)
> 
> ...
> 
> This comment applies to the whole series.
> Also note, `b4 trailers` can handle that, you can keep the
> 
>   ---
>   Cc: ...
> 
> in the local Git. You can find some details in the subthread here
> https://lore.kernel.org/lkml/20260123113708.416727-19-bigeasy@linutronix.de/

-- 
With Best Regards,
Andy Shevchenko


