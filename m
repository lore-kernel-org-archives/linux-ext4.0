From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: "make check" broken on maint branch?
Date: Mon, 4 Nov 2013 14:20:40 +0800
Message-ID: <20131104062039.GA3265@gmail.com>
References: <CE98293A.7BB07%andreas.dilger@intel.com>
 <20131101023556.GA28605@gmail.com>
 <20131101032115.GA14263@thunk.org>
 <20131101131237.GA9092@gmail.com>
 <20131101164834.GA28988@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35246 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3KDGSO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Nov 2013 01:18:14 -0500
Received: by mail-pb0-f52.google.com with SMTP id rr4so276438pbb.11
        for <linux-ext4@vger.kernel.org>; Sun, 03 Nov 2013 22:18:14 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131101164834.GA28988@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 01, 2013 at 12:48:34PM -0400, Theodore Ts'o wrote:
> On Fri, Nov 01, 2013 at 09:12:37PM +0800, Zheng Liu wrote:
> > > Hmm.... it works for me.  Run while r_64bit_big_expand is running:
> > > 
> > > % ls -l tmp
> > > ...
> > > 24896 -rw-r--r--. 1 tytso      tytso      2199023255552 Oct 31 23:17 e2fsprogs-tmp.pkOcCc
> > > ...
> > 
> > $ ls -l /tmp
> > -rw-rw-r-- 1 wenqing wenqing 536870912 Nov  1 21:03 e2fsprogs-tmp.x8yzKP
> 
> Well, I got this by running "./test_script r_64bit_big_expand" and
> then typing ^Z to stop the test mid-stream, and then looking in /tmp.

Thanks for letting me know.

> 
> But a simpler thing to do is to simply run the following commands:
> 
> truncate -s 2T /tmp/foo.img
> mke2fs -t ext4 -F /tmp/foo.img
> 
> ... and see if it works correctly.  I'm wondering if the problem is
> that a file limit was set, although that would result in a core dump:
> 
> % bash
> % ulimit -f 131072
> % truncate -s 2T /tmp/foo.img
> File size limit exceeded (core dumped)
> % exit
> 
> .... so that doesn't seem to be it.  Anyway, the problem seems to be
> that trying to create a sparse 2T file during the test is what's
> causing the problem that you and Andreas are seeing.  If this theory
> is question, the next question is what's causing the failure to write
> files whose i_size is greater than 2T.

It seems that I know the reason why tests failed.  That is because my
/tmp directory is a ext3 file system, and I couldn't create a big sparse
file like this 'truncate -s 2T /tmp/foo.img'.  So I did the following
test in my sand box.

% sudo mke2fs -t ext4 ${DEV} # I create a new ext4 file system
% sudo mount -t ext4 ${DEV} /tmp # mount this file system on /tmp
% sudo chmod 777 -R /tmp
% cd $E2FSPROGS
% make check

Then r_64bit_big_expand, r_bigalloc_big_expand and r_ext4_big_expand can
survive.  So I guess that the root cause is this.

Andreas, could you please confirm my guess?

BTW, after that, I still get a failure.  That is f_extent_oobounds.  So
we still need to take a closer look at this problem.

                                                - Zheng
