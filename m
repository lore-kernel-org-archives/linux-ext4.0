From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Sat, 19 Apr 2008 13:44:51 +0400
Message-ID: <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
	 <20080419012952.GE25797@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Rik van Riel" <riel@surriel.com>
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:35985 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYDSJow (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Apr 2008 05:44:52 -0400
Received: by wa-out-1112.google.com with SMTP id m16so1514842waf.23
        for <linux-ext4@vger.kernel.org>; Sat, 19 Apr 2008 02:44:51 -0700 (PDT)
In-Reply-To: <20080419012952.GE25797@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 19, 2008 at 5:29 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Apr 18, 2008 at 06:20:14PM +0400, Alexey Zaytsev wrote:
>  > Hello, guys.
>  >
>  > It seems like the Linux-fountation was not able to find a mentor for
>  > my project. If somebody is willing to mentor this project through the
>  > Google Summer of Code, please contact Rik and me now, as little
>  > time is left.
>  >
>  > A link to the application:
>  > http://rom.etherboot.org/share/xl0/gsoc2008/application-linux-foundation.txt
>
>  Hi Alexey,
>
>  I really don't think your project is likely to be successful given the
>  3 month timeframe of a GSoC.  At least not without a mentor spending
>  vast amounts of time educating you about how things works within ext2
>  and e2fsck.  Even given some broad hints about problems that you need
>  to address, you still have not addressed how you will solve
>  fundamental race conditions resulting from trying to read the multiple
>  blocks scattered all over the disk which comprise allocation bitmap
>  blocks while allocations might be taking place, for example.
>
>  Your approach of monitoring writes to the buffer cache for metadata
>  writes is completely busted; suppose the kernel modifies block #12345
>  in the filesystem; how do you know what that means?  Could that be an
>  indirect block?  If so, to which inode does it belong?

Sorry, I still don't understand where the problem is.

If it is a block containing a metadata object fsck has already read, than we
already know what kind of object it is (there must be a way to quickly find all
cached objects derived from a given block), and can update the cached
version. And if fsck has not yet read the block, it can just be ignored, no
matter what kind of data it contains. If it contains metadata and fsck is
intrested in it, it will read it sooner or later anyway. If it
contains file data, why
should fsck even care?

And you are wrong if you think this problem never came to me. This is in fact
what motivated the design, and there is no coincidence it is not affected.
(well, at least I think it is not affected).

But you are probably right, this project may be not doable in just three
months. The changes on the kernel side probably are, but there is a
huge e2fsck work.

>  If all you are
>  doing is monitoring metadata blocks, you would have no idea!  The fact
>  that it apparently didn't even occur to you that this might be a
>  show-stopping problem scares the heck out of me.  It leads me to
>  believe that this project is very likely to fail, and/or will require
>  vast amounts of time from the mentor.  Unfortunately, the former is
>  something that I just don't have this summer.
>
>  Regards,
>
>                                                 - Ted
>
