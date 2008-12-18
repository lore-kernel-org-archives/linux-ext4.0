From: Simon Kirby <sim@netnation.com>
Subject: Re: EXT3 way too happy with write errors
Date: Thu, 18 Dec 2008 09:49:22 -0800
Message-ID: <20081218174921.GF20515@hostway.ca>
References: <20081015002256.GD25662@hostway.ca> <20081218170714.GA6797@atrey.karlin.mff.cuni.cz> <20081218171825.GD20515@hostway.ca> <20081218172759.GE13580@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Mike Snitzer <snitzer@gmail.com>,
	Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from newpeace.netnation.com ([204.174.223.7]:40757 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069AbYLRRtZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 12:49:25 -0500
Content-Disposition: inline
In-Reply-To: <20081218172759.GE13580@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[ You guys were on this original thread.. ]

Re: http://markmail.org/message/jcku5vo5grcjjd3s#query:+page:1+mid:ws2wkcj66ucozlnd+state:results

Maybe you could explain why on earth would you want this configurable?

I think it's a horrible idea to make the default to ignore write errors,
and still a bad idea to even make this an option.  Do people really want
data corruption and a log message rather than a a clean way to recover
from such an error, depending on the cause of it?

Aborting on data write error: User can fix why it can't write (maybe the
bus just went to lunch), remount-rw or reboot and the journal will replay
and the file system will be consistent, data and metadata, just as if the
power had failed.

Not aborting on data write error: User loses data.  File system gets very
confused.

What am I missing?

Simon-

On Thu, Dec 18, 2008 at 06:27:59PM +0100, Jan Kara wrote:

> On Thu 18-12-08 09:18:25, Simon Kirby wrote:
> 
> > Cool, but one question.. Can you think of a case where anyone would ever
> > want data_err=ignore?
> > 
> > Should this really be a knob?
>
>   Originally, we changed the behavior unconditionally but then someone came
> up with some reasonable argument why it should be tunable. I don't remember
> it exactly, sorry :).
> 
> 									Honza
