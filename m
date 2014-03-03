From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 5/8] xfstests: Add fallocate zero range operation to
 fsstress
Date: Mon, 3 Mar 2014 13:16:20 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403031315280.2258@localhost.localdomain>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com> <1393603865-26198-5-git-send-email-lczerner@redhat.com> <5310C9F8.20009@sandeen.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbaCCMQ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2014 07:16:28 -0500
In-Reply-To: <5310C9F8.20009@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 28 Feb 2014, Eric Sandeen wrote:

> Date: Fri, 28 Feb 2014 11:40:08 -0600
> From: Eric Sandeen <sandeen@sandeen.net>
> To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 5/8] xfstests: Add fallocate zero range operation to
>     fsstress
> 
> On 2/28/14, 10:11 AM, Lukas Czerner wrote:
> > This commit adds fzero operation support for fsstress, which is meant to
> > exercise fallocate FALLOC_FL_ZERO_RANGE support.
> > 
> > Also reorganise the common fallocate code into a single do_fallocate()
> > function and use flags use the right mode.
> > 
> > Also in order to make more obvious which fallocate mode fsstress is
> > testing translate fallocate flags into human readable strings.
> 
> Can you enhance that so that if it's passed a flag which isn't
> in the known array, it prints the leftover values?  Otherwise
> they are silently dropped, which might be confusing.
> 
> Handling the case where a flag is not in the array would future-proof
> it, I think.
> 
> -Eric

Yes, I can do that. The only reason I've left this out was to force
people to actually update it when they update the test with new
flag.

Thanks!
-Lukas
