Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188082;
	b=LmGP0GlzaDdpADZXT7skD17Q9twzEis5sF7lNUpS/JmKSJyAA97jDQGDyOLddJZgEqsj
	 OheINObx6d8k+B5tFLdJedRY/nao/7zrgwFhMj9UB30CBOFfftrgQ5F7W0OsWy+xT4lD6
	 hxewyGkUDCMF5O/ZdjemUo6c3rvqFmXosi+7Y3Y9UEvI2IlXyS7Wi/d9ZVwakf+Vyzy1G
	 zr9OyGOxA8EFoj9Qkb91F8xxNwZa4LsTpNfWIxB89PwPnBYaJLpvpirTNt9U1eVCc7RA9
	 8IuU3nnstAoaLvMjfKrNKlRgMgReUdkQgkywyz/FBnaAFdTDngmj4pp7Oq91FrMIPIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188082;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Subject:
	 Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=3h+ClZ2tT+UpcGVTNUCNAoAlK43AS0JSLWnhS6ZNLE8=;
	b=3Nsbsr4a8Fqcw/2VCQN1nUpvo4R7rMwOIRSijMkTVhh+Imza9hk5oS4DKPobBfZ+elLW
	 X2Fx2yWHO4UKTa75m/ZQKOIREm8vHq9YCt4LuDv+IwTY5JgvU7W/t9PBSsmgepXSS2tXK
	 9zo0bX2PNFizxHtmoYG9nRyiHAxTmLQA1Z7dhaYC3qaSDcb7BEpdsTK0FvTFkCdkvnpSR
	 gqOj2/SV+EZ+Bw7T3Nc4s4ZjA7B6mTSZK9rnDm6Sy+B+7ItKZMv2Vxjy26KbXPWPfU+bS
	 sYydZreEw1ggNOIoZJmwwQJbLL4Ghbv0RtAGegH1xFrrMVHMXHeWshVqSMkrMvoY3zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=XWu3fLwX;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C63606A320
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 15:21:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12C63606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=XWu3fLwX
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AKFLBvk022687
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 10:21:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795188073; bh=3h+ClZ2tT+UpcGVTNUCNAoAlK43AS0JSLWnhS6ZNLE8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=XWu3fLwX4JIk1BcYF9eUjyZA67yBKv2DdTOJitvuzoBYAnvaVERH8cb2PdD+8pUsg
	 ggwlMAHzMwuYExvQrFq68RloNHK5EZ8ZTIwAxTjN7iokeQJRtaI/zc/q7wI7toMykz
	 kKuZ6RTMOlzI9ZStLrgn4ZDGAes9HrGO/LmeMQWkOliTN7imYKuu3orVXG5b3yNxBQ
	 eMw5/rh0vcguslaz57r1zooEywMdKp9U0ZAWqAUvA7MPpS7sp0dpb2sAu3P8pnZ5Ts
	 bcLjE5Lf2ph4MTahr9E6dyOwZdQ5kuXuTGYYiIKqtNrTD89lkaDK+WPzGOxQE0XnzN
	 nnbg0kwjONq8w==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 39014288DCDD; Fri, 20 Nov 2026 10:21:11 -0500 (EST)
Date: Fri, 20 Nov 2026 10:21:11 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Implementation plan for a dedicated block cache for ext4
Message-ID: <awBYFgSWjU5pDFDy@mit.edu>
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

As I had discussed on the ext4 conference call, I've been toying with
the idea of creating a dedicated block cache for ext4.  With the help
of AI --- I won't say AI Overlords; I'm conficed the AI Intern, or
perhaps AI PFY is more appropriate :-) --- I've come up with a
high-level design and implementation doc:

   https://github.com/tytso/ext4-artifacts/blob/main/jbuf/implementation-plan.md

I'd appreciate comments.  I'd suggest reading sections 1 (Goals), 3
(Architectural Decisions and Hazards), and 7 (Block-Device Superblock
Coherency) first.

Nothing here is locked down.  One of the things that I am still unsure
about is how nasty including support for data=journal mode is going to
be, and whether we will want to drop support before proceeding.

I expect we'll be doing several rounds of design reviews before I ask
the AI to create the patch series.  For people who prefer to look at
code first, feel free to wait until later.  But I do think this is one
place where debating things at the detail level of the implementation
plan is more efficient than having reading throguh 37 iterations of a
20 patch series.  :-)

						- Ted
