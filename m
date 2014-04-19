From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: an infinite loop in ext4 in 3.14
Date: Sat, 19 Apr 2014 16:33:36 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1404191438120.22143@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1404171510330.22570@file01.intranet.prod.int.rdu2.redhat.com> <20140417211627.GC4979@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaDSUdj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Apr 2014 16:33:39 -0400
In-Reply-To: <20140417211627.GC4979@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Thu, 17 Apr 2014, Theodore Ts'o wrote:

> On Thu, Apr 17, 2014 at 03:23:13PM -0400, Mikulas Patocka wrote:
> > 
> > I hit a bug in ext4 - jbd2 was stuck in an infinite loop when remounting 
> > the root filesystem read-only during shutdown.
> 
> Is this at all repeatable?  I suspect what happened is that we're not
> checking the error return from jbd2_log_do_checkpoint(), and if it ran
> into an error doing the jbd2_log_do_checkpoint --- for example, if it
> wasn't able to write to the journal --- say, because __wait_cp_io()
> returned -EIO, we might be spinning in the while loop in jbd2_journal_flush:
> 
> > while (!err && journal->j_checkpoint_transactions != NULL) {
> 
> 
> (as you suspected).
> 
> I can add some error checking, but it would be interesting to know if
> you can easily reproduce the problem so we can confirm if that's what
> was really going on.
> 
> Regards,
> 
> 						- Ted

Hi

It turned out that the computer had bad memory, there were other stability 
issues - so you can ignore this bug report.

Mikulas
