From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: Rate limit printk in buffer_io_error()
Date: Thu, 11 Jul 2013 22:44:12 -0400
Message-ID: <20130712024412.GA23785@thunk.org>
References: <1373410898-26826-1-git-send-email-anatol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Anatol Pomozov <anatol.pomozov@gmail.com>
To: Anatol Pomazau <anatol@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37078 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3GLCoP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Jul 2013 22:44:15 -0400
Content-Disposition: inline
In-Reply-To: <1373410898-26826-1-git-send-email-anatol@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 09, 2013 at 04:01:38PM -0700, Anatol Pomazau wrote:
> From: Anatol Pomozov <anatol.pomozov@gmail.com>
> 
> If there are a lot of outstanding buffered IOs when a device is
> taken offline (due to hardware errors etc), ext4_end_bio prints
> out a message for each failed logical block. While this is desirable,
> we see thousands of such lines being printed out before the
> serial console gets overwhelmed, causing ext4_end_bio() wait for
> the printk to complete.
> 
> This in itself isn't a disaster, except for the detail that this
> function is being called with the queue lock held.
> This causes any other function in the block layer
> to spin on its spin_lock_irqsave while the serial console is
> draining. If NMI watchdog is enabled on this machine then it
> eventually comes along and shoots the machine in the head.
> 
> The end result is that losing any one disk causes the machine to
> go down. This patch rate limits the printk to bandaid around the
> problem.
> 
> Tested: xfstests
> Change-Id: I8ab5690dcf4f3a67e78be147d45e489fdf4a88d8
> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>

Thanks, applied.

					- Ted
