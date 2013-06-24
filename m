From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: 3.9-rc6 ext4: free_rb_tree_fname oops
Date: Mon, 24 Jun 2013 21:28:04 +0800
Message-ID: <20130624132804.GA7709@gmail.com>
References: <CAMVG2sskpWgL4JLKZZs8YXqNoLt4gB-UgeeMPnb8bTDKyUeRng@mail.gmail.com>
 <CAMVG2ssG0PvedeuT6f3g=20Gv51f6gXWxxMFbtL4H=ngAJ9Gvg@mail.gmail.com>
 <20130624123726.GA17012@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel J Blueman <daniel@quora.org>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37083 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FXNJg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jun 2013 09:09:36 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp12so10981494pab.35
        for <linux-ext4@vger.kernel.org>; Mon, 24 Jun 2013 06:09:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130624123726.GA17012@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 24, 2013 at 08:37:26AM -0400, Theodore Ts'o wrote:
> (LKML and Linux-fsdevel moved to bcc)
> 
> On Mon, Jun 24, 2013 at 02:34:00PM +0800, Daniel J Blueman wrote:
> > On 16 April 2013 15:37, Daniel J Blueman <daniel@quora.org> wrote:
> > > When using e4defrag on a ext4 filesystem created a month ago, I ran
> > > into this fatal page fault [1]
> > >  while running e4defrag on 3.9-rc6 (Ubuntu mainline).
> > >
> > > e2fsdump output is at http://quora.org/2012/e2fsdump.txt ; let me know
> > > if you need any more info.
> > 
> > With 3.9.6 mainline, I got the exact same protection fault at
> > free_rb_tree_fname() from ext4_htree_free_dir_info() [1]. This
> > suggests use-after-free, as there's no pagetable mapping.
> > 
> > There is nothing special with my setups, so there is fair chance it's
> > reproducible there with e4defrag on a few month old filesystem and
> > recent kernels.
> 
> Sounds like we may have a bug in how the new extent_status tree code
> was integrated into fs/ext4/move_extent.c.  Zheng, if you could take a
> look I'd really appreciate it.

Sorry for the late reply.  I will take a close look at this bug.

Regards,
                                                - Zheng
