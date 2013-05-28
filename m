From: Jan Kara <jack@suse.cz>
Subject: Re: Why does journal mode outperforms all other modes when reading
 and writing data at the same time?
Date: Tue, 28 May 2013 18:14:18 +0200
Message-ID: <20130528161418.GD27920@quack.suse.cz>
References: <CANPB7a4A+CbRcNoDc2=G=u8zy+q7ky=pGQxAMJrbxPC3sfytjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jingguo yao <yaojingguo@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934710Ab3E1QOU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 12:14:20 -0400
Content-Disposition: inline
In-Reply-To: <CANPB7a4A+CbRcNoDc2=G=u8zy+q7ky=pGQxAMJrbxPC3sfytjw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 28-05-13 22:39:18, jingguo yao wrote:
> Documentation/filesystems/ext4.txt has the following sentence:
> 
>   This mode is the slowest except when data needs to be read from and
>   written to disk at the same time where it outperforms all others
>   modes.
> 
> And the following link talks about it in more details. Can anybody give
> the reason?
> 
> http://www.ibm.com/developerworks/library/l-fs8/index.html#4
  Not sure why exactly data=journal was faster in that workload. But
generally data=journal is known to help if you have shortlived files which
are then written only to the journal and deleted before they are copied to
the final location on disk. Also it may help by penalizing the writer so
that readers have better chance to do their work...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
