From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Mon, 12 May 2008 16:58:36 +0200
Message-ID: <20080512145836.GE15866@deprecation.cyrius.com>
References: <20080512130604.GA15008@deprecation.cyrius.com> <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com> <20080512143426.GB7029@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
	linux-mips@linux-mips.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:2966 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYELO6k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 10:58:40 -0400
Content-Disposition: inline
In-Reply-To: <20080512143426.GB7029@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Tso <tytso@mit.edu> [2008-05-12 10:34]:
> What is the Linux-mips' team preference for feeding this patch to
> Linus?  This technically isn't a regression, since it was broken in
> 2.6.25, but it would be nice to get this to Linus sooner rather than

Actually, it built just fine with 2.6.25.

-- 
Martin Michlmayr
http://www.cyrius.com/
