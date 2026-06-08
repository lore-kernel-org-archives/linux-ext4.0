Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11651296BCC
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 12:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780923383; cv=none; b=IX6rOsFxe+y4j0rAVc0WllEGmH5DsnIUT21S93gBZf61WF7sY4uQJ5uQIGf7QZMeQuNi0IH1EJUBLHNTHbSIraM4VvIYe9tlm9IdgFPggAhGvIPxXa+JZzt5b2QDLnQuVVe78l80o8YlyS72yrdctLBLR7Lql6G29MobDBPA9/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780923383; c=relaxed/simple;
	bh=raRms3Uz4P+ZGsMhZvPi/mx8pP0+LXnyaI5/NjF4Jqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alrBjCQboWQWTaf3bcs8U0x3Yqhe2No8PKDwgw5LZGzFe0cWWp7348sAlYpg9vfUgSun5ppopQVfhIb6m834SGLc/iVqPLrbwJOuwSMbpieypKBnKr2/FenQ4LU+Lh+qa0H1dkxhtzJNRsyAIK4vhVZFmQfNaX7jWvFR6t4CcaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=ZvE4a78D; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="ZvE4a78D"
Received: from macsyma.thunk.org (pool-173-48-114-243.bstnma.fios.verizon.net [173.48.114.243])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 658Ctp5x032249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 8 Jun 2026 08:55:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780923353; bh=2skHyqe9UZfkiqcrlo0/zRibYCQ7FiOdicerJqM5eUE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=ZvE4a78DcNoiPXEhGOiKGUlP1pbnevmugg75Aw7LvjTV332nuRddSn0HwQjHejfxK
	 vn3idvnSkieamzxPIYTYMzuuYLnnySS36xEWzGVHw591ZeH3nfhYkawWxX05lv6AtM
	 tHL6x1L/pXaqbl1yFgBxpMkmH5r+1l9hOOsBONrTCH2NXyqIwhVMIhUmniIfzVZts2
	 sRkbJD9w0O2ufoZXGxaXHS3vC5Z1mRJmN+0uhPDu9GHYmLtNoQQSUv5xsJwCj9jGgW
	 FTXpKgqckwd0bhYFpYXqnyypiCU0E4xRUvruidtMp0m/HdP0OxHAHWDp4G+OT0KCTa
	 l2MWHpWkUdsUQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 4A43A3F9E1E; Mon,  8 Jun 2026 08:54:51 -0400 (EDT)
Date: Mon, 8 Jun 2026 08:54:51 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Feng Xue <feng.xue@outlook.com>
Cc: Andreas Dilger <adilger@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: security bug reporting: e2fsprogs: Path Traversal and heap
 overflow
Message-ID: <uzwt2qkkiwa4tzb3wkvx2fgguptmno5wbqmglay5znqvus2qtr@ggkveweeirpa>
References: <SY0P300MB0070F750CCF6F2C3A2A91FDE901F2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
 <9237265C-CB9C-48BD-A77E-25AE61DA8550@dilger.ca>
 <SY0P300MB0070B3B68E4E4FC0C78DE355901C2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SY0P300MB0070B3B68E4E4FC0C78DE355901C2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>

On Mon, Jun 08, 2026 at 10:18:38AM +0000, Feng Xue wrote:
> Hi Andres,
> 
> Thanks for the quick turn around.
> Agree with you on the inode one.

Anreas, thanks for the the patch.  I had reviewed Feng's security
report and my assessment had aligned with yours.  I had it on my todo
list, along with a mental note to make sure that this particular
corrupted file system would be caught by the kernel's fs/ext4/super.c.

> For the debugfs, yes it is not what people would run on a daily
> basis. it turns interesting in scenarios like incident response and
> forensic, so yes it depends on the ROI and definitely your call to
> whether it should be fixed.

The debugfs concern (as well as another related one) has already been
reported on github[1][2].

[1] https://github.com/tytso/e2fsprogs/issues/272
[2] https://github.com/tytso/e2fsprogs/issues/273

It "should" be fixed, but I'm quite busy these days, and part of it is
many kernel developers needing to react to the large number of
LLM-reported security bugs[3][4][5].  And so we have to prioritize the
order in which we address security or other bug fix reports.

[3] https://lwn.net/Articles/1063303/
[4] https://www.tomshardware.com/software/linux/linus-torvalds-says-ai-bug-reports-have-made-the-linux-security-mailing-list-almost-entirely-unmanageable
[5] https://medium.com/@tridge60/rsync-and-outrage-d9849599e5a0

I do appreciate that your report included a suggested fix.  The thing
that would make it even *more* useful (and gain you an a win of a
patch landed in e2fsprogs or the Linux kernel :-) would be if the
report came with an formal patch submission.  If you send it using the
git send-email (and see the Linux kernel's instructions for how to
submit changes[6]), to any mailing list at linux-*@vger.kernel.org,
including linux-ext4@vger.kernel.org, the Linux kernel changes will
get automatically get reviewed by an LLM agent, Sashiko[7].

[6] https://www.kernel.org/doc/html/latest/process/submitting-patches.html
[7] https://lwn.net/Articles/1063303/

For bonus points, if your AI agent can also create a regression test
much like how Andreas's patch, that would be great.  And if we can
collaborate on a skills.md that can teach AI agent how to create
reports that are easier for Linux developers to consume, and perhaps
to even create patches that require much less work on Linux developers
(or which Linux developers can use themselves), that would be really
exciting.  Yeah, that could result in a certain amount of LLM fear and
yourage as with rsync[5], but we have that with the Linux kernel
already.  :-)

Cheers,

						- Ted
