From: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Mon, 12 May 2008 18:46:21 +0400
Message-ID: <90edad820805120746l61e67362vbd177d63e8b05dc8@mail.gmail.com>
References: <20080512130604.GA15008@deprecation.cyrius.com>
	 <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com>
	 <20080512143426.GB7029@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Martin Michlmayr" <tbm@cyrius.com>, linux-mips@linux-mips.org,
	linux-ext4@vger.kernel.org, ralf@linux-mips.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.188]:65118 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYELOqX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 10:46:23 -0400
Received: by gv-out-0910.google.com with SMTP id e6so275362gvc.37
        for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 07:46:21 -0700 (PDT)
In-Reply-To: <20080512143426.GB7029@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/5/12 Theodore Tso <tytso@mit.edu>:
> On Mon, May 12, 2008 at 05:54:24PM +0400, Dmitri Vorobiev wrote:
>  >
>  > Yep. The export is missing. Attached patch was build-tested for a
>  > Malta config with ext4 enabled as a module.
>
>  Thanks, Dmitri!
>
>  What is the Linux-mips' team preference for feeding this patch to
>  Linus?  This technically isn't a regression, since it was broken in
>  2.6.25, but it would be nice to get this to Linus sooner rather than
>  later.  Should I push it with a batch of ext4 fixes, or do you want to
>  push it via the mips tree?  (Davem asked me to push the sparc export
>  via ext4, while the ppc arch, it went via the ppc tree.  So whichever
>  is your preference; I'm easy.  :-)
>
>                                             - Ted

Hi Ted,

Normally I push my patches via the mips tree, and now I'm Cc:ing Ralf for that.

Hopefully Ralf will react quickly. :)

Dmitri
