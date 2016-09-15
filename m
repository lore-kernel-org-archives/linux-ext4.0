From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: improve ext4lazyinit scalability V2
Date: Thu, 15 Sep 2016 11:22:04 -0400
Message-ID: <20160915152204.eryra42mtigl5aru@thunk.org>
References: <1471263815-26022-1-git-send-email-dmonakhov@openvz.org>
 <20160815150520.GA22082@quack2.suse.cz>
 <20160906033954.k22xaasbn26s4wo4@thunk.org>
 <20160906083608.GB28922@quack2.suse.cz>
 <87poohcq96.fsf@dmlp.Dlink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55614 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753342AbcIOPW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Sep 2016 11:22:57 -0400
Content-Disposition: inline
In-Reply-To: <87poohcq96.fsf@dmlp.Dlink>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 06, 2016 at 12:49:09PM +0300, Dmitry Monakhov wrote:
> > ext4_run_li_request() can also update elr->lr_next_sched. So we need to
> > update next_wakeup even in progress == 1 case (i.e., I'd leave the update
> > of next_wakeup as is in the old code...). Otherwise the patch looks good.
> Yes. That is correct. Simply last hank shoul not be deleted.
> 
> Theodore, please fold patch attached to original one.

Done, thanks!!

					- Ted
