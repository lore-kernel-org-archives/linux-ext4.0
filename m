From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: Use of consistent types in e2fsprogs
Date: Tue, 17 May 2011 11:34:27 -0600
Message-ID: <B637356B-1435-4FE9-9D47-662CD622D461@dilger.ca>
References: <DC591D7D-86E5-4FA6-BC8F-859F1965C51D@dilger.ca> <20110517011648.GC4953@thunk.org> <DAA9FED5-9ACE-40A0-8AF4-70B4C7648976@dilger.ca> <659D100F-7365-403A-8166-4FDF2B45AFBF@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:6312 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab1EQRei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 13:34:38 -0400
In-Reply-To: <659D100F-7365-403A-8166-4FDF2B45AFBF@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 17, 2011, at 04:36, Theodore Tso wrote:
> On May 17, 2011, at 1:04 AM, Andreas Dilger wrote:
>> I'm not suggesting a global search & replace of "long long" or anything.
>> However, the current mish-mash of int vs. long vs. dgrp_t for group numbers,
>> __u64 vs blk64_t, etc doesn't make it clear when something is intentionally
>> that type, or just happens to be working for now.  Having separate types
>> for groups vs. physical blocks vs. logical blocks as we do in the kernel
>> will improve the quality of the code itself, I think.
> 
> But you are talking about doing a global search and replace of "e2_blkcnt_t"
> for something else like "ext2_logblk_t", aren't you?   If we need to better
> document all of the types, yes, that will probably help.

Consistency is one of the important reasons.  Even though I've been an e2fsprogs contributor for many years already, I struggle to remember the right type to use, because there is neither consistency in the naming, nor consistency in the code about the usage.  I think the cleanup that was done in the ext4 code for the naming helped the readability of that code considerably.

> But I don't see how a global search and replace of "dgrp_t" for "ext2_group_t"
> is going to help us find the places where a group number was assigned to
> an int.

That is bypassing my point.  My intent is not only to start using a consistent naming scheme for existing types, but also to go through the code for places that do not use consistent types (e.g. int, long, ...) and replace those with the appropriate type as well.

> Yes, the naming scheme is inconsistent.   e2fsprogs is a very old code base,
> and many of these decisions were made a very long time ago.

Sure, no slight is intended over the current state of the code.  The e2fsprogs code base has definitely been a good example (especially the regression tests make it stand above the crowd, IMHO).  However, I think the intervening years have also taught us more about making code cleaner and more easily maintained.

> But I don't see how a global search and replace of one typedef name for
> another will _find _bugs_.   It won't help in the cases where we used a raw
> type, and it won't help where we accidentally used the wrong typedef'ed name.

Sure, just renaming the types won't remove any existing bugs, but it will help prevent bugs in the future because the people that are reading and modifying the code will understand it better.  It will be more clear that when a function takes an ext2_fsblk_t as a parameter that this is an absolute block number, and when it takes ext2_lblk_t (as Eric suggests) it is a file logical block, etc.  It will also help ensure that developers choose the right size of variable for the value being manipulated, and hopefully avoid truncation errors for > 2^32-block filesystems, which we are very interested to support.  The availability of 3TB drives in our standard 8+2 RAID-6 create a 24TB LUN, and 4TB drives are probably going to be available within a year.

> It might help a new comer to the code base when they are writing new code,
> yes.   So would better documentation.   Against that we have to weigh
> the cost of the code churn, and the fact that patches to the maint branch
> won't be easily pulled to master, etc.

I agree - there is some added maintenance effort for a short time, but I think the long-term benefits are also valuable (in the form of fewer bugs).  Also, I don't expect that I'll have this kind of patch available overnight.  The search-and-replace is easy, but actually finding bugs will be the hard/slow part, but it needs to start somewhere.

My only concern would be about compatibility of the external interface.  Since only the type names are changing and not the field size, there shouldn't be any binary compatibility problems.  I worry about things like C++ and coff/elf libraries that might do function name mangling to try and get a stable binary interface.  It may be that they will have problems because of the name change, even though the types are remaining the same size.

Cheers, Andreas





