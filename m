From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: duplicate entries on ext3 when using readdir/readdir64
Date: Thu, 14 Aug 2008 19:27:45 -0400
Message-ID: <170fa0d20808141627i7f05fbcdnf043e090834940dd@mail.gmail.com>
References: <1217583820.12454.20.camel@kannnix.a2x.lan.at>
	 <20080801121658.GG8736@mit.edu>
	 <1217933631.14552.45.camel@kannnix.a2x.lan.at>
	 <20080806140722.GA14109@mit.edu>
	 <170fa0d20808131421j3e4955dcra611509f1a094547@mail.gmail.com>
	 <20080814025821.GA6469@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Thomas Trauner" <tt@it-austria.net>, linux-ext4@vger.kernel.org,
	ext3-users <ext3-users@redhat.com>, eugene@ibrix.com
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:1526 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYHNX1q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 19:27:46 -0400
Received: by wa-out-1112.google.com with SMTP id j37so353460waf.23
        for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 16:27:45 -0700 (PDT)
In-Reply-To: <20080814025821.GA6469@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 10:58 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Aug 13, 2008 at 05:21:20PM -0400, Mike Snitzer wrote:
>>
>> The attached patch has served my employer (IBRIX) well for 2.5 years.
>> It was only recently, when I re-raised this issue internally based on
>> this thread, that a co-worker recalled the fix.
>>
>
> The patch looks good.  Did someone raise it 2.5 years ago, and we
> somehow dropped the ball, or did no one think to submit the patch
> upstream?

We intended to push this fix upstream but doing so got inadvertently
overlooked as we put focus to new issues.  I mentioned how long ago
this patch was developed purely to help illustrate the stability of
the fix.

> Also, can I get a Signed-off-by: line for this patch?

Eugene Dashevsky authored the patch; I refreshed it against 2.6.27-rc3:

Signed-off-by: Eugene Dashevsky <eugene@ibrix.com>
Signed-off-by: Mike Snitzer <msnitzer@ibrix.com>

thanks,
Mike
