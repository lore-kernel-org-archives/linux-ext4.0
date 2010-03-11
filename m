From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 3/5] ext4: Implement project ID support for ext4 filesystem
Date: Thu, 11 Mar 2010 12:54:46 -0700
Message-ID: <B4AAD310-8A75-43C8-989E-616CFACFB7A9@sun.com>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
 <1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
 <1267727677-11956-3-git-send-email-dmonakhov@openvz.org>
 <1267727677-11956-4-git-send-email-dmonakhov@openvz.org>
 <20100311120623.GC4706@infradead.org> <877hpjj88k.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <877hpjj88k.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2010-03-11, at 06:30, Dmitry Monakhov wrote:
> Christoph Hellwig <hch@infradead.org> writes:
>>
>> I think you'd be much better off storing it inide the inode core  
>> itself.
>> E.g. you could ue the never used fragment address in the ext2/3/4  
>> disk
>> inode.
>
> This was already discussed at the first RFC
> http://patchwork.ozlabs.org/patch/38766
> and Andreas was strongly against this idea.


I had written:
>> You can instead just store this data in an xattr (which will  
>> normally be stored in the inode, so no performance impact), and  
>> then you are free to store multiple values per inode.

I don't know if I would classify this as "strongly against", but it is  
true that I'm hesitant to use up the last field in the inode for  
something that may be used so rarely.  There is also some desire to  
use this field for an extended i_links_hi field, and/or an inode  
checksum.

Part of my suggestion to use xattrs was that it would then be possible  
to allow hard links to have different project IDs on the same file,  
since the size of the xattr is flexible.  Since the xattr is stored  
inside the inode in ext3/ext4 if the inode was formatted with 256-byte  
inodes this is a minimal performance hit.

A second possibility (if there is really no desire to have more than a  
single project ID per inode) is to add a field to the "large" inode  
for ext4, though that doesn't help filesystems that were not formatted  
that way, and it also consumes space in all inodes even if this  
feature is not used.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

