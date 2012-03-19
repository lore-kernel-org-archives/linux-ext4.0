From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: what happened with dccaf33fa37 "ext4: flush any pending end_io
 requests before DIO" for 3.0?
Date: Mon, 19 Mar 2012 10:21:01 -0700
Message-ID: <20120319172101.GA25038@kroah.com>
References: <4ED6942F.7070006@msgid.tls.msk.ru>
 <4F4CBDA1.1080302@msgid.tls.msk.ru>
 <4F6459F2.8010403@msgid.tls.msk.ru>
 <20120319164256.GB10561@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@kernel.org, linux-ext4@vger.kernel.org,
	Jiaying Zhang <jiayingz@google.com>,
	Theodore Ts'o <tytso@mit.edu>, Michael Tokarev <mjt@tls.msk.ru>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55096 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab2CSRVF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2012 13:21:05 -0400
Received: by ghrr11 with SMTP id r11so5636743ghr.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2012 10:21:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120319164256.GB10561@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 05:42:56PM +0100, Jan Kara wrote:
> On Sat 17-03-12 13:31:30, Michael Tokarev wrote:
> > Ping?
> > 
> > Maybe just a one-line reply isn't THAT difficult?
> > 
> > We've a data corruption bug in current longterm stable kernel
> > series which is known and has a fix and tagged for -stable for
> > over half a year already...
>   Greg, any idea why this patch was not included?

I have no idea, sorry, that was way back in August of 2011, I can barely
remember what patches were and were not applied last week...

If it's still needed for 3.0, let me know and I'll be glad to queue it
up.

thanks,

greg k-h
