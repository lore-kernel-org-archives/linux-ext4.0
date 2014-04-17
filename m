From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: an infinite loop in ext4 in 3.14
Date: Thu, 17 Apr 2014 17:16:27 -0400
Message-ID: <20140417211627.GC4979@thunk.org>
References: <alpine.LRH.2.02.1404171510330.22570@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55968 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaDQVQa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 17:16:30 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1404171510330.22570@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2014 at 03:23:13PM -0400, Mikulas Patocka wrote:
> 
> I hit a bug in ext4 - jbd2 was stuck in an infinite loop when remounting 
> the root filesystem read-only during shutdown.

Is this at all repeatable?  I suspect what happened is that we're not
checking the error return from jbd2_log_do_checkpoint(), and if it ran
into an error doing the jbd2_log_do_checkpoint --- for example, if it
wasn't able to write to the journal --- say, because __wait_cp_io()
returned -EIO, we might be spinning in the while loop in jbd2_journal_flush:

> while (!err && journal->j_checkpoint_transactions != NULL) {


(as you suspected).

I can add some error checking, but it would be interesting to know if
you can easily reproduce the problem so we can confirm if that's what
was really going on.

Regards,

						- Ted
