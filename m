From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] ext4: fix 50% disk write performance regression
Date: Mon, 30 Aug 2010 14:35:53 -0500
Message-ID: <4C7C0819.8040505@redhat.com>
References: <20100829231126.8d8b2086.billfink@mindspring.com>	<4C7BE4DD.1060208@redhat.com> <20100830153025.302fa359.bill@wizard.sci.gsfc.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bill Fink <billfink@mindspring.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Fink, William E. (GSFC-6061)" <william.e.fink@nasa.gov>
To: Bill Fink <bill@wizard.sci.gsfc.nasa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab0H3TgC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Aug 2010 15:36:02 -0400
In-Reply-To: <20100830153025.302fa359.bill@wizard.sci.gsfc.nasa.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bill Fink wrote:
> On Mon, 30 Aug 2010, Eric Sandeen wrote:

...

>> When I get some time (soon I hope) I'll look into the ramifications
>> of this change (i.e. what if wbc->nr_to_write * 8 is more than the dirty
>> pages, do things work out ok?) but it seems pretty reasonable.
> 
> In thinking about that issue, my non-expert thought was that
> if desired_nr_to_write was larger, it hopefully wouldn't be an
> issue since presumably it's only going to actually write at most
> the number of dirty pages anyway.  And on the flip side, there
> doesn't seem to be an issue with desired_nr_to_write possibly
> being smaller that it was without the patch, since the empirical
> evidence is that the performance significantly improved with the
> patch, and the effect of a lower value would presumably be
> reduced performance.
> 
> 					-Bill

Ted's suggestion of capturing blktrace data would be a really great
step towards understanding what changed, too.

Thanks!

-Eric
