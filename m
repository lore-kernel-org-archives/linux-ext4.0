Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4424D313E1B
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2026 14:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787927520; cv=none; b=nizM35kMnRitsVSBMJ1Q99cv4dZmeDpGwYRWGcXxqyLkfWLkmOz3AATYgw2TT0Roz7dwDXvx6DmkwD2PyVzxKihAIejQ1bLbePwjt+JWboIklcuxmWTpgLGvizxkMBVypJ2Njrn2sPBfxNoscb0Tks6gH7nRg1Guv7mOXlVcvBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787927520; c=relaxed/simple;
	bh=2wWBTRqAEHRJNjhrHLs+in0XswXeNDhXkuQ1UJ/qWC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2bkU2jQ96X7suYjvpCpEbPY1YNmprkFapR8Y/wrvBWs0O7FL+jbJ2GfpLN/OfH+LubQPgj86kKgriDVwHfFhAlRErYe/hgP/x+jnHFo+Gv1/RFarHJX976YQm4LW5pJLrB1IL3YN/ImVN+dl8gcXdpUcM2ATsncP4zAvaHnVrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=B1JWHNkO; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="B1JWHNkO"
Received: from macsyma.thunk.org (pool-173-48-113-140.bstnma.fios.verizon.net [173.48.113.140])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 67SEViYu018233
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 10:31:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1787927509; bh=mJP2KLoKkQipMvYGh8KVYewkzoQvaueRXWFP9eW+lcY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=B1JWHNkOhwBQmSdzJE7WWWWGAQUNODAVRO69ywSPtD6l2SVt2nAOZSeQcveEo0Z3r
	 ZXqdRGWDBzTwmt5BH6b6uGqH5lymbdYkutvqjUcQiROSIkN1ZNswZEKjCPmHrrRXxN
	 gCIi7HjuA9r37w0m9nj3W+9hlmnzMKWH4CJ7wdSeiyLCW9jGxadJI/46h20FpP/7CF
	 2R6S/R/E9F3wByyAe1rRg1afa3/ZDJiVzZRffGKL9bDHNp0nHu4jVLy08i5t1wv4xF
	 LrhHKoG9mLKxRopap554dDPo/vMsJZSQZAqur5SPNC1ml0VgG19TGD27IR8sykcIbe
	 bo7/tGckWuF8A==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 479CB12466A9; Fri, 28 Aug 2026 10:30:44 -0400 (EDT)
Date: Fri, 28 Aug 2026 10:30:44 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, falemi@asu.edu,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] WARNING in ext4_journalled_invalidate_folio
Message-ID: <apGbKdJiMx8nCfEl@mit.edu>
References: <CA+0ovCiKb8axo+R-RsqzGbUsrVE0AcLbHqy=+-c9oSMCAqL1fA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+0ovCiKb8axo+R-RsqzGbUsrVE0AcLbHqy=+-c9oSMCAqL1fA@mail.gmail.com>

On Thu, Aug 27, 2026 at 10:45:30PM -0500, Farhad Alemi wrote:
> Hello,
> 
> As part of the kernel research at ASU's SEFCOM
> lab, we hit the crash below. Crash reports can be found here:
> 
>   https://github.com/farhad-alemi/public_bug_reports/tree/main/172-warning-in-ext4-journalled-invalidate-folio/

Please send the reproducer.  Note that if it requries a maliciously
fuzzed file system, we consider this to be a minor bug (especially if
the maliciously file system would be fixed when the system
administrator runs fsck on the file system first), and not "security"
issue, so feel free to just send it to the list.

Cheers,

					- Ted
