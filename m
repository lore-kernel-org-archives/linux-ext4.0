Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D95345ED8
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 23:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791676492; cv=none; b=tCH/tBYsukFIS0e64DpeiTuuyrT75f3T0MlHwLKoI5SfP/MmcRbI71y/btX+c8N4aT2ZBMBBpT8SdlDHD9xMvLh6QFn99iYwy7PaOnmz+Wp1RgvglrjaV6HPIiykI3O+Q4TEx7ZMWcanRaIWU3jrDXDaRoQqhvOyfqwVKSzOTL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791676492; c=relaxed/simple;
	bh=lLtabEDEGxAL/BzvBgmfjZNheScSv38qKOCUUBaLOss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hAgDUM0jj32Um9hboa5EBOv730c+ehdQggRU0XRlBeTSAgAh93jQcqIc8LtdPsYobZj6EDM4tdQA6tUdEw6ZAorc2F2CppklZS6SHsG+PX2+J6wKO7pGv+wJk9Pak9Pg2voM+u4F6KypFsFNk2co4mhwUUfbz+klYl4gReKEw9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=gQRHIT2l; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="gQRHIT2l"
Received: from macsyma.thunk.org (pool-173-48-111-204.bstnma.fios.verizon.net [173.48.111.204])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69ANsEpK023589
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 10 Oct 2026 19:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791676458; bh=eMDw1C/diPMVZVZb/XGNTeaHo/sKKU3IqDRt++QQmts=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=gQRHIT2lmmMIlzdRzeOKdVg2gg3y9q1zquDOJ3bQzh4/srAaNC+1/81KO2hL1kabC
	 /MUrqldHiMkTQk+rNbNKEbPCof8GC3AQjnuHDHvFwJeXOY3PnM70/0WxkmF/BTTZ3w
	 SEyUMVJdUkuxv7k/Lo7Q8RsUXGyJq0o/DSn6ea7X6OvFW/LKYZOBiQvkN3ZNmzsf+K
	 3yFp9dvo40rnxXhjHSPrEtSSKyk2debMHaLVKWaDlEv9eZZv5k89PGcfBvIJYfBAO5
	 wbXeKC4ncKlri4Lm0/mzZGe4sJug7QPPFoE+Z83sfRvasQxlvaMlPXUFxNhJtbVOFF
	 L8HofkhzP3ngw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 8D8A81FCDFA2; Sat, 10 Oct 2026 19:53:14 -0400 (EDT)
Date: Sat, 10 Oct 2026 19:53:14 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Artem Dinaburg <artem@trailofbits.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Max Kellermann <max.kellermann@ionos.com>,
        Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.6.y 0/2] jbd2: backport CVE-2026-89566, CVE-2026-89567
Message-ID: <asrNX2qBf5qBrFLu@mit.edu>
References: <20261008192048.98833-1-artem@trailofbits.com>
 <askqkXhBORyXr-v9@mit.edu>
 <CAP3zxaC92rwQNCpuK_tXR9THQOecVoZwxg8ZUgYt=0iKiMsuxg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP3zxaC92rwQNCpuK_tXR9THQOecVoZwxg8ZUgYt=0iKiMsuxg@mail.gmail.com>

On Sat, Oct 10, 2026 at 06:12:10PM -0500, Artem Dinaburg wrote:
> 
> Our initial unpatched/patched runs showed some differences in both
> directions. We cannot yet attribute those to the series, so we have
> paused the patched comparison and are running three complete
> iterations on the same unpatched baseline to assess repeatability.

Note that some tests can be flaky.  So when you see a test failure, it
can be useful to run a test multiple times, so you can see if the test
is a reliable hard failure, or one that only fails, say, 30% of the
time.  So to run generic/363 10 times in the ext4/1k configuration,
you might do soemthing like this:

   kvm-xfstests -c ext4/1k generic/363 -C 10

						- Ted
						
