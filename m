From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V2] filefrag: count 0 extents properly when verbose
Date: Sat, 7 May 2011 21:35:19 -0600
Message-ID: <C30EEA83-4D04-44BE-A21E-696A6A4A735A@dilger.ca>
References: <4CEC4C86.1030806@redhat.com> <4D9F3B71.2050808@redhat.com> <569EBA4C-A6BB-4E64-88B9-F2F946891B56@dilger.ca> <4DC2EA94.8040100@redhat.com> <20110507224524.GB6046@thunk.org>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from to5email.gprs.rogers.com ([74.198.8.2]:56837 "EHLO
	to5email2.gprs.rogers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1EHDzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 May 2011 23:55:13 -0400
In-Reply-To: <20110507224524.GB6046@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was going to comment on this on Friday and supply a new patch but got distracted. There is actually a cleaner way to implement this, by initializing the extent count to zero, and always incrementing it inside the inner loop. That simplifies the case when there are no extents returned by FIEMAP.

I'm sure I'll get around to sending an updated patch at some point, and will clean up this section at the same time. 

Cheers, Andreas

On 2011-05-07, at 4:45 PM, Ted Ts'o <tytso@mit.edu> wrote:

> On Thu, May 05, 2011 at 01:21:08PM -0500, Eric Sandeen wrote:
>> # rm -f a; touch a; filefrag a
>> /boot/a: 0 extents found
>> 
>> works properly, but
>> 
>> # rm -f a; touch a; filefrag -v a
>> Filesystem type is: ef53
>> Filesystem cylinder groups is approximately 61
>> File size of a is 0 (0 blocks, blocksize 1024)
>> ext logical physical expected length flags
>> a: 1 extent found
>> 
>> yields 1 extent when it should be 0.
>> 
>> Fix this up by special-casing no extents returned in verbose
>> mode; skip printing the header for the columns too, since there
>> are no columns to print.
>> 
>> Also, in nonverbose mode we can set fm_extent_count to 0
>> so that FIEMAP will just query the extent count without gathering
>> details; clarify this with a comment.
>> 
>> Addresses-redhat-bugzilla: 653234
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks, 
> 
> applied to the maint branch (which will then get pulled to
> master/next) of e2fsprogs.
> 
>                    - Ted
