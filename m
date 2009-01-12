From: "Sandeep K Sinha" <sandeepksinha@gmail.com>
Subject: Re: Copying Data Blocks
Date: Mon, 12 Jan 2009 13:56:17 +0530
Message-ID: <37d33d830901120026k17beebc6h1c4eb932dd75d06d@mail.gmail.com>
References: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
	 <804dabb00901110715x2baf84e8kc0fc5d6fa2512fe8@mail.gmail.com>
	 <2d08ef090901112218v1c6820d7q98d39af1350a07a0@mail.gmail.com>
	 <804dabb00901112341m57cd7693y47dd2f713e6a4b31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Rohit Sharma" <imreckless@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:2740 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZALI0S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Jan 2009 03:26:18 -0500
Received: by rv-out-0506.google.com with SMTP id k40so10114659rvb.1
        for <linux-ext4@vger.kernel.org>; Mon, 12 Jan 2009 00:26:17 -0800 (PST)
In-Reply-To: <804dabb00901112341m57cd7693y47dd2f713e6a4b31@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Peter,

Don't you think that if will restrict this to a specific file system.
VFS inode should be used rather than the FS incore inode ?

The purpose if to sleep all the i/o's when we are updating the i_data
from the new inode to the old inode ( updation of the data blocks ).

I think i_alloc_sem should work here, but could not find any instance
of its use in the code.
It's working fine currently with i_mutex, meaning if we hold a i_mutex
lock on the inode while updating the i_data pointers.
And try to perform i/o from user space, they are queued. The file was
opened in r/w mode prior to taking the lock inside the kernel.

But, I still feel i_alloc_sem would be the right option to go ahead with.

On Mon, Jan 12, 2009 at 1:11 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> If u grep for spinlock, mutex, or "sem" in the fs/ext4 directory, u
> can find all three types of lock are used - for different class of
> object.
>
> For data blocks I guessed is semaphore - read this
> fs/ext4/inode.c:ext4_get_branch():
>
> /**
>  *      ext4_get_branch - read the chain of indirect blocks leading to data
> <snip>
>  *
>  *      Need to be called with
>  *      down_read(&EXT4_I(inode)->i_data_sem)
>  */
>
> i guess u have no choice, as it is semaphore, have to follow the rest
> of kernel for consistency - don't create your own semaphore :-).
>
> There exists i_lock as spinlock - which so far i know is for i_blocks
> counting purposes:
>
>       spin_lock(&inode->i_lock);
>        inode->i_blocks += tmp_inode->i_blocks;
>        spin_unlock(&inode->i_lock);
>        up_write(&EXT4_I(inode)->i_data_sem);
>
> But for data it should be i_data_sem.   Is that correct?
>
> On Mon, Jan 12, 2009 at 2:18 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>> Hi,
>>
>> I am having some issues in locking inode while copying data blocks.
>> We are trying to keep file system live during this operation, so
>> both read and write operations should work.
>> In this case what type of lock on inode should be used, semaphore,
>> mutex or spinlock?
>>
>>
>> On Sun, Jan 11, 2009 at 8:45 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>>> Sorry.....some mistakes...a resent:
>>>
>>> Here are some tips on the blockdevice API:
>>>
>>> http://lkml.org/lkml/2006/1/24/287
>>> http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-01/msg09388.html
>>>
>>> as indicated, documentation is rather sparse in this area.
>>>
>>> not sure if anyone else have a summary list of blockdevice API and its
>>> explanation?
>>>
>>> not wrt the following "cleanup patch", i am not sure how the API will change:
>>>
>>> http://lwn.net/Articles/304485/
>>>
>>> thanks.
>>>
>>> On Tue, Jan 6, 2009 at 6:36 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>>>>
>>>> I want to read data blocks from one inode
>>>> and copy it to other inode.
>>>>
>>>> I mean to copy data from data blocks associated with one inode
>>>> to the data blocks associated with other inode.
>>>>
>>>> Is that possible in kernel space.?
>>>> --
>>>
>>>
>>>
>>> --
>>> Regards,
>>> Peter Teoh
>>>
>>
>
>
>
> --
> Regards,
> Peter Teoh
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
