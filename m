From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [RESEND] [PATCH] lseek: change i_mutex usage.
Date: Fri, 16 Jan 2009 09:53:02 +0900
Message-ID: <6.0.0.20.2.20090116094630.06b202c0@172.19.0.2>
References: <6.0.0.20.2.20090115163853.07056ed0@172.19.0.2>
 <20090115132252.GZ29283@parisc-linux.org>
 <20090115142113.GD30522@mit.edu>
 <20090115164003.09c8c918.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: matthew@wil.cx, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:33113 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZAPAzt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Jan 2009 19:55:49 -0500
In-Reply-To: <20090115164003.09c8c918.akpm@linux-foundation.org>
References: <6.0.0.20.2.20090115163853.07056ed0@172.19.0.2>
 <20090115132252.GZ29283@parisc-linux.org>
 <20090115142113.GD30522@mit.edu>
 <20090115164003.09c8c918.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


At 09:40 09/01/16, Andrew Morton wrote:
>On Thu, 15 Jan 2009 09:21:13 -0500
>Theodore Tso <tytso@mit.edu> wrote:
>
>> On Thu, Jan 15, 2009 at 06:22:52AM -0700, Matthew Wilcox wrote:
>> > 
>> > Of course if you have multiple threads, they will share a struct file,
>> > and you're updating f_pos and f_version without locking.  Maybe that's
>> > OK, but it's soemthing you didn't discuss.
>> 
>> f_pos is updated by sys_write(), and friends without locking, so we're
>> fine on that front, or at least no worse off.
>
>bug ;)
>
>>  SUSv3 doesn't seem to
>> say one way or another what should happen if two threads try to
>> write() to a file at the same time using the same file descriptor in
>> terms of whether or not f_pos gets updated intelligently.  We've opted
>> for speed over determinism already.
>
>I think our thinking was that if two threads are racily updating f_pos
>with different values, then it should end up with one of those values.
>
>From a quality-of-implementation POV (what _is_ that, anyway) it would
>be bad if the kernel were to set f_pos to the upper 32 bits of position
>A and the lower 32 bits of position B.  Which could happen if we remove
>the i_mutex protection on 32-bits.
>
>We could perhaps omit some locking if CONFIG_64BIT.  There's probably
>quite a bit of locking which could be omitted in that case.

Updating f_pos value on 32bit is not atomic, so we discussed about this
but we concluded that it does not matter whether f_pos is atomic or not
See,
Subject:[RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
http://marc.info/?l=linux-fsdevel&m=122335627224515

I think even i_mutex is not needed. When we touch i_size, i_size_read is enough,
and we can remove i_mutex at all on lseek.


