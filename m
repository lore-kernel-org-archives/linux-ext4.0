From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [2.6.25-rc2-mm1] Oops in __kmalloc
Date: Tue, 4 Mar 2008 14:51:40 +0200
Message-ID: <84144f020803040451u562eb378h2d6c2378d1b174fe@mail.gmail.com>
References: <47C42DDF.3060506@gmail.com>
	 <20080226100913.9412b41c.akpm@linux-foundation.org>
	 <47CD2753.5050905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Jan Sonnek" <xsonnek@fi.muni.cz>,
	"Christoph Lameter" <clameter@sgi.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:49726 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYCDMvl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 07:51:41 -0500
Received: by rv-out-0910.google.com with SMTP id k20so475834rvb.1
        for <linux-ext4@vger.kernel.org>; Tue, 04 Mar 2008 04:51:40 -0800 (PST)
In-Reply-To: <47CD2753.5050905@gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 4, 2008 at 12:41 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>  >> while booting up a notebook on 32 bit, this oopses appeared on the console
>  >> after ext3 fsck:
>  >> http://www.fi.muni.cz/~xslaby/sklad/mem_oops/
>  >>
>  >> It's 2.6.25-rc2-mm1, I can't find similar reports, is this known or hardware
>  >> issue (unlikely, 2.6.24.2 seems to be OK)?
>  >
>  > I don't recall seeing a similar report and yes, it'll be a kernel bug.
>  >
>  > We've fixed a few things and it could be that this will just go away in
>  > next -mm.  If it doesn't, a bisection search would be good, thanks.
>
>  Well, next -mm is out. Could you test, Jan? [our -mm git is up-to-date]

I don't see your config but if you have CONFIG_SLUB enabled, this is
probably the same problem as:

http://bugzilla.kernel.org/show_bug.cgi?id=10015

which is fixed since 2.6.25-rc2 in mainline.

                              Pekka
