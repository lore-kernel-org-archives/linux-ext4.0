From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: online resize of ext4 hung (3.2.51 / 1.42.5)
Date: Fri, 25 Oct 2013 19:57:45 -0400
Message-ID: <20131025235745.GA2448@thunk.org>
References: <20131025220632.62b4f9b3@samsa>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jakob Haufe <sur5r@sur5r.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50898 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab3JYX5t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Oct 2013 19:57:49 -0400
Content-Disposition: inline
In-Reply-To: <20131025220632.62b4f9b3@samsa>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 25, 2013 at 10:06:32PM +0200, Jakob Haufe wrote:
> 
> I can leave the machine sitting around for another day or maybe two, so if
> it's necessary to extract more information from somewhere, please tell me.

Can you run "echo t > /proc/sysrq-trigger" and send the output from
the console (or from dmesg)?  Or otherwise trigger sysrq-t?  This will
show the stacks of all of the processes, which would be useful to
figure out what might be happening.

Thanks,

						- Ted
