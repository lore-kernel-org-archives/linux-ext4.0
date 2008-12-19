From: "Sandeep K Sinha" <sandeepksinha@gmail.com>
Subject: Re: block allocation for ext2_mkdir
Date: Sat, 20 Dec 2008 01:54:16 +0530
Message-ID: <37d33d830812191224v2078eba8m6aeae80379b55632@mail.gmail.com>
References: <2d08ef090812181042k2b15f27fke39076cc72453797@mail.gmail.com>
	 <2d08ef090812181152r53fa9d18j1b21310c4e592f@mail.gmail.com>
	 <20081218223928.GA20092@atrey.karlin.mff.cuni.cz>
	 <2d08ef090812182342p1a210adcgd70d8a5cf3bf828c@mail.gmail.com>
	 <804dabb00812190135q2cf1a5co85ce9cc4ac8bbb30@mail.gmail.com>
	 <2d08ef090812190318w2c33c76bg93042ca61884cd5@mail.gmail.com>
	 <804dabb00812190729r74d9f131kdd5c86d56320dc20@mail.gmail.com>
	 <2d08ef090812191049p1da42e74jc9cce8f076a56ab7@mail.gmail.com>
	 <2d08ef090812191101y11cb1448v78e207c0e885c8bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Peter Teoh" <htmldeveloper@gmail.com>, "Jan Kara" <jack@suse.cz>,
	Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Rohit Sharma" <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:14952 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYLSUYR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Dec 2008 15:24:17 -0500
Received: by wa-out-1112.google.com with SMTP id v27so571573wah.21
        for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2008 12:24:17 -0800 (PST)
In-Reply-To: <2d08ef090812191101y11cb1448v78e207c0e885c8bf@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 20, 2008 at 12:31 AM, Rohit Sharma <imreckless@gmail.com> wrote:
> I am not sure but ext2_alloc_blocks function
> in inode.c, allocate blocks for indirect blocks.
>
You are right,
The allocation can be from direct or indirect blocks depending on the
availability.
What I feel is that you dont need any kind of optimizations for the
allocation of all your direct blocks, but surely for indirect blocks.

>
>
> On Sat, Dec 20, 2008 at 12:19 AM, Rohit Sharma <imreckless@gmail.com> wrote:
>> Is there a difference between how ext2 allocates block between
>> inode's indirect blocks and data blocks.
>>

Ofcourse, you surely will have.
So, as a part of the block allocation optimization ext2 uses the
concepts of goals and reservation windows for its indirect blocks.


>>
>> On Fri, Dec 19, 2008 at 8:59 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>>> On Fri, Dec 19, 2008 at 7:18 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>>>> On Fri, Dec 19, 2008 at 3:05 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>>>>> On Fri, Dec 19, 2008 at 3:42 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>>>>>> On Fri, Dec 19, 2008 at 4:09 AM, Jan Kara <jack@suse.cz> wrote:
>>>>>>>> On Fri, Dec 19, 2008 at 12:12 AM, Rohit Sharma <imreckless@gmail.com> wrote:
>>>>>>>> > How does ext2 allocate blocks for directory.
>>>>>>>> >
>>>>>>>> > ext2_mkdir               calls            ext2_make_empty
>>>>>>>> >
>>>>>>>> > ext2_make_empty     calls           __ext2_write_begin
>>>>>>>> >
>>>>>>>> > __ ext2_write_begin   calls           block_write_begin
>>>>>>>> >
>>>>>>>> > my query is that how does this function allocates blocks for directories. ??
>>>>>>>> >
>>>>>>>>
>>>>>>>> Does ext2 uses ext2_get_block to allocate blocks for both files and
>>>>>>>> directories. ??
>>>>>>>  Yes, exactly. Ext2 (unlike ext3 or ext4) treats directories the same
>>>>>>> ways as ordinary files and thus ext2_get_block is used for block
>>>>>>> allocation.
>>>>>>>
>>>>>>
>>>>>> Can i modify this function to restrict allocation of blocks
>>>>>> to a particular block group ?
>>>>>>
>>>>>> Like i want that my abc.txt file should be in block group 5 suppose, then
>>>>>> what should i do?
>>>>>>
>>>>>
>>>>> I think this can be done.   Or is done in the kernel source in several
>>>>> ways (indirectly).
>>>>>
>>>>> 1.   ext2_find_goal()-->this will look for the best new block.   when
>>>>> searching, it will try to find the block to be allocated to follow the
>>>>> one last allocated in the file, so as to maintain storage contiguity.
>>>>>
>>>>> 2.   looking into fs/ext2/balloc.c: ext2_try_to_allocate(), there is a
>>>>> argument called group_goal, whose purpose is to specify the goal block
>>>>> group, and the algorithm will start searching from the group specified
>>>>> (look for "start=grp_goal").   Of course, if search is in vain it will
>>>>> proceed to other block group, which u don't want ....so may be can
>>>>> customize from here.
>>>>>
>>>>> Not sure if I am right?
>>>>>
>>>> When we create new file, do we use reservation window to allocate blocks
>>>> or we use reservation window every time we need a new data blocks
>>>> for file.
>>>>
>>>>
>>>
>>> http://lwn.net/Articles/81357/ ===> from here, we deduced that it
>>> should be done at every new block request level, and not at the file
>>> level.   This is because when file level request is initiated, the
>>> first thing is see if any existing block can be reused or not, before
>>> allocating new block (which then comes with reservation features - to
>>> ensure contiguity of datablocks).
>>>
>>>
>>> --
>>> Regards,
>>> Peter Teoh
>>>
>>> Ernest Hemingway - "Never mistake motion for action."
>>>
>>
>
> --
> To unsubscribe from this list: send an email with
> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
> Please read the FAQ at http://kernelnewbies.org/FAQ
>
>



-- 
Regards,
Sandeep.





 	
"To learn is to change. Education is a process that changes the learner."
