From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Minimizing fragmentation in ext4, fallocate not enough?
Date: Sat, 25 Sep 2010 12:26:15 -0500
Message-ID: <4C9E30B7.1050607@redhat.com>
References: <4C9D3CD6.9080000@mozilla.com> <7A56949B-99B6-439F-A015-1C0398A8B525@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Taras Glek <tglek@mozilla.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0IYR0W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Sep 2010 13:26:22 -0400
In-Reply-To: <7A56949B-99B6-439F-A015-1C0398A8B525@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2010-09-24, at 18:05, Taras Glek wrote:
>> I noticed that several random IO-heavy Firefox files got fragmented
>> easily. Our cache suffers most. The cache works by creating a flat
>> file and storing fixed-size entries in it. I though if I
>> fallocate() the file first, then all of the writes within the
>> allocated area would not cause additional fragmentation.
>> 
>> This doesn't seem to completely cure fragmentation with ext4 in
>> 2.6.33. If I allocate a 4mb file, it gets more and more fragmented
>> over time. fallocate() does reduce fragmentation, but not as much
>> as I expected.
> 
> Have you checked filefrag immediately after fallocating the file?  Is
> it OK?
> 
> It may be that the issue is that an fallocate()'d file is using
> "unwritten extents" and converting these extents to "normal" extents
> may cause apparent fragmentation.  However, depending on which
> version of e2fsprogs/filefrag you are using, it may well be that
> these extents only appear to be fragmented due to the different
> extent types.

Agreed, please include filefrag (-v) output right after it's fallocated,
and also when you see this fragmentation, and then we'll have a better idea
about what you're seeing.  And, the newer the filefrag the better.  :)

-Eric

>> ps2. Does running filefrag on a directory mean anything in ext4?
> 
> With newer e2fsprogs using FIEMAP and kernels it should be possible
> to get useful filefrag data from a directory.  Older
> kernels/e2fsprogs using FIBMAP will just fail outright. 

