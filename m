From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block allocation
Date: Wed, 7 Mar 2012 12:14:43 +0800
Message-ID: <A2E616B7-79A5-4ECF-872F-A62ACA338C54@dilger.ca>
References: <20120305125029.GA5121@gmail.com> <20120307005130.GH3592@dastard>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57178 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417Ab2CGEOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 23:14:53 -0500
In-Reply-To: <20120307005130.GH3592@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-07, at 8:51 AM, Dave Chinner wrote:
> On Mon, Mar 05, 2012 at 08:50:29PM +0800, Zheng Liu wrote:
>> Block allocation is a key component of file system.  Every file systems try to
>> improve the performance with optimizing the block allocation of a file.  But no
>> matter what file system does, it just guesses what the user expects.  Thus, it
>> is not very accurate.  fadvise(2) provides a method to let the user to give a
>> hint to file system.  However, until now, only few flags are provided.  So we
>> can provide more flags to tell file system how to allocate the blocks for a
>> file.
>> 
>> For example:
>> we can add these flags into fadvise(2):
>> FADV_ALLOC_READ_SEQ
> 
> fallocate()

I think this is already the assumed default for any file IO, but is included for completeness (e.g. to be able to turn off READ_RANDOM).

>> FADV_ALLOC_READ_RANDOM
> 
> Allocation can't be optimised as the read pattern cannot be defined.

I think what this is intended for is to tell the filesystem "don't work very hard to find optimum allocation, it will have a random read pattern anyway".

>> FADV_ALLOC_WRITE_ONCE
> 
> fallocate()
> 
>> FADV_ALLOC_WRITE_APPEND
> 
> chattr +a

and/or fallocate(KEEP_SIZE)

Having a consistent API definitely makes sense.

This proposal definitely needs to have some clear explanation of how the flags are intended to be used by applications, and why they will help filesystems to improve allocation.  I'm not for adding gratuitous APIs, but at the same time I think that filesystems are often working in the dark and could benefit from more information being passed from the application.

Cheers, Andreas





