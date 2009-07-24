From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How to fix up mballoc
Date: Thu, 23 Jul 2009 21:25:59 -0500
Message-ID: <4A691BB7.60802@redhat.com>
References: <20090721001750.GD4231@webber.adilger.int> <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com> <20090723134538.GC8040@mit.edu> <4A68A153.8030804@redhat.com> <20090724002317.GA14052@mit.edu> <4A6919F3.90103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZGXC0X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2009 22:26:23 -0400
In-Reply-To: <4A6919F3.90103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Theodore Tso wrote:
>> On Thu, Jul 23, 2009 at 12:43:47PM -0500, Eric Sandeen wrote:
>>>> 1) In ext4_mb_normalize_request(), if the inode that we are allocating
>>>> does not have any open file descriptors for write (i.e., it's already
>>>> closed and we're allocating via delalloc) _and_ the inode was
>>>> previously opened with O_CREAT and without O_APPEND (checked via a
>>>> flag in EXT4_I(inode)), then do not normalize the size to a power of
>>>> two, but rather to the filesystem blocksize.
>>> I'm sort of woefully ignorant of a lot of the mballoc stuff.
>>>
>>> When you say once a file is written that's probably the final size... do
>>> you mean when writes are done and it's closed, or when the first write
>>> to the file is complete?
>>>
>>> I think an awful lot of normal cases write to a file in sub-file-sized
>>> chunks (think mp3 or flac encoding, file downloading, etc).
>> I meant when the writes are done and the files are closed; hence my
>> proposal that we do this do #1 above only if there are no open file
>> descriptors for write.  That is, if the file can be written and closed
>> by the userspace process before any delayed allocation blocks are
>> attempted to be written by the filesystem, we can probably safely
>> assume that the file won't grown in size later on.
> 
> Ah, ok.  Sorry, I misunderstood.  Yep, that seems reasonable.
> 
> It should probably get tested with workloads like video transcoding,
> where there will be incremental writes that span many minutes or hours.

Ugh right after I sent this I think I'm finally making sense of it.  :)
 In that case, come allocation time there =would= be file descriptors
open, and we'd go back to the old method of normalizing the allocation.
 You're just talking about changing things where an entire series of
file writes have come & gone, everything is closed & done, and -now-
we're allocating.

Sorry for being slow.  :)

-Eric
