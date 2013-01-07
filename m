From: Chris Mason <chris.mason@fusionio.com>
Subject: Re: data=guarded mode in ext3
Date: Mon, 7 Jan 2013 10:59:25 -0500
Message-ID: <20130107155925.GC30947@shiny>
References: <CAKaWdxYi_RpjSAp9sL9oeM2i1sCR5foKpvV2bCHDrbM0Dj3DtA@mail.gmail.com>
 <50EAEDF0.4010609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Keith Chew <keith.chew@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Chris Mason <clmason@fusionio.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:33140 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab3AGP7a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jan 2013 10:59:30 -0500
Content-Disposition: inline
In-Reply-To: <50EAEDF0.4010609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 07, 2013 at 08:46:56AM -0700, Ric Wheeler wrote:
> On 12/03/2012 09:34 PM, Keith Chew wrote:
> > Hi
> >
> > Just wanted to check if the "'Data=guarded' mode in Ext3" work started
> > by Chris Mason, is still being considered for merging to the mainline
> > kernel? Or has that effort stopped?
> >
> > Regards
> > Keith
> >
> 
> Hi Keith,
> 
> I think that Chris is spending pretty much all of his time on btrfs these days. 
> I believe this work is pretty much abandoned at this point...
> 
> What are you looking for specifically from this?

Ric has it right, the change was big enough that I didn't think it was
worth the risk of changing how ext3 works.  Most people are going to
want ext4 anyway for a lot of reasons, so it made sense to focus bigger
changes in the ext4 code base.

-chris
