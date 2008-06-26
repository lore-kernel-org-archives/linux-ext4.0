From: Jan Kara <jack@suse.cz>
Subject: Re: (take 2)[PATCH] JBD: positively dispose the unmapped data buffers in journal_commit_transaction
Date: Thu, 26 Jun 2008 19:18:57 +0200
Message-ID: <20080626171857.GA20004@atrey.karlin.mff.cuni.cz>
References: <485F8263.8000103@jp.fujitsu.com> <20080623192731.baf0904a.akpm@linux-foundation.org> <4860A9E8.9090103@jp.fujitsu.com> <4861F4BF.5060408@jp.fujitsu.com> <20080625203922.GA8711@atrey.karlin.mff.cuni.cz> <48633449.6060900@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43189 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858AbYFZRq3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jun 2008 13:46:29 -0400
Content-Disposition: inline
In-Reply-To: <48633449.6060900@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Hi,
> 
> Jan Kara wrote:
> >  Hi,
> >
> >>I updated my patch and introduction article for it by reflecting
> >>the comment of Andrew's.
> <SNIP>
> >>
> >>Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> >  I agree with the change. It's true that we can leave some anonymous
> >pages behind and it's nicer to the MM to release them earlier when we
> >know they will be never needed again. The patch looks fine to me, you
> >can add
> >  Acked-by: Jan Kara <jack@suse.cz>
> 
> Thank you for confirming.
  Please keep me CCed (use group reply), thanks. I sometimes don't have
time for reading mailing lists or just skim through them so I can easily
miss replies...

> >  How much have you stressed the patched kernel? I suggest you use
> >fsxlinux and put some memory pressure to the system...
> 
> I have stressed it for 72 or more hours.
> Stresser does:
>  - allocates/frees big memory(1.7GB) which was almost system
>    memory size(2GB) repeatedly.
  OK, I suppose you also wrote something to the memory (otherwise it
won't be really allocated).

> Confirmation of integrity of patched Filesystem(jbd) does:
>  - creates files, and copies 3 files from created each file
>    (3 copies run concurrently), and confirms whether there is
>    no difference between created files and copied files.
>  (20 processes runs these works concurrently and repeatedly.)
> Above 2 jobs run concurrently.
  This sounds reasonable. fsxlinux does actually something similar but
it also stresses mmaped accesses and truncate patch. In this case, what
you did should be enough.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
