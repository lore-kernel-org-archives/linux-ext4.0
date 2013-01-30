From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fallocate creating fragmented files
Date: Wed, 30 Jan 2013 00:05:39 -0600
Message-ID: <5108B833.6010004@redhat.com>
References: <1359524809.5789.140661184325217.261ED7C8@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Rob Mueller <robm@fastmail.fm>
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab3A3GFp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 01:05:45 -0500
In-Reply-To: <1359524809.5789.140661184325217.261ED7C8@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/29/13 11:46 PM, Bron Gondwana wrote:
> Hi All,
> 
> I'm trying to understand why my ext4 filesystem is creating highly fragmented files even though it's only just over 50% full.

It's at least possible that freespace is very fragmented; you could try the "e2freefrag" command to see.

<backgroun>

> Now we've got some background, let's create two files using the fallocate command line tool, and see where the blocks wound up.  This mirrors exactly the behaviour we have seen with both using posix_fallocate to pre-allocate space, or just using seek and writev to write individual records out to the file.  Except with the slower writes of a real application, we get closer to 9000 extents for a file this size.
> 
> [brong@imap14 conf]$ fallocate -l 20m testfile 
> [brong@imap14 conf]$ fallocate -l 20m testfile2
> [brong@imap14 conf]$ filefrag testfile
> testfile: 421 extents found
> [brong@imap14 conf]$ filefrag testfile2
> testfile2: 306 extents found
> 
> Now looking at the verbose output, we can see that there are many extents of just 3 or 4 blocks:
> 
> [brong@imap14 conf]$ filefrag -v testfile | awk '{print $5}' | sort -n | uniq -c | head
>       2 
>       1 is
>       1 length
>       1 unwritten
>       6 3
>      10 4
>       6 5
>       5 6
>       3 7
>       1 8

But longer extents too, right:

$ filefrag -v testfile | awk '{print $5}' | sort -n | uniq -c | tail
      1 162
      1 164
      1 179
      1 188
      1 215
      1 231
      1 233
      1 255
      1 322
      1 357

> Yet looking at the next file,
> 
> [brong@imap14 conf]$ filefrag -v testfile2 | awk '{print $5}' | sort -n | uniq -c | tail
>       1 173
>       1 175
>       1 178
>       1 184
>       1 187
>       1 189
>       1 194
>       1 289
>       1 321
>       1 330
> 

and presumably shorter extents at the beginning?

So it sounds like both files are a mix of long & short extents.

> There are multiple extents of hundreds of blocks in length.  Why weren't they used in allocating the first file?

I'm not sure, offhand.  But just to be clear, while contiguous allocations are usually a nice side-effect of fallocate, nothing at all guarantees it.  It only guarantees that you'll have that space available for future writes.

Still, it'd be interesting to figure out why the allocator is behaving this way.
It'd be interesting to see the freefrag info, the allocator might really be in scavenger mode.

-Eric

> This filesystem is quite busy all the time.  There are hundreds of imapd processes all locking and writing to it, including a lot of fdatasync and fsync calls.  During the time it took to run this command, there would have been multiple fsyncs.  I can't see why that would affect the allocator in this way for a single fallocate call though.
> 
> Regards,
> 
> Bron.


