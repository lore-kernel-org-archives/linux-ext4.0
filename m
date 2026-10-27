Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793113701;
	b=bsJPYcgUVmcSgzvGzNsfPqYS/lAGDkgesfMh3yQ+qLeEfdc0sK5MJp6rdh5+p4kvkuZV
	 KDQbuUu6EuQafR6fWhVW8p7/d5foFUfIy6nBxWUbI2iaQrLn6nGRygQk2vVnpOjFhr2xm
	 Dzt1uo84SYVPCROwXaNvipXf39MJgmfv5TamtpG0bT3L1nNG1EJ5cJ2ct8oz+TFwDM1oN
	 ZXivl42b09ShRYo8zKcBjgPRFhdRggXcWm3UQkuzFwUS4P3x01fM3T0eprurAsyqDRFni
	 MAnXp8YPb4Maime9zr8I8XrkZyWUwWDvftJ0U3vaYykhZyaWcYyMY833aMASPTdHFag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113701;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=uEW0LYQSbriBnkVrOo0oJQirTzn9x1v3XJIv9ij5psZYsdoo2SQz9zVvlHUKkFQvMKd7
	 Cg49p/Q4d6KqWlbT81jBZtwZdK8R1r+/YN53hhbKPbjrPPLMv1RXDWYui0vpUOver3D3S
	 l47/NEFSukQlajWmxyXyu01B3sUMO+rz4EVx0NOVtq74WOtUdpo7M4jqQIj4E8qtN1Bty
	 jMGK363UEnK5CfN/nsMTZop1iXW/fp9xF2rWzQm61d+TYQ/j4/UFoDacyY1zlVC6OpB1H
	 lWTnEI7dDV1Q0l/mEsDwnon97MMJLG/1NnN7Olv9GiV06vwPJViDAx3z7nHxAaN74Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B7D606A31B;
	Tue, 27 Oct 2026 15:08:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4B7D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4991F68C7B; Tue, 27 Oct 2026 16:08:11 +0100 (CET)
Date: Tue, 27 Oct 2026 16:08:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fsverity@lists.linux.dev, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	stable@vger.kernel.org
Subject: Re: [PATCH] fsverity: Set S_VERITY only after rollback is no
 longer possible
Message-ID: <20261027150811.GC14436@lst.de>
References: <20261025204807.122875-1-ebiggers@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025204807.122875-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

