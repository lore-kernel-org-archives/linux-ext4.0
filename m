From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] ext4: Use kstrtoul() instead of deprecated
 simple_strtoul()
Date: Mon, 11 Mar 2013 08:36:16 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303110830260.24359@localhost>
References: <1362730998-3263-1-git-send-email-lczerner@redhat.com> <1362730998-3263-2-git-send-email-lczerner@redhat.com> <20130311022635.GG10090@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab3CKHgU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 03:36:20 -0400
In-Reply-To: <20130311022635.GG10090@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 10 Mar 2013, Theodore Ts'o wrote:

> Date: Sun, 10 Mar 2013 22:26:35 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 2/3] ext4: Use kstrtoul() instead of deprecated
>     simple_strtoul()
> 
> On Fri, Mar 08, 2013 at 09:23:17AM +0100, Lukas Czerner wrote:
> > In parse_strtoul() we're still using deprecated simple_strtoul(). Change
> > that in favour of kstrtoul().
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Once you make this change, wouldn't it be better and even more
> simplifying to replace the two places where we call parse_strtoul()
> with kstrtoul()?
> 
> 					- Ted

I think that parse_strtoul() is still useful to have because we
check the "max" value as well and return -EINVAL if it is exceeded.
Removing it we would have to add the check to the callers
where we're using is now, which seems unnecessary, especially since
we might expect more users of the helper.

-Lukas
