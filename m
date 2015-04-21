From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] ext4: Speedup ext4 orphan inode handling
Date: Tue, 21 Apr 2015 09:46:25 -0600
Message-ID: <28E2A704-F49A-4E1E-A38B-FA66E2FDE802@dilger.ca>
References: <1429198977-5637-1-git-send-email-jack@suse.cz> <1429198977-5637-3-git-send-email-jack@suse.cz> <056F4994-DF7C-4780-A3BD-C2A818BEEE45@dilger.ca> <20150420122532.GF3117@quack.suse.cz> <05A53E56-0B0A-4741-A542-7C6CDB61729C@dilger.ca> <20150421105613.GF24278@quack.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33830 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392AbbDUPq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Apr 2015 11:46:29 -0400
Received: by pdbqa5 with SMTP id qa5so245247303pdb.1
        for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2015 08:46:29 -0700 (PDT)
In-Reply-To: <20150421105613.GF24278@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 21, 2015, at 4:56 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 20-04-15 10:35:01, Andreas Dilger wrote:
>> On Apr 20, 2015, at 6:25 AM, Jan Kara <jack@suse.cz> wrote:
>>> On Fri 17-04-15 17:53:03, Andreas Dilger wrote:
>>>> What do you think about making the on-disk orphan inode numbers store
>>>> 64-bit values?  That would be easy to do now, and would avoid a format
>>>> change in the future if we wanted to use 64-bit inodes.
>>>> 
>>>> That said, if the orphan inode is deleted after orphan recovery (see
>>>> more below) the only thing needed for compatibility is to store the
>>>> inode number size into the orphan inode somewhere so it could be
>>>> changed.  Maybe i_version and/or i_generation since they are not
>>>> directly user accessible.
>>> 
>>> So orphan entry is cleared once inode isn't orphan anymore. So a clean
>>> filesystem currently has completely zeroed out orphan file. Switching to
>>> 64-bit inode numbers would be trivial then and you can just pick the
>>> format of the orphan file based on the 64BIT_INODE incompat feature
>>> we'll have to have in sb anyway. So I don't think we need to do anything in that regard now.
>> 
>> But if someone wants to enable 64BIT_INODE then they need to set this
>> flag on the superblock, and it would confuse the kernel to thinking
>> that the orphan inode has 64-bit inode numbers, when it still only has
>> 32-bit inodes.
> 
> So I'm bit confused. When you set 64BIT_INODE flag, you still need to
> walk over all the directory structure and convert all the directories.
> Also you presumably enforce the filesystem is clean. At that point the
> orphan file is full of zeros so when you mount the fs, kernel will just
> start looking at those zeros as 64-bit numbers which is fine. When we have
> inode number size also stored within the orphan file, we have to
> explicitly convert it.

The dir_data feature allows storing extra data for each dirent separately.
That would allow enabling 64-bit inodes individually as needed, without
the need to convert the whole filesystem at once, or the need to store the
64-bit value for 32-bit inode numbers.

>> It seems safer to store the inode number size with the orphan inode.
>> One option is to put it in the low byte of the proposed per-block magic,
>> so if the inode number size changes the magic will change as well.
> 
>  So I don't really mind having inode number as a part of magic but I'm
> just wondering about the advantage...

Whether the filesystem needs to be clean or not when 64BIT_INODE is turned
on is a separate issue that could be decided when that feature is added.

Making the last byte of the magic number "4" today is easily done and can be
handled in ext4_inode_per_orphan_block() as easily as using "sizeof(u32)"
(it would probably be better to change that function to take "struct inode"
as the argument instead of "struct super_block").  This gives us flexibility
in the future for little effort today.

Cheers, Andreas





