From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Sat, 18 Jun 2011 11:15:31 -0600
Message-ID: <A947D80A-0C4E-4079-B233-E890677BFDEF@dilger.ca>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org> <4DFB62C7.5070008@redhat.com> <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com> <BANLkTimZ1fhzgZiqe0Zamyt1yTV5LrHKFA@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, Ted Ts'o <tytso@mit.edu>,
	Kazuya Mio <k-mio@sx.jp.nec.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:5474 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1FRRPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jun 2011 13:15:15 -0400
In-Reply-To: <BANLkTimZ1fhzgZiqe0Zamyt1yTV5LrHKFA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-18, at 11:00 AM, Greg Freemyer <greg.freemyer@gmail.com> wrote:
> On Sat, Jun 18, 2011 at 3:19 AM, Andreas Dilger <aedilger@gmail.com> wrote:
>> I was thinking about this, and am wondering if it makes sense to have an absolute score for fragmentation instead of a relative one?
>> 
>> By absolute I mean something like fragments per MB or similar. A bad score might be anything > 1. For files smaller than 1 MB in size it would scale the ratio to the equivalent if the file was 1MB in size (e.g. a 16kB file with 4 fragments would have a score of 256, which is clearly bad).  Large files can have a score much less than 1, which is good.
>> 
>> Cheers, Andreas
> 
> Shouldn't be based on fragments per max extent size for ext4?
> 
> And I think the max extent size for a 4KB page is 128 MB, right?

I was thinking about that, but in most cases it is unrealistic that all files have 128MB extents except on empty test filesystems, and I don't think that files with "only" 32MB extents should be considered that badly off.

I don't particularly care what the exact scale is, but I like the idea of an absolute measure instead of a relative measure (i.e. 33% fragmented).

Cheers, Andreas