From: "Alexey Salmin" <alexey.salmin@gmail.com>
Subject: Re: Maximum filename length
Date: Sun, 23 Nov 2008 00:48:25 +0600
Message-ID: <87a8dc10811221048t27b0c6dx253bed61418389e8@mail.gmail.com>
References: <87a8dc10811210451p3ec1e3dar371a3ebffcedcdc@mail.gmail.com>
	 <20081121223248.GA22671@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:27131 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYKVSs2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Nov 2008 13:48:28 -0500
Received: by ug-out-1314.google.com with SMTP id 39so420059ugf.37
        for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 10:48:25 -0800 (PST)
In-Reply-To: <20081121223248.GA22671@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/11/22 Theodore Tso <tytso@mit.edu>:
> It wouldn't be _that_ hard to add an extension to ext4 to support
> longer filenames (it would mean a new directory entry format, and a
> way of marking a directory inode as to whether the old or new
> directory format was being used).  Unfortunately, the 255 byte limit
> is encoded not only in the filesystem, but also in the kernel.
> Changing it in the kernel is not just a matter of a #define constant,
> but also fixing places which put filename[NAME_MAX] on the stack, and
> where increasing NAME_MAX might cause kernel functions to blow the
> limited stack space available to kernel code.  In addition, there are
> numerous userspace and in some cases, protocol limitations which
> assume that the total overall length of a pathname is no more than
> 1024 bytes.  (I suspect there is at least userspace code that also
> would blow up if an individual pathname exceeded NAME_MAX, or 256
> bytes.)
>

Sure, I understand the problems you've mentioned. But every big act
has the beginning. Adding the extension to the ext4 is only the first
step. Of course it'll cause crashes and other problems in many places
from kernel to userspace code. But these problems will disturb only
people who will really use this extension (like me). Anyway most of these
bugs will be fixed some day, may be in two or three years. No one is
talking that it's a fast process but it will reach it's end and that's good
I think.

> I will say personally that its rare for me to use filenames longer
> than 50-60 characters, just because they are a pain in the *ss to
> type.  However, I can see how someone using a graphical interface
> might be happy with filenames in the 100-120 character range.

Same here: most of my filenames are _way_ shorter than 50-60
characters. Besides, I really use English filenames almost always.
But there are some cases when long Cyrillic names are needed and
it's sad for me to have problems here.

Alexey
