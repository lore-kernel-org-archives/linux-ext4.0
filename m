Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A92371D0B
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 12:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775221041; cv=none; b=DLU5/Q5cr5HpLeiqOj59dgeMmtUxMHTpweVJeuFj02hTrqEuwThEoOPKm1veRcLC3zSWJwnn5QL64r+5lx0yrlMndNln9kVT1uz/AIM/y9nWQTwYRqVyzhYn/ZvKj4j4O4nfTDl7WcaX3TvkrxKo+Nivhwi52OrQ3bRi+drEUo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775221041; c=relaxed/simple;
	bh=iP8tlsZT0oQYcykLZdFUTmr3rwnq4htG6uiAafEkc4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/EXjvTssOadnEeife7bYVtHeN87xCCnMni/4hI1TRNuMCK5Mr46Srteo0GblcMuc/V+fmC3CGG8zq3FJwZwpwHjeJ/6QC7Uw/IimxQehrb4OdiODOdSKK5xarId/IX9BYXvetNPK5Fe3Z6koyMeQX3EecJcYYG9kG3TgJiz/dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=RYC4Z/L+; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="RYC4Z/L+"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 633Cuxnx028499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 08:57:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775221023; bh=ABSQoXdacPFvwlcLQgd966o92a7VJQx5GHpFilRME48=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=RYC4Z/L+2xt82rnWBbFpmKY+S8oqAI387X3jsKyI5hdNm+CdAYpHQbv3zROnFwXJ3
	 J2QibkGmdTsrxkR0PnphoZsGfLtUNPWwqkVQDjvj6oBC/8iFxt2ppT2LcdnBCMAzEZ
	 pdeCsEw+PUwu848YcFjAQmUJ0NzVXNt8fHkBs/ArI3jr9vbsAyWuPzdN2Aa/zR6iIU
	 XqRhDiNk8FrKQ0HlNjR5LlL76Mlh0X5R3mq28/PneQCX6Nf7f66efLmRKRMk7eNyx1
	 oyQbRmXrpWB3krH//EqDT/8nNilAYyPVlW4du9C8072biy3U+2ixPXVdQoLp/N91ew
	 8j7EeUpdWA0/Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 6AFF4610121C; Fri,  3 Apr 2026 08:55:59 -0400 (EDT)
Date: Fri, 3 Apr 2026 08:55:59 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Ye Bin <yebin@huaweicloud.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH 1/3] ext4: register 'orphan_list' procfs
Message-ID: <20260403125559.GC12260@macsyma-wired.lan>
References: <20260403082507.1882703-1-yebin@huaweicloud.com>
 <20260403082507.1882703-2-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403082507.1882703-2-yebin@huaweicloud.com>

On Fri, Apr 03, 2026 at 04:25:05PM +0800, Ye Bin wrote:
> +		proc_create_data("orphan_list", 0444, sbi->s_proc,
> +				 &ext4_orphan_proc_ops, sb);

This should really be mode 0400, especially once the file path is made
available, since otherwise the kernel might end up leaking private
user's information.  Even in a data center use case, in a multi-user
container use case (Docker, Kubernetes, etc.) leaking information
about one user's file names could be a real problem.

      	  	      	    	     - Ted
