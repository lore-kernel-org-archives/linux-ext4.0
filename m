From: Quentin Godfroy <godfroy@clipper.ens.fr>
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Date: Thu, 9 Oct 2008 01:52:46 +0200
Message-ID: <200810082355.m98NtZkQ012577@goelette.ens.fr>
References: <20081003003548.GA18138@mit.edu> <20081005091526.GA678@goelette.ens.fr> <20081005122752.GB27335@mit.edu> <20081005161214.GA2985@goelette.ens.fr> <20081006025006.GA9289@mit.edu> <48EA2F20.7020309@redhat.com> <20081006175502.GA12937@mit.edu> <20081007221256.GF15929@mit.edu> <20081008000227.GA32052@goelette.ens.fr> <20081008005338.GH15929@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nef2.ens.fr ([129.199.96.40]:2161 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbYJHXz6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Oct 2008 19:55:58 -0400
Content-Disposition: inline
In-Reply-To: <20081008005338.GH15929@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 07, 2008 at 08:53:38PM -0400, Theodore Tso wrote:
> On Wed, Oct 08, 2008 at 02:02:27AM +0200, Quentin Godfroy wrote:
> > 
> > I rebooted, but as I didn't know exactly how to trigger the bug except than
> > by waiting a few days I was waiting to see.
> > 
> > Do you have an idea about how to trigger the bug?
> 
> The bug is that each time a transaction commits, if the buffer head
> hasn't been leaked already, it will leak pinning the memory until the
> total size of the journal is taking up memory.  If you have a 2gigs of
> memory, and a single filesystem with 256meg journal, you might not
> notice the problem at all.  If you less than 256 megs of memory,
> you'll notice fairly quickly.   

Indeed after a couple of days of uptime the number of dirty blocks do not go
further than ~50, so I think the bug is corrected as far as I am concerned.

By the way, why does the kernel not commit to memory these remaining buffers
when the memory is scarse (say instead of firing an OOM killer)?

Regards
Quentin Godfroy
