From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: what happened with dccaf33fa37 "ext4: flush any pending end_io
 requests before DIO" for 3.0?
Date: Wed, 28 Mar 2012 15:22:14 -0700
Message-ID: <20120328222214.GB9514@kroah.com>
References: <4ED6942F.7070006@msgid.tls.msk.ru>
 <4F4CBDA1.1080302@msgid.tls.msk.ru>
 <4F6459F2.8010403@msgid.tls.msk.ru>
 <20120319164256.GB10561@quack.suse.cz>
 <CAFgt=MCXRzLx+s1mthr1oD=Pj=HQ5kxnOdbtX8Q9=wSeZ41u2w@mail.gmail.com>
 <4F676B2F.8040209@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jiaying Zhang <jiayingz@google.com>,
	Theodore Tso <tytso@google.com>, stable@kernel.org,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45838 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab2C1WWS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Mar 2012 18:22:18 -0400
Received: by pbcun15 with SMTP id un15so2367583pbc.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Mar 2012 15:22:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4F676B2F.8040209@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 09:21:51PM +0400, Michael Tokarev wrote:
> 19.03.2012 21:10, Jiaying Zhang wrote:
> >On Mon, Mar 19, 2012 at 9:42 AM, Jan Kara<jack@suse.cz>  wrote:
> >>On Sat 17-03-12 13:31:30, Michael Tokarev wrote:
> >>>Ping?
> >>>
> >>>Maybe just a one-line reply isn't THAT difficult?
> >Sorry for the slow response. I am not sure what happened to this patch.
> >Ted, do you know what we need to do to get this patch to the
> >stable release?
> 
> For reference, attached is the version I use locally since last August.

Wonderful, thanks for this, now queued up.

greg k-h
