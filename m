Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D9727C162
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 19:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791572643; cv=none; b=UdxW9/M7aA1va3ysG3W7QNKhrEyurIlolrqRsSqU5iVlVWRlnIYYht1ySgcF+Usslk6Gen6KGe3YrWUP1i2uyRgI5lWCjLnymxL/gX/KEufnLM1EAl5MV99l1+RIXuvZrqjtm8KC8WvUFJP/Peaz4NsYdm9IMJXU+XAclxpGdmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791572643; c=relaxed/simple;
	bh=VoT/TewX7ILg1FNeG8ESEgdbpxTY/afUPypxYW5Hx9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QAuqQU1+E/JB4JuPo7oHtqF6MlyqsnCWJIC96zEZ07sZEaoLi/0oMaDCp+ikTMppISl7Idp5FnUiezJVXh8TQ1uOF/n/s0EK3VmiARUlSfqRi1Emb0Tspl2kRZLmU/F9wuZGi77eCHsJ474SmUx1ZDF2nDK9aA2GSSFx7ASzNvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=ZVhZ1Frl; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="ZVhZ1Frl"
Received: from macsyma.thunk.org (99-196-133-108.cust.exede.net [99.196.133.108] (may be forged))
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 699J3OCX018268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 15:03:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791572621; bh=4NBQe6SoFt7hS7NEi6euioamMHaacydLv3Db8C3tsXY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=ZVhZ1FrlGmhFgEvBaFBF90oI+WBxat0Le5ZLxMsp3RL7Ots2PyT103MJ8RMQlz5fe
	 wQmm/nfykRbADSfk5E/Gopof+SJAbIgbobzSZxTNy3V1hfPa1UvA7StD5lWkiaUzJM
	 o7n10q8ohyN2fun7viLGDfJEkP0rYsVV1ZET9/Aizgi/TBBOQ2S6LH8FnxnDFasQLb
	 YQPrOdxOqtltWfYP4DQAzPXVOkEnQDn1aB/F+TUsmIFatoue2rxxcurctcg6JMh2It
	 JjPlLKdMUdDck7mcVgNi11W4aJHNIPkCV36Iz8yM6d6+CsjUOxleYQzQM6SkoRS4dC
	 j9l1ZFMU0S9nA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 82E301FABF6C; Fri,  9 Oct 2026 15:03:20 -0400 (EDT)
Date: Fri, 9 Oct 2026 15:03:20 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Zhang Yi <yizhang089@gmail.com>
Cc: kernel test robot <lkp@intel.com>, Zhang Yi <yi.zhang@huawei.com>,
        oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [tytso-ext4:dev 21/41] fs/ext4/inode.c:4002:24: sparse: sparse:
 symbol 'ext4_iomap_buffered_read_ops' was not declared. Should it be static?
Message-ID: <ask6HB-62-bUBb7u@mit.edu>
References: <202610082225.lcsAyIiF-lkp@intel.com>
 <5bac3071-5823-4714-8c39-662b91c927a3@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bac3071-5823-4714-8c39-662b91c927a3@gmail.com>

On Fri, Oct 09, 2026 at 10:55:18AM -0500, Zhang Yi wrote:
> Hi Ted, would it be okay to replace the current version with my v7 on
> ext4 dev branch after I send it out?

Sure, no problem.  I took a quick look and it looks like there were
one or two new Sashiko issues?  I'll give time for folks to take a
look, and I'll rerun my tests on the v7 patch series, so I might not
pull it in right away.

						- Ted
