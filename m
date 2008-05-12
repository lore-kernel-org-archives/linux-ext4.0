From: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Mon, 12 May 2008 23:37:46 +0400
Message-ID: <90edad820805121237r7f4b6e16g135df49cfe27499a@mail.gmail.com>
References: <20080512130604.GA15008@deprecation.cyrius.com>
	 <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com>
	 <20080512143426.GB7029@mit.edu>
	 <20080512145836.GE15866@deprecation.cyrius.com>
	 <90edad820805120814l7ee3f5d3h7f9939854bccf0@mail.gmail.com>
	 <20080512173537.GG7029@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Martin Michlmayr" <tbm@cyrius.com>, linux-mips@linux-mips.org,
	linux-ext4@vger.kernel.org, sfr@canb.auug.org.au
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:19345 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYELTiB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 15:38:01 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1385632ywe.1
        for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 12:37:47 -0700 (PDT)
In-Reply-To: <20080512173537.GG7029@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>
>  Yeah, I guess no one is currently doing test builds of linux-next on
>  the mips architecture.  It's likely Stephen Rothwell doesn't have
>  access to one.
>

I do that sometimes. Obviously, not frequently enough. Sorry.

If Stephen wants, I, in principle, could set up a MIPS toolchain for
him, similar to the one I use myself in my small test farm. Or assist
in doing that somehow. Stephen, what do you think of that?

Dmitri
