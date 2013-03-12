From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [REGRESSION] allocated N with only M reserved metadata blocks
Date: Tue, 12 Mar 2013 08:58:53 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303120838170.7128@dhcp-1-104.brq.redhat.com>
References: <20130311185423.GA15478@thunk.org> <20130311210201.GA940@wallace> <20130311212239.GD15478@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab3CLH7F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 03:59:05 -0400
In-Reply-To: <20130311212239.GD15478@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 11 Mar 2013, Theodore Ts'o wrote:

> Date: Mon, 11 Mar 2013 17:22:39 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Eric Whitney <enwlinux@gmail.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [REGRESSION] allocated N with only M reserved metadata blocks
> 
> On Mon, Mar 11, 2013 at 05:02:01PM -0400, Eric Whitney wrote:
> > 
> > FWIW, this might not be a regression.  I believe I've got this warning in my
> > testing logs from both 3.8 and 3.8-rc7 (commit 01a523eb51 in 3.9-rc1 affects
> > message format and line numbering) on both x86 and ARM.  I didn't run xfstest
> > 127 prior to 3.8-rc7, so I don't know how far back the warning may have
> > occurred for that particular test.
> > 
> > The 3.8-rc7 results are a little different with respect to number of warnings
> > and test cases, so I'm thinking this one isn't completely deterministic,
> > testing-wise.  Multiple test runs may be required to see it.
> 
> Thanks for the extra data; this saved be a whole bunch of time, since
> I probably would have started doing a series git bisects tonight.   :-)
> 
>   	   	      	      	      - Ted

I found that the problem is present even in 3.7.0, however it is not
present in 3.6.0. I guess we need to bisect now :)

-Lukas

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
