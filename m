From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: 3.9-rc6 ext4: free_rb_tree_fname oops
Date: Wed, 10 Jul 2013 10:06:41 +0800
Message-ID: <20130710020641.GA8523@gmail.com>
References: <CAMVG2sskpWgL4JLKZZs8YXqNoLt4gB-UgeeMPnb8bTDKyUeRng@mail.gmail.com>
 <CAMVG2ssG0PvedeuT6f3g=20Gv51f6gXWxxMFbtL4H=ngAJ9Gvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64123 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3GJBsB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jul 2013 21:48:01 -0400
Content-Disposition: inline
In-Reply-To: <CAMVG2ssG0PvedeuT6f3g=20Gv51f6gXWxxMFbtL4H=ngAJ9Gvg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Daniel,

On Mon, Jun 24, 2013 at 02:34:00PM +0800, Daniel J Blueman wrote:
> On 16 April 2013 15:37, Daniel J Blueman <daniel@quora.org> wrote:
> > When using e4defrag on a ext4 filesystem created a month ago, I ran
> > into this fatal page fault [1]
> >  while running e4defrag on 3.9-rc6 (Ubuntu mainline).
> >
> > e2fsdump output is at http://quora.org/2012/e2fsdump.txt ; let me know
> > if you need any more info.
> 
> With 3.9.6 mainline, I got the exact same protection fault at
> free_rb_tree_fname() from ext4_htree_free_dir_info() [1]. This
> suggests use-after-free, as there's no pagetable mapping.
> 
> There is nothing special with my setups, so there is fair chance it's
> reproducible there with e4defrag on a few month old filesystem and
> recent kernels.

These days I try to reproduce this bug, but unfortunately I couldn't
hit it.  I create/read/write/delete some files in a SSD disk to simulate
a file system that has been used for a while.  Then I use e4defrag to
defrag this file system.  But I couldn't trigger the bug.  The kernel
version is the latest ext4/dev branch, and the e2fsprgs version is the
1.42.7.  Do you have a method to easily reproduce this bug?

Thanks,
                                                - Zheng
