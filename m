From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: "make check" broken on maint branch?
Date: Fri, 1 Nov 2013 12:48:34 -0400
Message-ID: <20131101164834.GA28988@thunk.org>
References: <CE98293A.7BB07%andreas.dilger@intel.com>
 <20131101023556.GA28605@gmail.com>
 <20131101032115.GA14263@thunk.org>
 <20131101131237.GA9092@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Dilger, Andreas" <andreas.dilger@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53316 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab3KAQsj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Nov 2013 12:48:39 -0400
Content-Disposition: inline
In-Reply-To: <20131101131237.GA9092@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 01, 2013 at 09:12:37PM +0800, Zheng Liu wrote:
> > Hmm.... it works for me.  Run while r_64bit_big_expand is running:
> > 
> > % ls -l tmp
> > ...
> > 24896 -rw-r--r--. 1 tytso      tytso      2199023255552 Oct 31 23:17 e2fsprogs-tmp.pkOcCc
> > ...
> 
> $ ls -l /tmp
> -rw-rw-r-- 1 wenqing wenqing 536870912 Nov  1 21:03 e2fsprogs-tmp.x8yzKP

Well, I got this by running "./test_script r_64bit_big_expand" and
then typing ^Z to stop the test mid-stream, and then looking in /tmp.

But a simpler thing to do is to simply run the following commands:

truncate -s 2T /tmp/foo.img
mke2fs -t ext4 -F /tmp/foo.img

... and see if it works correctly.  I'm wondering if the problem is
that a file limit was set, although that would result in a core dump:

% bash
% ulimit -f 131072
% truncate -s 2T /tmp/foo.img
File size limit exceeded (core dumped)
% exit

.... so that doesn't seem to be it.  Anyway, the problem seems to be
that trying to create a sparse 2T file during the test is what's
causing the problem that you and Andreas are seeing.  If this theory
is question, the next question is what's causing the failure to write
files whose i_size is greater than 2T.

					- Ted
