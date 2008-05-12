From: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Mon, 12 May 2008 19:14:23 +0400
Message-ID: <90edad820805120814l7ee3f5d3h7f9939854bccf0@mail.gmail.com>
References: <20080512130604.GA15008@deprecation.cyrius.com>
	 <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com>
	 <20080512143426.GB7029@mit.edu>
	 <20080512145836.GE15866@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@mit.edu>, linux-mips@linux-mips.org,
	linux-ext4@vger.kernel.org
To: "Martin Michlmayr" <tbm@cyrius.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:48570 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbYELPOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 11:14:38 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1321216ywe.1
        for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 08:14:23 -0700 (PDT)
In-Reply-To: <20080512145836.GE15866@deprecation.cyrius.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/5/12 Martin Michlmayr <tbm@cyrius.com>:
> * Theodore Tso <tytso@mit.edu> [2008-05-12 10:34]:
>
> > What is the Linux-mips' team preference for feeding this patch to
>  > Linus?  This technically isn't a regression, since it was broken in
>  > 2.6.25, but it would be nice to get this to Linus sooner rather than
>
>  Actually, it built just fine with 2.6.25.

It was April 29th 2008 when commit
093a088b76352e0a6fdca84eb78b3aa65fbe6dd1 where the ext4_ext_zeroout()
routine was introduced (it is this routine that makes use of the
ZERO_PAGE macro expanding to an expression that contains a reference
to the empty_zero_page global symbol). After this commit, the patches
similar to the one found in this thread were made for several
architectures. Apparently, MIPS has been overlooked.

Dmitri
