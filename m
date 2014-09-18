From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext4: Explicitly inform user about orphan list
 cleanup.
Date: Thu, 18 Sep 2014 10:49:56 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1409181048460.3870@localhost.localdomain>
References: <1410698337-27454-1-git-send-email-dmonakhov@openvz.org> <1410698337-27454-2-git-send-email-dmonakhov@openvz.org> <20140918042907.GD24887@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbaIRIuG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 04:50:06 -0400
In-Reply-To: <20140918042907.GD24887@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 18 Sep 2014, Theodore Ts'o wrote:

> Date: Thu, 18 Sep 2014 00:29:07 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Dmitry Monakhov <dmonakhov@openvz.org>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 2/2] ext4: Explicitly inform user about orphan list
>     cleanup.
> 
> On Sun, Sep 14, 2014 at 04:38:57PM +0400, Dmitry Monakhov wrote:
> > Production fs likely compiled/mounted w/o jbd debugging, so orphan list clearing
> > will be silent.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> Thanks, applied.

Hmm did not we just take this out recently with

566370a2e56837be98bc62d012fc2d2d11851db4 ext4: suppress ext4 orphan
messages on mount

and TBH I like it that way.

Thanks!
-Lukas

> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
