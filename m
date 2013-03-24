From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Do not normalize request from fallocate
Date: Sat, 23 Mar 2013 19:42:39 -0700
Message-ID: <B8FBA63B-2106-4119-A699-C3407C491A8D@dilger.ca>
References: <1363881045-21673-1-git-send-email-lczerner@redhat.com> <20130324001143.GB4000@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"gharm@google.com" <gharm@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51901 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab3CXCmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Mar 2013 22:42:44 -0400
Received: by mail-pa0-f43.google.com with SMTP id rl6so499201pac.16
        for <linux-ext4@vger.kernel.org>; Sat, 23 Mar 2013 19:42:43 -0700 (PDT)
In-Reply-To: <20130324001143.GB4000@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-03-23, at 17:11, Theodore Ts'o <tytso@mit.edu> wrote:

> On Thu, Mar 21, 2013 at 04:50:45PM +0100, Lukas Czerner wrote:
>> 
>> Commit 3c6fe77017bc6ce489f231c35fed3220b6691836 mentioned that
>> large fallocate requests were not physically contiguous. However it is
>> important to see why that is the case. Because the request is so big the
>> allocator will try to find free group to allocate from skipping block
>> groups which are used, which is fine. However it will only allocate
>> extents of 2^15-1 block (limitation of uninitialized extent size)
>> which will leave one block in each block group free which will make the
>> extent tree physically non-contiguous, however _only_ by one block which
>> is perfectly fine.
> 
> Well, it's actually really unfortunate.  The file ends up being more
> fragmented, and from an alignment point of view it's really horrid.

I was also wondering about this. 

> So I agree that what we're doing is poor, but the question is, can we
> do something which is better that either of these two results?

One option is to allocate a 32768-block in allocated extent and then write a 1-block zeroed-out extent. But, that would still cause a lot of seeks to write the single-block IO.  

> That is, can we improve mballoc so that we keep an fallocated gigabyte
> file as physically contiguous as possible, while using an optimal
> number of on-disk extents?   i.e., 9 extents of length 32767.
> 
> Failing that, can we create 20 extents of length 16384 or so?

I think this is probably the best compromise. It also improves then case for converting unwritten extents when overwriting the file, since it would be possible to merge the remaining fragments to the neighboring unwritten extents.

In the latter regard, it might be optimal to allocate approximately 32768/3 or 12288-block extents, since it would always allow merging fragments on both sides of an extent, if needed. 

Cheers, Andreas