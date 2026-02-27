Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217363469F8
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2026 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772210630; cv=none; b=k92f0h9VXZmLfV/V52lg4WjsPs0JsBM0WyMzuKeL9XtZQ6jIxp5G/vaqcGlCpFqyQgaB3umwp1NYEbDLTcB/0TzUY/zEHX1gxZ//uSzn7J+VT8eCZ+/MNai3Vxywp5dm5KT+GKcD7hQgBlHUyNUh1HRBy74txuOlScYGeaunXEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772210630; c=relaxed/simple;
	bh=bgEZ6B1UEy/zhpu8n+7s+DafgFxnCJvGv7PZtPNmF9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rCOKdKA6+9fOaA2iIx2bFqWx+1/fFndbFqgz5RIj2Dd4A83GDr18Mu2mmwTkuO8YxmsM+tTcAHLWduTTDiON9uhDizOGl9c2cOxQfG9t+o3DrHaPgCYnvHBkOQ8tpWaNYNRfkK5heijtafrxAVtQKA9/9GRcZzWTk5zfqY6FcJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=D0WHvJe6; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="D0WHvJe6"
Received: from macsyma.thunk.org (pool-173-48-112-142.bstnma.fios.verizon.net [173.48.112.142])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 61RGhJ2g018552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 11:43:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1772210602; bh=ojcxluCl677xf3TQxwcdPDiL7chtv+USYc/a0Xfg+2c=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=D0WHvJe6noO0P2vihKcQwOmvLodw5oJYzSE+QBqzreFNA0MrcoMFUmRV1v7HYQ7YQ
	 8VRVBUexRwOsGpeoL5nl7VU0dfJCdDzhi4nPn/ToOtOHDVeWHvmMtSrW/fl17luodM
	 BcVIAYlDVCZbrxeiP3rCuexPD27FmT+QygQUuL+3Jr0pfsRLxits9bH7UQwKaGjUWj
	 snCXSvrABwDEs9B9pSwfveLEzb57UdJy1qulY2XtpE7MJt9f4TEiILm5YOR7gbHWpe
	 JCP/XsTqyUONqwmRUDzv+8sLuu7GrzkKNlfQeOObmaCojX9ExrvTTgSQhp8il92mfX
	 aX5EqNaYHsXwA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 1ACDD5A2E380; Fri, 27 Feb 2026 11:43:19 -0500 (EST)
Date: Fri, 27 Feb 2026 11:43:19 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Mario Lohajner <mario_lohajner@rocketmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, libaokun1@huawei.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, yangerkun@huawei.com,
        libaokun9@gmail.com
Subject: Re: [PATCH] ext4: rralloc - (former rotalloc) improved round-robin
 allocation policy
Message-ID: <20260227164319.GB93969@macsyma-wired.lan>
References: <20260225201520.220071-1-mario_lohajner.ref@rocketmail.com>
 <20260225201520.220071-1-mario_lohajner@rocketmail.com>
 <D135BB30-388D-4B4F-9E09-211F6DA74FCA@dilger.ca>
 <20260226024819.GA39209@macsyma-wired.lan>
 <04dfeda0-8c13-4233-b631-d8912d4fe6f0@rocketmail.com>
 <20260227011200.GA68551@macsyma-wired.lan>
 <2af6328d-5a72-476d-9768-9398a9417ea6@rocketmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2af6328d-5a72-476d-9768-9398a9417ea6@rocketmail.com>

On Fri, Feb 27, 2026 at 03:46:59PM +0100, Mario Lohajner wrote:
> 
> Concentrated allocation can create contention, write amplification, and
> uneven LBA utilization even on modern NVMe/SSD devices.

Uneven LBA utilization is the thing where I'm asking, "why should we care".

In terms of how this would cause contention and write amplification,
<<citation needed>>.  What is your benchmarks where you can
demonstrate this, and how common is this across NVMe/SSD devices?
That is, if it's just one trashy product, maybe it should just be
avoided --- especially if it has other problems.

						- Ted
