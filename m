From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.25-rc2-mm1] Oops in __kmalloc
Date: Tue, 26 Feb 2008 10:09:13 -0800
Message-ID: <20080226100913.9412b41c.akpm@linux-foundation.org>
References: <47C42DDF.3060506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jan Sonnek <xsonnek@fi.muni.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762787AbYBZSKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Feb 2008 13:10:17 -0500
In-Reply-To: <47C42DDF.3060506@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 26 Feb 2008 16:18:55 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> while booting up a notebook on 32 bit, this oopses appeared on the console
> after ext3 fsck:
> http://www.fi.muni.cz/~xslaby/sklad/mem_oops/
> 
> It's 2.6.25-rc2-mm1, I can't find similar reports, is this known or hardware
> issue (unlikely, 2.6.24.2 seems to be OK)?

I don't recall seeing a similar report and yes, it'll be a kernel bug.

We've fixed a few things and it could be that this will just go away in
next -mm.  If it doesn't, a bisection search would be good, thanks.
