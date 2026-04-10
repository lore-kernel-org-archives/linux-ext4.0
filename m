Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8C9315D50
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775783944; cv=none; b=fTPni1UBHdCZ8ubpf+YGP6IYKmE+EQfgB+yMae+Pe6AL/OBxsulOIlZbqL0ABtCY2Aoa5UIpPVnP4GmeY9XudYpex8HhwynB4ByL9CXuXg1yoqLSmd1F3gesDdjtxBe+m93oiyI2/wNsG+uP250QC39woJlOwz0evD2VsPeZNj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775783944; c=relaxed/simple;
	bh=JHT5fHED+RNfSNkBCsKJYEWjBPITIG6/eDgn4xajX8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VBeBKS5OUcyOmm3iDckdN4KTlfWL37iEL+tkvFfl4Ar7taDud4kMyCxSfx2fXFkCySagjtNrWdA2Tig86nk01rRwwr+xb5yc4VD8Cs5hKEnQmmVhhtm+eMqPLbGKQFPklG6YlVBoXH6kI7NkR0mJzsvbBrzzvcGSCYNlbimzTg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=LmCP2O2I; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="LmCP2O2I"
Received: from macsyma.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63A1Iheq013479
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 9 Apr 2026 21:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775783926; bh=3YBV0vZ4W8UlqgCo56mF/1Rz8B4mWIam+oveebrWqc8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=LmCP2O2IdCCJhFUey7WJkY6ZlFgQ+AMfWuVVeP2xe2shw/HuOjkv1XHWSlyMk3QmH
	 qlX5aRkJIqeflRWbh5jA/Mf/SnGMbitBQLHQr3RhC1qnDj8CopCQ8f9mrUCLvaNh9w
	 DMWyIP4Tc05aHrHZYeoG0GA8G0LvmogeGaKEUVlWUEas6t+OisNS0l4hCpHmYHmAVa
	 IIzSa+ZE+8F3zGuRN2yrP6TEpb6LSJfx8xMwER6SAdvD/M1kX6cabl6M4O5O+7meFj
	 vc9ODrQ4SXM6/kNPj19WEcBOde+P68PKBzUiaJTFbqFrfBJiWtLBdeolVH+NvS/nWp
	 6rZVsaaVzetUA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 59EF66271A52; Thu,  9 Apr 2026 21:18:43 -0400 (EDT)
Date: Thu, 9 Apr 2026 21:18:43 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Li Chen <me@linux.beauty>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-ext4@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v4 0/7] ext4: fast commit: snapshot inode state for FC log
Message-ID: <20260410011843.GD99725@macsyma-wired.lan>
References: <20260120112538.132774-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120112538.132774-1-me@linux.beauty>

On Tue, Jan 20, 2026 at 07:25:29PM +0800, Li Chen wrote:
> Hi,
> 
> (This RFC v4 series is based on linux-next tag next-20260106, plus the
> prerequisite patch "ext4: fast commit: make s_fc_lock reclaim-safe" posted at:
> https://lore.kernel.org/all/20260106120621.440126-1-me@linux.beauty/)

Can you take a look at the Sashiko reviews here:

    https://sashiko.dev/#/patchset/20260408112020.716706-1-me%40linux.beauty

There seems to be at least one legitimate concern, which is the
potential cur_lblk overflow.  There are a couple of others which I
think is real; could you please look at their review comments?

Thanks,

					- Ted
