From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: "make check" broken on maint branch?
Date: Fri, 1 Nov 2013 21:12:37 +0800
Message-ID: <20131101131237.GA9092@gmail.com>
References: <CE98293A.7BB07%andreas.dilger@intel.com>
 <20131101023556.GA28605@gmail.com>
 <20131101032115.GA14263@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53599 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3KANKW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Nov 2013 09:10:22 -0400
Received: by mail-pd0-f172.google.com with SMTP id w10so3858578pde.31
        for <linux-ext4@vger.kernel.org>; Fri, 01 Nov 2013 06:10:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131101032115.GA14263@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 31, 2013 at 11:21:15PM -0400, Theodore Ts'o wrote:
> On Fri, Nov 01, 2013 at 10:35:56AM +0800, Zheng Liu wrote:
> > Hi Andreas,
> > 
> > On Thu, Oct 31, 2013 at 09:35:25PM +0000, Dilger, Andreas wrote:
> > > I tried to add in a "truncate -s $SIZE_2 $TMPFILE", but it complains that
> > > it
> > > isn't able to truncate the file in /tmp to 2TB:
> > > 
> > >   truncating `/tmp/e2fsprogs-tmp.OGxb09' at 2199023255552 bytes: File too
> > > large
> > > 
> > > Testing manually, it seems I'm not allowed to create a file in tmpfs larger
> > > than 256GB.  How large does this file need to be for this test to be valid?
> > > 
> > > Anyone else seen these problems, or do I need to dig in further?
> > 
> > Yes, I also can see these problems.
> 
> Hmm.... it works for me.  Run while r_64bit_big_expand is running:
> 
> % ls -l tmp
> ...
> 24896 -rw-r--r--. 1 tytso      tytso      2199023255552 Oct 31 23:17 e2fsprogs-tmp.pkOcCc
> ...

$ ls -l /tmp
-rw-rw-r-- 1 wenqing wenqing 536870912 Nov  1 21:03 e2fsprogs-tmp.x8yzKP

I am not sure that I do the right thing to get this result because the
tmporary files are removed after the test is done.  So what I only can
do is like this in a terminal during the test is running:
  while true
  do
          ls -l /tmp
          usleep 500
  done

Please let me know if I am wrong.

> 
> % df /tmp
> Filesystem     1K-blocks  Used Available Use% Mounted on
> tmpfs            3216420 26008   3190412   1% /tmp
> 
> What version of the kernel are you running?  I am using 3.12-rc5 plus
> the ext4 dev tree, so I'm using a pretty recent kernel.

I'm using 3.12-rc5 plus the ext4 dev tree too.  So I guess that the
difference between us is that I do these tests on a hard disk rather
than on tmpfs.

                                                - Zheng
