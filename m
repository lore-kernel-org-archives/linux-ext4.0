From: Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: still running into WARNING: CPU: at fs/ext4/inode.c:230
 ext4_evict_inode+0x4a6/0x4e0
Date: Tue, 03 Dec 2013 10:58:46 -0800
Message-ID: <1386097126.2741.1.camel@buesod1.americas.hpqcorp.net>
References: <1381888924.2371.5.camel@buesod1.americas.hpqcorp.net>
	 <20131016125004.GC14278@quack.suse.cz>
	 <1381938967.4324.0.camel@buesod1.americas.hpqcorp.net>
	 <20131016183807.GA1405@quack.suse.cz>
	 <20131129073702.GA23954@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:14215 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab3LCS6t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 13:58:49 -0500
In-Reply-To: <20131129073702.GA23954@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2013-11-29 at 08:37 +0100, Jan Kara wrote:
> On Wed 16-10-13 20:38:07, Jan Kara wrote:
> > On Wed 16-10-13 08:56:07, Davidlohr Bueso wrote:
> > > On Wed, 2013-10-16 at 14:50 +0200, Jan Kara wrote:
> > > > On Tue 15-10-13 19:02:04, Davidlohr Bueso wrote:
> > > > > Hello Jan,
> > > > > 
> > > > > Just wanted to let you know I hit this[1] again on Linus' latest. The
> > > > > setup/workload is *identical* to the reported one a few months ago.
> > > > > 
> > > > > [1] https://lkml.org/lkml/2013/8/1/532
> > > > > 
> > > > > Here's the complete output, I hope it helps...
> > > >   Thanks for the headup. Last time I wasn't able to reproduce this and
> > > > eventually forgot about the problem. Can I send you a debug patch and you
> > > > would run a kernel with it? Thanks.
> > > 
> > > Sure.
> >   OK, attached is the debug patch. Please apply it and send dmesg when the
> > problem reproduces. Also please attach System.map so that I can map the
> > 'created at' addresses to symbols. Thanks.
>   Ping? Any luck with the debug patch?

Sorry for the delay, I haven't had much time to look into this. I do
remember applying the patch and getting a panic - I don't have any more
data at the moment, hopefully I can get back soon with details.

Thanks,
Davidlohr

