From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V2] fix type of "offset" in ext4_io_end
Date: Fri, 05 Feb 2010 09:50:52 -0600
Message-ID: <4B6C3E5C.4080907@redhat.com>
References: <4B6327C4.4000100@redhat.com> <4B6344E7.9050503@redhat.com> <20100205133751.GO25885@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>, fmayhar@google.com,
	Giel de Nijs <giel@vectorwise.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab0BEPvR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2010 10:51:17 -0500
In-Reply-To: <20100205133751.GO25885@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Fri, Jan 29, 2010 at 02:28:23PM -0600, Eric Sandeen wrote:
>> The "offset" member in ext4_io_end holds bytes, not
>> blocks, so ext4_lblk_t is wrong - and too small (u32)
>>
>> This caused the testcase "Possible ext4 data corruption
>> with large files and async I/O" sent by Giel to fail when it
>> wrapped around to 0.
>>
>> Also fix up the type of arguments to
>> ext4_convert_unwritten_extents(), it gets ssize_t from
>> ext4_end_aio_dio_nolock() and ext4_ext_direct_IO()
>>
>> Reported-by: Giel de Nijs <giel@vectorwise.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> So I was going to submit this patch to Linus, but the last two times
> I've run xfsqa ("xfsqa -g quick" and "xfsqa -g auto"), test #126 has
> failed.  If I run the test stand-alone, it passes.  It's a bit of a
> head-scratcher.  I'm currently backing out the patch and trying to do
> an xfsqa -g auto run to make sure this was something that had crept in
> before applying this patch, so this may very well not be this patch
> --- I certainly can't see anything wrong with it.  But I thought I
> would give a heads up....
> 
>       	     	       	       	      	   	- Ted

hrm 126 is a permissions test, I can't imagine it'd be related...

I see it fail on a sorta-stock .32 kernel like this:

--- 126.out	2009-08-05 20:19:40.380978986 -0500
+++ 126.out.bad	2010-02-05 09:01:13.088372667 -0600
@@ -5,7 +5,7 @@
 w a 002 file owned by (99/99) as user/group(12/100)  PASS
 w a 020 file owned by (99/99) as user/group(200/99)  PASS
 w a 200 file owned by (99/99) as user/group(99/500)  PASS
-r a 004 file owned by (99/99) as user/group(12/100)  PASS
+r a 004 file owned by (99/99) as user/group(12/100)  FAIL
 r a 040 file owned by (99/99) as user/group(200/99)  PASS
 r a 400 file owned by (99/99) as user/group(99/500)  PASS
 r a 000 file owned by (99/99) as user/group(99/99)  FAIL


What's your failure?

-Eric
