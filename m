From: Jan Kara <jack@suse.cz>
Subject: Re: ext2 issues with xfstests 113
Date: Tue, 1 Jun 2010 15:08:37 +0200
Message-ID: <20100601130837.GF4275@quack.suse.cz>
References: <20100531094625.GA10283@lst.de>
 <20100531175747.GD5334@quack.suse.cz>
 <20100531180101.GA32160@lst.de>
 <20100531213101.GJ5334@quack.suse.cz>
 <20100601090337.GA28085@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125Ab0FANIu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 09:08:50 -0400
Content-Disposition: inline
In-Reply-To: <20100601090337.GA28085@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 01-06-10 11:03:37, Christoph Hellwig wrote:
> On Mon, May 31, 2010 at 11:31:01PM +0200, Jan Kara wrote:
> >   Hmm, interesting because I've run test 113 again with a kernel somewhere
> > between 2.6.34 and 2.6.35-rc1 and the filesystem is clean. So probably you
> > are able to hit some kind of race I'm not able to. Could you check whether
> > the corruption is caused by the O_DIRECT run or some other one?
> 
> 113 is an AIO test, so it must be using O_DIRECT.
  Now I see that the third run of aio-stress failed so yes, it's using
O_DIRECT.

> >   Also could you get "e2image -r" of the filesystem, bzip2 it and put it
> > somewhere for download?
> 
> I've jyst attached it as the compressed version is small enough (88k).
  I've looked at the image and for both corrupted inodes it looks as if
we didn't write double-indirect block. The blocks which should be
presumably referenced from it are properly allocated so it couldn't be just
truncated or so. I've tried to reproduce the problem on another machine but
failed... Is there anything special in your setup? Also are there any
messages in the kernel log?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
