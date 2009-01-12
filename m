From: "Sandeep K Sinha" <sandeepksinha@gmail.com>
Subject: Re: Copying Data Blocks
Date: Mon, 12 Jan 2009 12:26:42 +0530
Message-ID: <37d33d830901112256g4aecafc0h9e5cdb08f268e6ab@mail.gmail.com>
References: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
	 <804dabb00901110715x2baf84e8kc0fc5d6fa2512fe8@mail.gmail.com>
	 <2d08ef090901112218v1c6820d7q98d39af1350a07a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Peter Teoh" <htmldeveloper@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: "Rohit Sharma" <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:60357 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZALG4n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Jan 2009 01:56:43 -0500
Received: by wa-out-1112.google.com with SMTP id v27so5520498wah.21
        for <linux-ext4@vger.kernel.org>; Sun, 11 Jan 2009 22:56:42 -0800 (PST)
In-Reply-To: <2d08ef090901112218v1c6820d7q98d39af1350a07a0@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Rohit,

On Mon, Jan 12, 2009 at 11:48 AM, Rohit Sharma <imreckless@gmail.com> wrote:
> Hi,
>
> I am having some issues in locking inode while copying data blocks.
> We are trying to keep file system live during this operation, so
> both read and write operations should work.
> In this case what type of lock on inode should be used, semaphore,
> mutex or spinlock?
>

Now here you need to do some homework first.
Each of the locks have its own meaning and particular uses cases.

The current inode struct has the following locks:
1. i_lock
2. i_alloc_sem
3. i_mutex
4. i_flock

 646        spinlock_t              i_lock; /* i_blocks, i_bytes,
maybe i_size */
 647        struct mutex            i_mutex;
 648        struct rw_semaphore     i_alloc_sem;
 649        const struct inode_operations   *i_op;
 650        const struct file_operations    *i_fop; /* former
->i_op->default_file_ops */
 651        struct super_block      *i_sb;
 652        struct file_lock        *i_flock;

Read the difference between spinlock, mutex, and semaphore.
You will be able to understand the semantics of each of these.

>
> On Sun, Jan 11, 2009 at 8:45 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>> Sorry.....some mistakes...a resent:
>>
>> Here are some tips on the blockdevice API:
>>
>> http://lkml.org/lkml/2006/1/24/287
>> http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-01/msg09388.html
>>
>> as indicated, documentation is rather sparse in this area.
>>
>> not sure if anyone else have a summary list of blockdevice API and its
>> explanation?
>>
>> not wrt the following "cleanup patch", i am not sure how the API will change:
>>
>> http://lwn.net/Articles/304485/
>>
>> thanks.
>>
>> On Tue, Jan 6, 2009 at 6:36 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>>>
>>> I want to read data blocks from one inode
>>> and copy it to other inode.
>>>
>>> I mean to copy data from data blocks associated with one inode
>>> to the data blocks associated with other inode.
>>>
>>> Is that possible in kernel space.?
>>> --
>>
>>
>>
>> --
>> Regards,
>> Peter Teoh
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
