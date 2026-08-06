Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADFC13957E
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786026972; cv=none; b=sny1JXVIffG12qzXeN6xTIaKqT/2vYxvawnaL5VkT27+5ozeABTK0XypbmItPNgVD1GeMECgmEBjaUuPBIiJpYUTpPaTfe0jQTpq4Py48S+zezQq/YPt/+jHv3rbLy8+4AJq3n/64Wvb5F7LUWUakkS+tLhPxTc0gur6CNH/Sbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786026972; c=relaxed/simple;
	bh=RaRSwaByGSRFW1E0tlhdWeb+n33xGpXCbbhP+zgvYMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQGw746lzZAttaDwkhdmthtLLl9H2j1t7hr9nbi2zjmtIOkPMDGwhyg9Fm/VCzQFh61KpJXCycCdB8wNyhYVYJvwmJ/FVzfBk9iSp1/l5cr0NLeCWXRFlgtR+fmSCMdUHlXmueb9820b0VRon5oc2ExHc0CgpVvCiz947+H5ceg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=NF7He6PR; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="NF7He6PR"
Received: from macsyma.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 676Ea5fr031378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 6 Aug 2026 10:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786026967; bh=g691WbjlkIEPLs+VFlr6m7oKMjjNbz7oJ8f0VMtAU74=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=NF7He6PR5r9io2H27Zcddj9OtGsMVkacZpa+SdWC0dEjaLpb7sw9vZTPm9a+KyGGg
	 5ne+6h6FJ8t5NzaRz58UAqTS+xKCPDqkB1HOCWvG4k9Hq1YCdfP1A/dhLtMxy1Ph4k
	 Ems+Nb3QLNULL/gKw9zTPleyjfuSSkGw2J9P2OdPKN4oClBarshiQstFkHzs2qXgHP
	 6uTkaH37KyuW5Esddwip+Ub0LJ9rjxJuooNbUL4Bj6mYCiZaUmRuBXz15aIBuNVfra
	 7AADs96/CiskgDpc9A7sOM3eN/U8NzvdM2m9710Bu+TRYkhnaWoBsZvFJaDRwmYe+X
	 4CTsIVLpCiz8w==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 0D5DEDBB0C8; Thu,  6 Aug 2026 10:35:05 -0400 (EDT)
Date: Thu, 6 Aug 2026 10:35:05 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Junzhe Yu <junzheyu1@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: guard against NULL s_group_info in
 ext4_get_group_info
Message-ID: <anSa1gy5xsHhtG-Y@mit.edu>
References: <65c955b0-716b-4599-b925-59c2782e38b4@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65c955b0-716b-4599-b925-59c2782e38b4@gmail.com>

On Tue, Aug 04, 2026 at 12:55:33PM -0500, Junzhe Yu wrote:
> Resend: previous attempt was rejected by vger for containing HTML.

This attempt still had a patch with mangled whitespace.  Trying to
send patches using gmail is... fraught.  Please a take a look at [1]
for future submissions, thanks.  This patch was simple enough that I
was able to apply it by hand.

[1] https://www.kernel.org/doc/html/latest/process/submitting-patches.html

						- Ted
