From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] jbd: Provide function to check whether transaction
 will issue data barrier
Date: Tue, 27 Apr 2010 22:48:31 +0200
Message-ID: <20100427204831.GD5103@quack.suse.cz>
References: <1272312659-16468-1-git-send-email-jack@suse.cz>
 <1272312659-16468-2-git-send-email-jack@suse.cz>
 <87eii1d0hy.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab0D0Usb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Apr 2010 16:48:31 -0400
Content-Disposition: inline
In-Reply-To: <87eii1d0hy.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 27-04-10 07:42:49, Dmitry Monakhov wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > Provide a function which returns whether a transaction with given tid
> > will send a barrier to the filesystem device. The function will be used
> > by ext3 to detect whether fsync needs to send a separate barrier or not.
> Agree. Except the fact that in case of j_dev != j_fs_dev jbd is still
> broken.
  Yeah, I know about this. I had a look at it but stumbled over a barrier
issue in the checkpointing code
(http://marc.info/?l=linux-ext4&m=127198235617788&w=2) so I though I'll
wait till that gets resolved.

> I'm plan to post back-port from jbd2 which makes
> journal_trans_will_send_data_barrier() more complex. It have to analyze
> commit_transaction->t_flushed_data_blocks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
