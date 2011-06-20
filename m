From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/3] jbd2: Add extra parameter in
 start_this_handle() to control allocation flags.
Date: Mon, 20 Jun 2011 16:32:01 +0200
Message-ID: <20110620143201.GD4810@quack.suse.cz>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563657-4334-1-git-send-email-mkatiyar@gmail.com>
 <20110531112253.GD5614@quack.suse.cz>
 <20110531222720.GA3867@thunk.org>
 <20110602095424.GA5718@quack.suse.cz>
 <20110606032113.GC7180@thunk.org>
 <20110608141006.GG30037@thunk.org>
 <BANLkTikVuPx8F8DSdjFxZyR8ZA0ts3hQ_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1FTOcE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jun 2011 10:32:04 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikVuPx8F8DSdjFxZyR8ZA0ts3hQ_w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Thu 16-06-11 23:32:12, Manish Katiyar wrote:
> On Wed, Jun 8, 2011 at 7:10 AM, Ted Ts'o <tytso@mit.edu> wrote:
> > Ping?
> 
> Is there anything required from my side on this patch ? From your
> other post it seems that holding i_mutex isn't a problem. Please
> advise.
  OK, after my discussion with Ted today, i_mutex really shouldn't be an
issue so your patch should be fine. I just suggest you resend it to Ted to
remind yourself :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
