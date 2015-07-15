From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 15 Jul 2015 08:14:15 -0700
Message-ID: <55A678C7.7010704@infradead.org>
References: <1436955987-7305-1-git-send-email-jack@suse.com> <20150715141836.GA18400@thunk.org> <55A676BF.8020903@infradead.org> <55A67790.80802@infradead.org> <55A6780E.2040702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55A6780E.2040702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/15/15 08:11, Eric Sandeen wrote:
> On 7/15/15 10:09 AM, Randy Dunlap wrote:
>> On 07/15/15 08:05, Randy Dunlap wrote:
>>> On 07/15/15 07:18, Theodore Ts'o wrote:
>>>> On Wed, Jul 15, 2015 at 12:26:24PM +0200, Jan Kara wrote:
>>>>>
>>>>>   so I have created this patch set which removes ext3 driver (and some related support
>>>>> code) from the kernel. See changelog of patch 2/3 for more details. If noone objects,
>>>>> I will queue the series in my tree for the next merge window.
>>>>>
>>>>> Jens, are you OK with me merging patch 3/3 or do you want me to send it to you once
>>>>> the first two patches get merged?
>>>>>
>>>>> Ted, this also touches ext4 driver so that it always handles ext3 filesystems so ack
>>>>> from you would be nice.
>>>>
>>>> Got tired of maintaining ext3, eh?   :-)
>>>>
>>>> As a minor nit, I wonder if it's worth while to put in some hackery in
>>>> fs/Kconfig so that if someone only has CONFIG_FS_EXT3 defined, but not
>>>> CONFIG_FS_EXT4 defined, that it will automatically enable
>>>> CONFIG_FS_EXT4 instead?  Otherwise someone upgrading their kernel
>>>> might accidentally end up getting a non-functional kernel.
>>>>
>>>> i.e., something like this? (not tested!)
>>>>
>>>> config FS_EXT3
>>>>        def_bool n
>>>>        select FS_EXT4
>>>
>>>
>>> Yes, if someone is going to force us to use ext4, some automation would
>>> be helpful.
>>>
>>> Thanks,
>>>
>>
>> Are there any other changes required, e.g., to /etc/fstab ?
>>
>> btw, this looks like an April 1 joke to me.
> 
> no fstab changes required.  The ext4 driver has been able to register
> itself as ext[23] for quite some time now, so it's transparent.
> 
> Many/most distros have been using the ext4.ko driver for ext3 & ext2 for
> years.  You may already be using that on some boxes, and not even know it.
> ;)

Aha.  Right you are.  Thanks.  :)


-- 
~Randy
