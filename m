From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 recovery, the saga of 16777215 continues
Date: Fri, 13 Sep 2013 22:18:18 -0400
Message-ID: <20130914021818.GA1112@thunk.org>
References: <CA+qGm=_vV3xv8ip6JfuW7hDo3ZgR5Bj4oA_1r0BPD33rAso0Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Alexander Harrowell <a.harrowell@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59957 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab3INCSV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Sep 2013 22:18:21 -0400
Content-Disposition: inline
In-Reply-To: <CA+qGm=_vV3xv8ip6JfuW7hDo3ZgR5Bj4oA_1r0BPD33rAso0Jg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 13, 2013 at 03:40:47PM +0000, Alexander Harrowell wrote:
> OK, so after updating e2fsprogs and doing a bunch of hacking around, I
> was eventually able to find the inode that returns hundreds of MB of
> 16777215 in the multiply-claimed blocks pass.
> 
> Dumping it out with debugfs, the output file reached 28 GB before the
> device receiving ran out of space. I thought inodes were of defined
> size?

What do you mean by "dumping it out"?  What precise debugfs command
were you using?

stat?  dump?  something else?

						- Ted
