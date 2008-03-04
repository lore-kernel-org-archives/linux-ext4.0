From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [2.6.25-rc2-mm1] Oops in __kmalloc
Date: Tue, 04 Mar 2008 13:55:17 +0100
Message-ID: <47CD46B5.7050509@gmail.com>
References: <47C42DDF.3060506@gmail.com>	 <20080226100913.9412b41c.akpm@linux-foundation.org>	 <47CD2753.5050905@gmail.com> <84144f020803040451u562eb378h2d6c2378d1b174fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jan Sonnek <xsonnek@fi.muni.cz>,
	Christoph Lameter <clameter@sgi.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:51748 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbYCDMyf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 07:54:35 -0500
Received: by gv-out-0910.google.com with SMTP id s4so524088gve.37
        for <linux-ext4@vger.kernel.org>; Tue, 04 Mar 2008 04:54:33 -0800 (PST)
In-Reply-To: <84144f020803040451u562eb378h2d6c2378d1b174fe@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pekka Enberg napsal(a):
> On Tue, Mar 4, 2008 at 12:41 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>  >> while booting up a notebook on 32 bit, this oopses appeared on the console
>>  >> after ext3 fsck:
>>  >> http://www.fi.muni.cz/~xslaby/sklad/mem_oops/
>>  >>
>>  >> It's 2.6.25-rc2-mm1, I can't find similar reports, is this known or hardware
>>  >> issue (unlikely, 2.6.24.2 seems to be OK)?
>>  >
>>  > I don't recall seeing a similar report and yes, it'll be a kernel bug.
>>  >
>>  > We've fixed a few things and it could be that this will just go away in
>>  > next -mm.  If it doesn't, a bisection search would be good, thanks.
>>
>>  Well, next -mm is out. Could you test, Jan? [our -mm git is up-to-date]
> 
> I don't see your config but if you have CONFIG_SLUB enabled, this is
> probably the same problem as:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10015
> 
> which is fixed since 2.6.25-rc2 in mainline.

Yeah, slub armed. We'll see. Thanks.
