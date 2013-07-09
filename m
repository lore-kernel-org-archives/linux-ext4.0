From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510
Date: Mon, 8 Jul 2013 21:06:58 -0700
Message-ID: <20130709040658.GA7763@roeck-us.net>
References: <20130708183829.GA3205@roeck-us.net>
 <20130709033510.GE6000@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47842 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3GIEHB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jul 2013 00:07:01 -0400
Received: by mail-pd0-f170.google.com with SMTP id x11so4822843pdj.1
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jul 2013 21:07:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130709033510.GE6000@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 08, 2013 at 11:35:10PM -0400, Theodore Ts'o wrote:
> On Mon, Jul 08, 2013 at 11:38:29AM -0700, Guenter Roeck wrote:
> > Hi,
> > 
> > seen this morning with a brand new top-of-tree kernel (as of last night) plus a
> > couple of patches I am working on.
> > 
> > Due to my changes, there is a slight chance that the problem is not due to an
> > upstream bug, but I think that is quite unlikely (my changes are unrelated
> > to file system code).
> > 
> > If there is anything I can help to track this down, please let me know.
> > 
> > [13071.291013] ------------[ cut here ]------------
> > [13071.291021] WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510()
> 
> Hmm, this warning was added by commit 5dc23bdd5: ext4: remove
> ext4_ioend_wait().
> 
> What sort of work load are you running on this machine?  Do you know
> what might have triggered it?
> 
My nightly kernel builds were running at the time. This is a sequence of git
clone/checkout operations followed by builds for several targets.

I have the same kernel running on three systems, but this only happened on the
build machine, and I have not seen it again during the day.

I'll let you know if it happens again tonight.

Guenter
