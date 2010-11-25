From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC][PATCH] Possible data integrity problems in lots of filesystems?
Date: Thu, 25 Nov 2010 12:51:11 +0200
Message-ID: <4CEE3F9F.9070108@panasas.com>
References: <20101125074909.GA4160@amd> <4CEE2C2E.4010003@panasas.com> <20101125100603.GA3164@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Bob Copeland <me@bobcopeland.com>,
	reiserfs-devel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101125100603.GA3164@amd>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 11/25/2010 12:06 PM, Nick Piggin wrote:
> On Thu, Nov 25, 2010 at 11:28:14AM +0200, Boaz Harrosh wrote:

>>> Index: linux-2.6/fs/exofs/file.c
>>> ===================================================================
>>> --- linux-2.6.orig/fs/exofs/file.c	2010-11-19 16:50:00.000000000 +1100
>>> +++ linux-2.6/fs/exofs/file.c	2010-11-19 16:50:07.000000000 +1100
>>> @@ -48,11 +48,6 @@ static int exofs_file_fsync(struct file
>>>  	struct inode *inode = filp->f_mapping->host;
>>>  	struct super_block *sb;
>>>  
>>> -	if (!(inode->i_state & I_DIRTY))
>>> -		return 0;
>>> -	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
>>> -		return 0;
>>> -
>>>  	ret = sync_inode_metadata(inode, 1);
>>>  
>>>  	/* This is a good place to write the sb */
>>>
>>
>> Is that a good enough fix for the issue in your opinion?
>> Or is there more involved?
> 
> For the inode dirty bit race problem, yes it should fix it.
> sync_inode_metadata basically makes the same checks without
> races (in a subsequent patch I re-introduced the datasync
> optimisation).
> 
>  

> 
> Well in your fsync, you need to wait for inode writeback
> that might have been started by an asynchronous write_inode.
> 

All I'm calling is sync_inode_metadata(,1) which calls sync_inode()
which calls writeback_single_inode(sync_mode == WB_SYNC_ALL). It gets
a little complicated but from the looks of it, even though the
call to .write_inode() is not under any lock the state machine there
will do inode_wait_for_writeback() if there was one in motion
all ready. ?

And it looks like writeback_single_inode() does all the proper
checks in the correct order for these flags above.

So current code in exofs_file_fsync() looks scary to me. I would
like to push your above patch for this Kernel. (I'll repost it)

> Also, with your sync_inode_metadata call, you shouldn't need the
> sync_inode call by the looks.
>  

What? I missed you. You mean I don't need to sync_inode_metadata(,wait==1),
or what did you mean?

> Thanks,
> Nick
> 

Thanks
Boaz
