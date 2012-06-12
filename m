From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Tue, 12 Jun 2012 20:07:28 +0000
Message-ID: <201206122007.28514.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206121455.50639.arnd.bergmann@linaro.org> <20120612181958.GB1803@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57369 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2FLUHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2012 16:07:35 -0400
In-Reply-To: <20120612181958.GB1803@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 12 June 2012, Ted Ts'o wrote:
> On Tue, Jun 12, 2012 at 02:55:50PM +0000, Arnd Bergmann wrote:
> > 
> > As I said, it's not a technical limitation, but a logical conclusion
> > from trying to use the context ID for something useful. The only
> > reason to use context ID in the first place is to reduce the amount
> > of garbage collection in the device (improving performance and expected
> > life of the device), so any context ID annotations we make should be
> > directed at giving useful information to the device to actually do that.
> 
> ... and a big part of that is knowing what is the downside if we give
> incorrect information to the device.  And what are the exact
> implications of what it means to group a set of blocks into a
> "context".
> 
> If it is fundamentally a promise that blocks in a context will be
> overwritten or trimmed at the same time then is it counterproductive
> to group blocks for overwrite-in-place database where the lifetimes of
> the block are extremely different?  Is that giving "wrong" information
> going to significantly increase the write amplification factor? 

I don't think that can be derived from the definition of the context.
Instead, the important part is that we separate the data with predictable
lifetime from data with unpredictable lifetime. If we happen to be
writing both a linear file on the one hand (or multiple such files) and
at the same time updating a database, any reasonable implementation would
be able to benefit from the fact that the linear data is now in a different
erase block from the random-access data. The database file is still
screwed like it is without context support, but it no longer makes
the linear access worse.

> It may be that the standard doesn't actually answer these questions
> and even worse, SSD manufactures may be stupidly trying to keep this
> stuff as a "trade securet" --- but we do need to know in order to
> optimize performance on real hardware....

Right. The danger here is that the context support was described in
the standard first, while none of the devices seem to even be
smart enough to make use of the information we put in there. Once
operating systems start putting some data in there, at least
some manufacturers will start making use of that data to optimize
the accesses, but it's very unlikely that they will tell us exactly
what they are doing. Having code in ext4 that uses the contexts will
at least make it more likely that the firmware optimizations are
based on ext4 measurements rather than some other file system or
operating system.
>From talking with the emmc device vendors, I can tell you that ext4
is very high on the list of file systems to optimize for, because
they all target Android products.

	Arnd
