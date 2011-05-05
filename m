From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd/jbd2: remove obsolete summarise_journal_usage.
Date: Thu, 5 May 2011 19:25:04 +0200
Message-ID: <20110505172504.GQ5323@quack.suse.cz>
References: <1304610859-480-1-git-send-email-tm@tao.ma>
 <20110505161454.GM5323@quack.suse.cz>
 <4DC2CDDA.2000406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org
To: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60066 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab1EERZG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 13:25:06 -0400
Content-Disposition: inline
In-Reply-To: <4DC2CDDA.2000406@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 05-05-11 21:48:34, Niraj Kulkarni wrote:
>     I have a question, if only one instance of kjournald is active
> at any time, and committing transaction is well separated from
> others, what is need of taking j_list_lock while operating on
> committing transaction's lists?
  Other processes (e.g. journal_unmap_buffer()) can occasionally manipulate
with lists of the committing transaction.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
