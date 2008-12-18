From: Simon Kirby <sim@netnation.com>
Subject: Re: EXT3 way too happy with write errors
Date: Thu, 18 Dec 2008 09:18:25 -0800
Message-ID: <20081218171825.GD20515@hostway.ca>
References: <20081015002256.GD25662@hostway.ca> <20081218170714.GA6797@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from newpeace.netnation.com ([204.174.223.7]:52945 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750973AbYLRRiX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 12:38:23 -0500
Content-Disposition: inline
In-Reply-To: <20081218170714.GA6797@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 18, 2008 at 06:07:14PM +0100, Jan Kara wrote:

>   Hello,
> 
>   This was quite a long time ago but it seems nobody replied yet :).

Thanks :)

>   What kernel version is this? Originally, we aborted a journal only if

At the time, this was 2.6.26.5.

> we spotted a write error in filesystem metadata. If we spotted an error
> in data, we just complained but continued. This seems to be exactly the
> thing you are hitting. Latest Linus's tree (i.e. 2.6.28-rc5 or so) should
> have the patches that allow tuning the behavior in data=ordered mode - i.e.
> you can tell the filesystem by data_err=abort and data_err=ignore option
> whether it should abort the filesystem or ignore write error in fs data.

Cool, but one question.. Can you think of a case where anyone would ever
want data_err=ignore?

Should this really be a knob?

Simon-
