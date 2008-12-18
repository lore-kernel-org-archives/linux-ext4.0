From: Jan Kara <jack@suse.cz>
Subject: Re: EXT3 way too happy with write errors
Date: Thu, 18 Dec 2008 18:27:59 +0100
Message-ID: <20081218172759.GE13580@duck.suse.cz>
References: <20081015002256.GD25662@hostway.ca> <20081218170714.GA6797@atrey.karlin.mff.cuni.cz> <20081218171825.GD20515@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Simon Kirby <sim@netnation.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:40543 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751946AbYLRR2C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Dec 2008 12:28:02 -0500
Content-Disposition: inline
In-Reply-To: <20081218171825.GD20515@hostway.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-12-08 09:18:25, Simon Kirby wrote:
> > we spotted a write error in filesystem metadata. If we spotted an error
> > in data, we just complained but continued. This seems to be exactly the
> > thing you are hitting. Latest Linus's tree (i.e. 2.6.28-rc5 or so) should
> > have the patches that allow tuning the behavior in data=ordered mode - i.e.
> > you can tell the filesystem by data_err=abort and data_err=ignore option
> > whether it should abort the filesystem or ignore write error in fs data.
> 
> Cool, but one question.. Can you think of a case where anyone would ever
> want data_err=ignore?
> 
> Should this really be a knob?
  Originally, we changed the behavior unconditionally but then someone came
up with some reasonable argument why it should be tunable. I don't remember
it exactly, sorry :).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
