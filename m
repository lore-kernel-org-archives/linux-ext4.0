Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74503DDDB4
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834341; cv=none; b=iCMSULx/sJuj9WM1BucLIXgVVfUNv1IYZmigiZiP/sw/0OggKARfs81sLX6fEILV0xv0lE8HeFyQrRj5zj5L5ASQlNS2JasNFXLD4g5d3nK0/4WqrPvkZkeaSSXIKvAG2SpRFvk8mfYyD0TzLrK+9lyNkZwKKl5Ro3ofQQUkeJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834341; c=relaxed/simple;
	bh=RxpvA3eh9SHzgt4/2lh3Inm/8L4wRVYBA0eII59VMSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OrRokUlM0KZ3qBwAdOUx7aX8i/isEOKHgAJu+WG55Y+F0aJlHusAUn/2O/tfir2TzrIExB/j9yWRYx2KnapE/kvRhb6imTeiuJTDi3S1Rsb7XZZxc8vBeUVxwg5g9zXrV9uwzsvLn8H6dr3oxldbgqnDMvYKXOZ2AfIF2kTz29E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=LyUOJVZs; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="LyUOJVZs"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFImgN015769
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834330; bh=OY6G15C9EgyOfaVMAdim+tczgIT2XZ6nQM0Fntgveyc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=LyUOJVZs8BaMuQinHijvZ1RHGXBxgfwVz47W7x4TAX820fc8LmDtCGXwjNrEDvOPT
	 aH6gJJbBgO2dee8/VC23R4CaVt1E8xjO3w3BZckVlokpqHmCEub5/soycXjKnoZUyw
	 nOFNSxGsQsPcVZNOT/Lald5fw9VQ+2o4N0OI6hiOYTOcop4Y8hzuWrU+ZvW26s4FbJ
	 hZou7VzIDgsrvFI9AtMYKKMpnoTLmdV34yW1YN03T7BhwBNearJhgE20RmnQLhQ55m
	 o6kgd2YecXWlc/hzbtcQ4iDw/uw+h4Y34LGmFD8Iqt5tt6aU5b+Tzdan3b74b/hg/l
	 d6fLmdggHQu4Q==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id EED782E00DB; Fri, 10 Apr 2026 11:18:47 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ext4: fix bounds check in check_xattrs() to prevent out-of-bounds access
Date: Fri, 10 Apr 2026 11:18:34 -0400
Message-ID: <177583430878.2758959.10038208065851589867.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260328150038.349497-1-kartikey406@gmail.com>
References: <20260328150038.349497-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Sat, 28 Mar 2026 20:30:38 +0530, Deepanshu Kartikey wrote:
> The bounds check for the next xattr entry in check_xattrs() uses
> (void *)next >= end, which allows next to point within sizeof(u32)
> bytes of end. On the next loop iteration, IS_LAST_ENTRY() reads 4
> bytes via *(__u32 *)(entry), which can overrun the valid xattr region.
> 
> For example, if next lands at end - 1, the check passes since
> next < end, but IS_LAST_ENTRY() reads 4 bytes starting at end - 1,
> accessing 3 bytes beyond the valid region.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix bounds check in check_xattrs() to prevent out-of-bounds access
      commit: eceafc31ea7b42c984ece10d79d505c0bb6615d5

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
