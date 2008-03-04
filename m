From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [2.6.25-rc2-mm1] Oops in __kmalloc
Date: Tue, 04 Mar 2008 14:57:33 +0200
Message-ID: <47CD473D.1070403@cs.helsinki.fi>
References: <47C42DDF.3060506@gmail.com>	 <20080226100913.9412b41c.akpm@linux-foundation.org>	 <47CD2753.5050905@gmail.com> <84144f020803040451u562eb378h2d6c2378d1b174fe@mail.gmail.com> <47CD46B5.7050509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jan Sonnek <xsonnek@fi.muni.cz>,
	Christoph Lameter <clameter@sgi.com>
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44181 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760619AbYCDM6v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 07:58:51 -0500
In-Reply-To: <47CD46B5.7050509@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jiri Slaby wrote:
> > I don't see your config but if you have CONFIG_SLUB enabled, this is
> > probably the same problem as:
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=10015
> >
> > which is fixed since 2.6.25-rc2 in mainline.
> 
> Yeah, slub armed. We'll see. Thanks.

Sorry for the typo, it's fixed in 2.6.25-rc3.

			Pekka
