From: Jan Kara <jack@suse.cz>
Subject: Re: ext2 issues with xfstests 113
Date: Mon, 31 May 2010 23:31:01 +0200
Message-ID: <20100531213101.GJ5334@quack.suse.cz>
References: <20100531094625.GA10283@lst.de>
 <20100531175747.GD5334@quack.suse.cz>
 <20100531180101.GA32160@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59886 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0EaVbS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 17:31:18 -0400
Content-Disposition: inline
In-Reply-To: <20100531180101.GA32160@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 31-05-10 20:01:01, Christoph Hellwig wrote:
> On Mon, May 31, 2010 at 07:57:47PM +0200, Jan Kara wrote:
> >   Are you able to reproduce this? Because for me ext2 runs went just
> > fine...
> 
> I've done a couple of runs both on current mainline and the 2.6.34
> based XFS tree and they all show this problem.
  Hmm, interesting because I've run test 113 again with a kernel somewhere
between 2.6.34 and 2.6.35-rc1 and the filesystem is clean. So probably you
are able to hit some kind of race I'm not able to. Could you check whether
the corruption is caused by the O_DIRECT run or some other one?
  Also could you get "e2image -r" of the filesystem, bzip2 it and put it
somewhere for download?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
