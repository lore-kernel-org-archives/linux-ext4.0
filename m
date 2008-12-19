From: "Sandeep K Sinha" <sandeepksinha@gmail.com>
Subject: Re: block allocation for ext2_mkdir
Date: Fri, 19 Dec 2008 14:51:48 +0530
Message-ID: <37d33d830812190121r2336c121p620f8fd6a77dc835@mail.gmail.com>
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
Received: from wa-out-1112.google.com ([209.85.146.179]:21079 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYLSJVt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Dec 2008 04:21:49 -0500
Received: by wa-out-1112.google.com with SMTP id v27so450863wah.21
        for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2008 01:21:48 -0800 (PST)
In-Reply-To: <2d08ef090812182342p1a210adcgd70d8a5cf3bf828c@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 19, 2008 at 1:12 PM, Rohit Sharma <imreckless@gmail.com> wrote:
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

Did you forget to mention "ONLY FOR YOUR PERSONAL USE, IN YOUR PRIVATE KERNEL".

>
> Like i want that my abc.txt file should be in block group 5 suppose, then
> what should i do?
>
>>                                                                Honza
>>
>> --
>> Jan Kara <jack@suse.cz>
>> SuSE CR Labs
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
