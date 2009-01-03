From: Simon Kirby <sim@netnation.com>
Subject: Re: EXT3 way too happy with write errors
Date: Fri, 2 Jan 2009 18:15:16 -0800
Message-ID: <20090103021516.GE9995@hostway.ca>
References: <20081015002256.GD25662@hostway.ca> <20081218170714.GA6797@atrey.karlin.mff.cuni.cz> <20081218171825.GD20515@hostway.ca> <20081218172759.GE13580@duck.suse.cz> <20081218174921.GF20515@hostway.ca> <532480950812181029k1baf8264y82fb6d9760fe05f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Mike Snitzer <snitzer@gmail.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from newpeace.netnation.com ([204.174.223.7]:50197 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757589AbZACCPW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Jan 2009 21:15:22 -0500
Content-Disposition: inline
In-Reply-To: <532480950812181029k1baf8264y82fb6d9760fe05f8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, Dec 18, 2008 at 9:49 AM, Simon Kirby <sim@netnation.com> wrote:
> > Not aborting on data write error: User loses data.  File system gets very
> > confused.
> >
> > What am I missing?
> 
> I can think of certain situations when companies may care about
> getting most of the data to disk and clean it up later.
> Datacenters may be replicating the data to many spindles and may
> sometimes care about throughput as much as possible. So lossy data
> could be preferred to complete data.
> 
> Not saying this is always preferred but I can see a use case.

Ok, fine, in this case they might know what they are doing.  Still, this
is not reason enough to default the case in point... ?

:)

Simon-
