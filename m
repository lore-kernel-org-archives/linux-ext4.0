From: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: block allocation for ext2_mkdir
Date: Fri, 19 Dec 2008 17:35:58 +0800
Message-ID: <804dabb00812190135q2cf1a5co85ce9cc4ac8bbb30@mail.gmail.com>
References: <2d08ef090812181042k2b15f27fke39076cc72453797@mail.gmail.com>
	 <2d08ef090812181152r53fa9d18j1b21310c4e592f@mail.gmail.com>
	 <20081218223928.GA20092@atrey.karlin.mff.cuni.cz>
	 <2d08ef090812182342p1a210adcgd70d8a5cf3bf828c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jan Kara" <jack@suse.cz>,
	Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Rohit Sharma" <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:34114 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYLSJf7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Dec 2008 04:35:59 -0500
Received: by yw-out-2324.google.com with SMTP id 9so325982ywe.1
        for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2008 01:35:58 -0800 (PST)
In-Reply-To: <2d08ef090812182342p1a210adcgd70d8a5cf3bf828c@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 19, 2008 at 3:42 PM, Rohit Sharma <imreckless@gmail.com> wrote:
> On Fri, Dec 19, 2008 at 4:09 AM, Jan Kara <jack@suse.cz> wrote:
>>> On Fri, Dec 19, 2008 at 12:12 AM, Rohit Sharma <imreckless@gmail.com> wrote:
>>> > How does ext2 allocate blocks for directory.
>>> >
>>> > ext2_mkdir               calls            ext2_make_empty
>>> >
>>> > ext2_make_empty     calls           __ext2_write_begin
>>> >
>>> > __ ext2_write_begin   calls           block_write_begin
>>> >
>>> > my query is that how does this function allocates blocks for directories. ??
>>> >
>>>
>>> Does ext2 uses ext2_get_block to allocate blocks for both files and
>>> directories. ??
>>  Yes, exactly. Ext2 (unlike ext3 or ext4) treats directories the same
>> ways as ordinary files and thus ext2_get_block is used for block
>> allocation.
>>
>
> Can i modify this function to restrict allocation of blocks
> to a particular block group ?
>
> Like i want that my abc.txt file should be in block group 5 suppose, then
> what should i do?
>

I think this can be done.   Or is done in the kernel source in several
ways (indirectly).

1.   ext2_find_goal()-->this will look for the best new block.   when
searching, it will try to find the block to be allocated to follow the
one last allocated in the file, so as to maintain storage contiguity.

2.   looking into fs/ext2/balloc.c: ext2_try_to_allocate(), there is a
argument called group_goal, whose purpose is to specify the goal block
group, and the algorithm will start searching from the group specified
(look for "start=grp_goal").   Of course, if search is in vain it will
proceed to other block group, which u don't want ....so may be can
customize from here.

Not sure if I am right?

-- 
Regards,
Peter Teoh

Ernest Hemingway - "Never mistake motion for action."
