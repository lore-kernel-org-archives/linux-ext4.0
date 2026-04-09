Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F308B175A94;
	Thu,  9 Apr 2026 12:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775737495; cv=none; b=l9IXanOg6/1L3FYYoAsFegfXvgPuh1w2D9Bi8zBv89v81T6IcwA6NpCWhK4SjwkrK6hDeh5ekAEVKR9eVxDxrk4XriwomVMKReat4YpGTZ7HndSXma7ziAfdxlx5OJySZbA+eJ6NfyFxBhpHC78pOv3qkJRJCIx6HTIhwwrskuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775737495; c=relaxed/simple;
	bh=+1nL/5ruTLWXWmm1oZwROsAmjQKPkwhPsC9Nu9qN/dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tu73fHuLtQW1fe52dW8JMrxl/JCCtUzFUmTPnlDyq+6oixqFDv/rCoMurI4sKCWLsmcmK3MrDgGFxfyY1mZvJhivE7RuhwSnB3ICWw0pX4MbY4NzvRvN7cT4cSjMUw0Yy/2sZuNTar+bKZLBOYNA5LUI/ydt3zRMT4KAyfkStuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Or8EBxzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Or8EBxzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C7DC4CEF7;
	Thu,  9 Apr 2026 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775737494;
	bh=+1nL/5ruTLWXWmm1oZwROsAmjQKPkwhPsC9Nu9qN/dg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Or8EBxzrYN9MfDJbRvOtdt1enEsBiRhwf2xAmGCeGWnRbDgAjYyImwh4JZtV8/X4z
	 iCIhgIv/ATz1RUlDNVFXgBNAmPG6CjeP2vZA62UwGaFuXrldJBRg2nTR39TN0VocbN
	 /aaff+eUgpsF0JAaMsj+cJ7GYU4N+A1j+REfgSDn6pRjXrxOLDHTH8C/TLNFrHkefo
	 /4cVI/CE5qTfHfDV7QoAnlMEZoElWGRAt9aIYrXQWGiOhoZEhm6nkFXdHQi4e1/q8J
	 AR+IlbUocInVVkhp8YaAbRTjvEw5nihRwhidGTBGYI1TdNmLnYGpKXGNtRIbjz1vFp
	 kDLjIk95LJJWQ==
Date: Thu, 9 Apr 2026 13:24:41 +0100
From: Will Deacon <will@kernel.org>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Robin Murphy <robin.murphy@arm.com>, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, linux-ext4@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	dmaengine@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>
Subject: Re: BUG: net-next (7.0-rc6 based and later) fails to boot on Jetson
 Xavier NX
Message-ID: <adeaiSAnkaggqPsA@willie-the-truck>
References: <adZTGOjjJrVJOcT8@shell.armlinux.org.uk>
 <adZfTi3R6jtsjXx-@shell.armlinux.org.uk>
 <adZ9grUg71f518Fg@shell.armlinux.org.uk>
 <adZ_ZmjcE8S22vR1@shell.armlinux.org.uk>
 <3a1d0520-3402-47b2-9d7b-4e14a3cd07a4@arm.com>
 <adayAMR_dEA6W5vW@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adayAMR_dEA6W5vW@shell.armlinux.org.uk>

On Wed, Apr 08, 2026 at 08:52:32PM +0100, Russell King (Oracle) wrote:
> What's the status on the iommu fix? Is it merged into mainline yet?
> If it isn't already, that means net-next remains unbootable going
> into the merge window without manually carrying the fix locally.

I'll pick it up for 7.0 in the iommu tree.

Will
