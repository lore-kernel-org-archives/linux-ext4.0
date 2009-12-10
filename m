From: Jan Kara <jack@suse.cz>
Subject: Re: BUG? a suspected race bug at ext3_xattr_block_set()
Date: Thu, 10 Dec 2009 16:42:03 +0100
Message-ID: <20091210154202.GB26516@atrey.karlin.mff.cuni.cz>
References: <2014bcab0911240327r68afb4a3r6e9cf238ce0df532@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52854 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZLJPl4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 10:41:56 -0500
Content-Disposition: inline
In-Reply-To: <2014bcab0911240327r68afb4a3r6e9cf238ce0df532@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> I am reporting a suspected data race bug from ext3/xattr.c in Linux 2.6.31.
  Thank you for your report.

> In ext3_xattr_block_set(), it accesses bs->bh->b_data
> while it does not hold lock_buffer(bs->bh).
> 
> However, there is no lock_buffer(bs->bh) and unlock_buffer(bs->bh)
> for guarding the access (at line 794).
  Yes, but we don't really look at the content of bs->bh->b_data. We
just compare the pointers and for that we definitely don't need the
lock. So I don't see problem. If you still do, please tell me more
details (like a sample of code executions of two threads which race).
Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
