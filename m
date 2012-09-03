From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: support online-resizing for meta_bg and
 64bits features
Date: Sun, 2 Sep 2012 20:50:05 -0400
Message-ID: <20120903005005.GA4324@thunk.org>
References: <1346579549-25122-1-git-send-email-xiaoqiangnk@gmail.com>
 <CAGBYx2bobtLQmtexLtVCXSQBpK5-4-4q3MHS3bXcew=iKRhqig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48486 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab2ICAuK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Sep 2012 20:50:10 -0400
Content-Disposition: inline
In-Reply-To: <CAGBYx2bobtLQmtexLtVCXSQBpK5-4-4q3MHS3bXcew=iKRhqig@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 02, 2012 at 06:31:19PM +0800, Yongqiang Yang wrote:
> Hi Ted,
> 
>     I noticed that you send out the patch enabling resizing on
> filesystems with meta_bg and 64bits, so I send out the corresponding
> patch on e2fsprogs.  Unfortunately, there is still a bug in e2fsprogs
> as my last email says.

Great, thanks, I'll take a look at it.  I've made some changes of my
own in resize2fs to enable using meta_bg && flex_bg && !resize_inode,
but it isn't fully done yet, so I hadn't sent them out.  (I must have
missed your initial patch to resize2fs to enable things for testing
purposes, but it's not that hard.)

I'm guessing you must have only tested relatively small increases in
the file system size when you were developing your kernel patch set.
I was doing tests using a 1k block size with "mke2fs -t ext4 -b 1024
-O meta_bg,64bit,^resize_inode /dev/vdd 256000" and then growing the
file system from 243M to 5G, which increased the number of meta_bg's
from 2 to 40 meta_bg's.  I also tried using the MKE2FS_FIRST_META_BG
environment variable to emulate a file system which was originally
grown using resize_inode scheme, and then later converted over to the
meta_bg scheme.  All of this flushed out a number of bugs in your
original patch series, which I've fixed up.

Anyway, the reason why I haven't released the changes I had made to
resize2fs is I know there are still some fixes needed so that we can
transition a file system from resize_inode to meta_bg once we run out
of reserved gdt blocks, and I need to test what happens with file
systems that are greater than 16TB --- so far, my testing has been
with smaller file systems, and since I was still finding things to
fix, I haven't progressed yet to testing really big file systems.

We will probably also want to advertise a flag indicating that the
kernel will support meta_bg resizing, and then allow mke2fs to use
meta_bg by default (even for file systems < 16TB) since it has much
less overhead and doesn't have the fixed limits that the original
resize_inode has.

So there is still some work that we need to do to improve the online
resizing, but what we have so far is a very good start, and your
patches definitely helped to push us forward.  My apologies for not
having the time to really seriously finish things up until now, but
hopefully we'll be able to get something fully robust and tested soon
(realistically speaking, looking at the likely release schedules for
the kernel and e2fsprogs, I'm shooting for getting this all done
before the end of the year).

Regards,

					- Ted
