From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [BUG] infinite loop when unmounting ext3/4
Date: Tue, 28 Jul 2015 15:04:13 -0400
Message-ID: <20150728190413.GM2851@thunk.org>
References: <20150715143031.GB18016@dhcp-13-216.nay.redhat.com>
 <55A74CA8.9070902@huawei.com>
 <20150720072356.GC18016@dhcp-13-216.nay.redhat.com>
 <20150723204155.GA7814@quack.suse.cz>
 <20150727195440.GA22077@quack.suse.cz>
 <20150728071502.GF18016@dhcp-13-216.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@huawei.com>,
	linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36411 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbbG1TET (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jul 2015 15:04:19 -0400
Content-Disposition: inline
In-Reply-To: <20150728071502.GF18016@dhcp-13-216.nay.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 28, 2015 at 03:15:26PM +0800, Eryu Guan wrote:
> > > To fix the issue you've reported, we just need to teach
> > > jbd2_log_do_checkpoint() to cleanup all the buffers in the transactions
> > > when the journal is aborted so that journal_destroy() can proceed. I can
> > > have a look at it sometime next week unless someone beats me to it.
> > 
> > OK, attached is the patch that fixes the issue for me. Ted, can you please
> > pick it up? Thanks!
> 
> I confirmed that the attached patch fixed the infinite loop on aborted
> journal. Thanks!

Applied, thanks.

						- Ted
