From: "Rohit Sharma" <imreckless@gmail.com>
Subject: Re: block allocation for ext2_mkdir
Date: Fri, 19 Dec 2008 13:12:32 +0530
Message-ID: <2d08ef090812182342p1a210adcgd70d8a5cf3bf828c@mail.gmail.com>
References: <2d08ef090812181042k2b15f27fke39076cc72453797@mail.gmail.com>
	 <2d08ef090812181152r53fa9d18j1b21310c4e592f@mail.gmail.com>
	 <20081218223928.GA20092@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Jan Kara" <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:38791 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYLSHmd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Dec 2008 02:42:33 -0500
Received: by rv-out-0506.google.com with SMTP id k40so793051rvb.1
        for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 23:42:32 -0800 (PST)
In-Reply-To: <20081218223928.GA20092@atrey.karlin.mff.cuni.cz>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 19, 2008 at 4:09 AM, Jan Kara <jack@suse.cz> wrote:
>> On Fri, Dec 19, 2008 at 12:12 AM, Rohit Sharma <imreckless@gmail.com> wrote:
>> > How does ext2 allocate blocks for directory.
>> >
>> > ext2_mkdir               calls            ext2_make_empty
>> >
>> > ext2_make_empty     calls           __ext2_write_begin
>> >
>> > __ ext2_write_begin   calls           block_write_begin
>> >
>> > my query is that how does this function allocates blocks for directories. ??
>> >
>>
>> Does ext2 uses ext2_get_block to allocate blocks for both files and
>> directories. ??
>  Yes, exactly. Ext2 (unlike ext3 or ext4) treats directories the same
> ways as ordinary files and thus ext2_get_block is used for block
> allocation.
>

Can i modify this function to restrict allocation of blocks
to a particular block group ?

Like i want that my abc.txt file should be in block group 5 suppose, then
what should i do?

>                                                                Honza
>
> --
> Jan Kara <jack@suse.cz>
> SuSE CR Labs
>
