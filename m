Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F29219F11B
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 15:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779982633; cv=none; b=pZ4aiesbXhm1BPJHXcyclrAq6DtN68oK2eILVCS+5i7HwofyDpdAOIDy1YhL6eXhQCsbY1MrSdcVky+UF2s0wGEK8T7kTekWUh0gmvKtKdkmge+C54xAquhNDaYJtaALFYLuG1MaHn3sFAxJmNyLJTb7OVXUegAwDKNUdii3+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779982633; c=relaxed/simple;
	bh=NftFE2JtbNjI/YCmi6LTOBt8TBhJcI4X+lbsIBRp6R0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjn5ha6LCuAmc7qqGF8H5f1ui/48b58XHTd/K7oI1UhVZjNN63GZ3ARLnShA6cZ6TbQFlXjjEVW744W4rioieiNgRmJBexHkwWOngjwt1SnOj/5WoN2A4V5C6B38GGQu+lMawU9igiTX909zuFiVPYETy/ryhVPjqPsl8O8BGeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=dZNPpuKv; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="dZNPpuKv"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64SFaoGe005093
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 11:36:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1779982617; bh=TZP9Bw72ZXDcE3HLjqomxWwAgWZts+W2FqVr4QLSYkw=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=dZNPpuKvaLChaKmueTnmQ6G8mucA3VRMAOh4nmlQ/bPjVJo79ZKpQQznPIFhgtzau
	 OQgmjOGfnY8XV2+c+vkiG/tCsbX2ozJxIJr+c8UcjM1dXir02JwEnJbltONKkde0qh
	 /0wKGIQJDFIp5gSU7vMpn8lgfUPX79oPfTc2/PZ83fgB2Ud5tkj91LIJlwpfJ03AYa
	 ggfFZmwD1bJjSTbC1U+cTgQw2nD1qODgMy6R/yrJtsAcotJCw5dGkqn2Pxuj8jwpG1
	 v5tuCMCw3aLapGw7kDk42IQQm9uJPcXR249dnZC5BdcI0aK9XAz4icoMadLIE6mNw1
	 6EFN54ga6AXYQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A59336B6C80C; Thu, 28 May 2026 10:36:49 -0500 (CDT)
Date: Thu, 28 May 2026 10:36:49 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 16/34] jbd2: Convert journal commit to bh_submit()
Message-ID: <5plxqx6kdm5nkp65bjfrfy5z52v536ajonph2oegfm6wcmaw4p@hpd7ijpv4yxk>
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-17-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525171931.4144395-17-willy@infradead.org>

On Mon, May 25, 2026 at 06:19:09PM +0100, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by using bh_submit()
> instead of submit_bh() in journal_submit_commit_record()
> and jbd2_journal_commit_transaction().  These both use
> journal_end_buffer_io_sync(), so it's more straightforward to do them
> both at once.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-ext4@vger.kernel.org

Acked-by: Theodore Ts'o <tytso@mit.edu>
