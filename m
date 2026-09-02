Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80BC4A260C
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 14:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358868; cv=none; b=tp5eEghecc4Nwrbn+qVyRRZWu23zI29WUPAsiN8WyKK6M4OrzPPpsSWLl0ogKM1gryGS7wUv9tYuldphfvJIp78y5K/8YUXxtxZ1wGk3GhxMVr9dyE6/N96QxK6oUEnhIVQ4EcdAo09sgd363+IouaJjrTPw0cENBAagFtiQ+x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358868; c=relaxed/simple;
	bh=3MOYxwMzlHt/wAS98xOaW93eYgl1ZjXCZls3cxrkxKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XXBvr/BxxK50+Mz/VieIRbRvkOBekNQJ0hc04y/GqFq6s6i/disnB0vACMPpbdAcy5N/cuAsnluiJQTrs+YVT+nDtAfIo+f5wlNNOjQEa0D1Gxsgs8OXuUqKkDCQT/pBwMJoNJTB77NFcjx0svt2GB9GjW89YqJd+sd7OOkg+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=qQpMgolg; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="qQpMgolg"
Received: from macsyma.thunk.org ([104.135.218.91])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 682EJkAM024468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 2 Sep 2026 10:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1788358793; bh=3QZBcT9wMwB3DyyvNgzIH17ppYtiwXKFjAiGoY+z9LE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=qQpMgolgCUEX8Vy7dpklGPyP3D7ZH4XJxWG+IVL6GmAncA+fMUvlm8YnwWtmQT4dV
	 TV9xNSQLEiw2NsioLZWQNqIRjUaFdx4FkN96CtCFgnv1VI2miScdfKdhGDj/XYPEJa
	 89kDgAOAhkPR50vdBA5jvYy42oI9bqI0DpnbVD8H1fyL8TmyJa1Lcu4iwVSA3mIivh
	 05bfOjBwXogJdQq/4XtnxHmehk09J7a4x3UQ2GVQZPGwBTgNCq2+S5Xxc/80jok7PR
	 QBPPjskGdk0Yhhhk3LmC7+fTAL6Y10SPcrHFxdTtzrS6pxi4SBqrd568e9HWlNIE81
	 mUto6Jn7D+bpw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 5A6F212FC3EA; Wed,  2 Sep 2026 10:19:46 -0400 (EDT)
Date: Wed, 2 Sep 2026 10:19:46 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: bcrl@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
        adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        sforshee@kernel.org, akpm@linux-foundation.org, pmladek@suse.com,
        rostedt@goodmis.org, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, senozhatsky@chromium.org, kees@kernel.org,
        tglx@kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 0/8] Convert barrier pairs to acquire/release for
 better performance
Message-ID: <apgv5w116frzutwH@mit.edu>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902074805.398540-1-ruanjinjie@huawei.com>

On Wed, Sep 02, 2026 at 03:47:57PM -0500, Jinjie Ruan wrote:
> 
> This series converts some existing smp_wmb()/smp_rmb() barrier pairs to
> smp_store_release()/smp_load_acquire() across various subsystems.

I would like to land the ext4 related patches through the ext4 tree,
so please detach them from this patch series.  That's because I want
to be able to monitor the regression testing before sending a pull
request to Linus.

More generally, I think we should be looking at this kind of barrier
conversion on a per site basis.  If there is a bug that isn't notice,
it can result in a very hard to debug problem.  And if the benefit of
speeding up a particular code path isn't particularly that great,
maybe the cost vs benefit vs risk calculation might cause us to decide
to take a pass on the change.

Cheers,

					- Ted
