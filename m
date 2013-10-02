From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: add noorlov parameter to avoid spreading of directory
 inodes
Date: Wed, 02 Oct 2013 10:02:12 -0500
Message-ID: <524C3574.7020106@redhat.com>
References: <20131001160817.GA2295@kvack.org> <20131002144759.GB32181@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab3JBPCZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Oct 2013 11:02:25 -0400
In-Reply-To: <20131002144759.GB32181@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/2/13 9:47 AM, Jan Kara wrote:
> On Tue 01-10-13 12:08:17, Benjamin LaHaise wrote:
>> While investigating a performance regression during migration of the
>> Solace product from an older kernel running ext3 to a 3.x kernel running
>> ext4, the change in allocation policies between ext3 and ext4 were found
>> to have caused a 10-50% decrease (depending on the test) in I/O
>> throughput.  In order to extract more parallelism from the filesystem,
>> this particular use-case has 100 subdirectories off of the root
>> directory of an ext4 filesystem in which files are created in a
>> round-robin fashion.  The subdirectories are used in order to increase
>> the number of metadata operations that can occur in parallel.  With the
>> older setup on ext3, files were created sequentially, while using ext4
>> resulted in the files being spread out across block groups.
>>
>> To avoid this change in allocation policies, introduce the noorlov mount
>> parameter to ext4.  This parameter changes allocation policy such that new
>> subdirectories in the filesystem are allocated in the same block group
>> as the parent subdirectory.  With the subdirectories in the same block
>> group, the allocation policy once again results in files being laid out
>> sequentially on disk, restoring performance.
>   Frankly, I'm not very fond of a mount option for tweaking inode allocation
> policy. OTOH the regression is large enough that we should address it
> somehow.
> 
> So I suppose if your application doesn't use the root directory as a base
> but some other directory on ext4 filesystem, everything is OK, isn't it?
> Because the root directory is special in the Orlov allocator and that is
> where the randomness happens.
> 
> If I'm right about the source of the problem, we could use TOPDIR inode
> flag to handle this. Currently Orlov allocator treats directories with
> TOPDIR flag set the same way as the root directory. Sadly the root
> directory itself is hardcoded in the allocator but we could remove that
> just keep the check for TOPDIR flag. To handle backward compatibility,
> we would set TOPDIR for root inode during mount first time we mount the fs
> with the new kernel (needs some flag in the superblock).
> 
> Hum, so when I wrote this I'm not sure this is that much better than a
> mount option. But it's a possibility :). What do others think?

I'm right with you on thinking a mount option should be a last resort.

One thing I'm curious about - what changed from ext3 to ext4?  I thought
both defaulted to orlov and the same type of allocation behavior, more
or less.  I guess one change is that the "oldalloc" mount
option went away.

(if it does come back, it should probably mirror what we had before,
which was "oldalloc" not "noorlov" right?)

-Eric

> 								Honza
> 

