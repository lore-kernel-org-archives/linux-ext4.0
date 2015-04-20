From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] ext4: Speedup ext4 orphan inode handling
Date: Mon, 20 Apr 2015 10:35:01 -0600
Message-ID: <05A53E56-0B0A-4741-A542-7C6CDB61729C@dilger.ca>
References: <1429198977-5637-1-git-send-email-jack@suse.cz> <1429198977-5637-3-git-send-email-jack@suse.cz> <056F4994-DF7C-4780-A3BD-C2A818BEEE45@dilger.ca> <20150420122532.GF3117@quack.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34038 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbbDTQfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2015 12:35:05 -0400
Received: by pdbqa5 with SMTP id qa5so212477055pdb.1
        for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2015 09:35:04 -0700 (PDT)
In-Reply-To: <20150420122532.GF3117@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 20, 2015, at 6:25 AM, Jan Kara <jack@suse.cz> wrote:
> On Fri 17-04-15 17:53:03, Andreas Dilger wrote:
>> On Apr 16, 2015, at 9:42 AM, Jan Kara <jack@suse.cz> wrote:
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>> ---
>>> fs/ext4/ext4.h  |  52 +++++++++++--
>>> fs/ext4/namei.c |  95 +++++++++++++++++++++--
>>> fs/ext4/super.c | 237 ++++++++++++++++++++++++++++++++++++++++++++++++--------
>>> 3 files changed, 341 insertions(+), 43 deletions(-)
>>> 
>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>> index abed83485915..768a8b9ee2f9 100644
>>> --- a/fs/ext4/ext4.h
>>> +++ b/fs/ext4/ext4.h
>>> @@ -208,6 +208,7 @@ struct ext4_io_submit {
>>> #define EXT4_UNDEL_DIR_INO	 6	/* Undelete directory inode */
>>> #define EXT4_RESIZE_INO		 7	/* Reserved group descriptors inode */
>>> #define EXT4_JOURNAL_INO	 8	/* Journal inode */
>>> +#define EXT4_ORPHAN_INO		 9	/* Inode with orphan entries */
>> 
>> Contrary to your patch description that said this was using ino #12,
>> this conflicts with EXT2_EXCLUDE_INO for snapshots.  Why not use
>> s_last_orphan in the superblock to reference the orphan inode?  Since
>> this feature already requires a new EXT2_FEATURE_RO_COMPAT flag, the
>> existing orphan inode number could be reused.  See below how this could
>> still in the ENOSPC case.
> 
>  So I think you misunderstood one thing: Orphan file is statically
> allocated (when feature gets enabled by mkfs). Kernel doesn't handle
> resizing in any way - that way we can assume we modify exactly one block to
> add inode to orphan file.

You are right, I totally didn't notice this was the case.  I thought the
orphan inode size would grow as needed by the workload, and the ENOSPC
handling would only be used if the filesystem was actually out of space.
If we stick with the static orphan inode size, it makes sense to add a
comment explaining this clearly.

> If we run out of space in orphan file - but
> note that e.g. if you have 128 KB orphan file, it can contain 32768 orphan
> entries and you never have that many orphan inodes at once under normal
> circumstances - we fall back to old style orphan list. So if you have more
> orphan inodes than you expected when creating orphan file, the fs still
> handles that gracefully, it just falls back to the old unscalable code.

What I was thinking is that the orphan inode would always be linked from
the superblock s_last_orphan if FEATURE_RO_COMPAT_ORPHAN_INODE is set:

ext4_super_block[s_last_orphan] -> orphan_inode[i_dtime] [ ->orphan list ]

Then, if no space is available to grow the orphan inode it would hook
orphans off i_dtime from the orphan inode as needed as is done today.

> IMHO adding code to grow orphan file isn't simply worth it (but we can do
> it if we decide so in the future). Also we have to keep code to handle old
> style orphan list anyway in kernel so the fallback doesn't really incurr
> any significant additional complexity.

How big is the orphan file by default?  I'd think it will be a bit tricky
to get this right, since it depends on both the size of the filesystem
(e.g. you don't want 128KB orphan file on a 1.44MB floppy) and the number
of cores.  Given that there is already existing code to handle extending
a file easily (e.g. ext4_append()) I don't think that is too hard.  Then
the orphan inode will only grow as large as needed.

It could also detect SMP collisions by whether the buffer heads are locked
already, and then allocate a new block to reduce contention.  That way we
get just the right SMP scalability for the system and workload being run.

>> What do you think about making the on-disk orphan inode numbers store
>> 64-bit values?  That would be easy to do now, and would avoid a format
>> change in the future if we wanted to use 64-bit inodes.
>> 
>> That said, if the orphan inode is deleted after orphan recovery (see
>> more below) the only thing needed for compatibility is to store the
>> inode number size into the orphan inode somewhere so it could be changed.
>> Maybe i_version and/or i_generation since they are not directly user
>> accessible.
> 
>  So orphan entry is cleared once inode isn't orphan anymore. So a clean
> filesystem currently has completely zeroed out orphan file. Switching to
> 64-bit inode numbers would be trivial then and you can just pick the format
> of the orphan file based on the 64BIT_INODE incompat feature we'll have to
> have in sb anyway. So I don't think we need to do anything in that regard
> now.

But if someone wants to enable 64BIT_INODE then they need to set this flag
on the superblock, and it would confuse the kernel to thinking that the
orphan inode has 64-bit inode numbers, when it still only has 32-bit inodes.
It seems safer to store the inode number size with the orphan inode.  One
option is to put it in the low byte of the proposed per-block magic, so if
the inode number size changes the magic will change as well.

>> This would also allow you to detect if s_last_orphan was the orphan inode
>> without burning an EXT4_*_FL inode flag for a one-file-only usage.
>  Umm, which flag do you mean? I have EXT4_STATE_ORPHAN_FILE which
> indicates that inode has entry in the orphan file - i.e. it is orphaned via
> the orphan file. But you seem to be talking about something different here.

I was wondering about how to verify that the orphan inode really is an
orphan inode, to avoid treating some random inode's blocks as the orphan
list, and then zeroing out that file accidentally.  That gets to be more
of a concern if s_last_orphan is pointing to the orphan inode, since this
could also be confused with a regular inode on the orphan list.

Having the per-block magic avoids much of this problem, and having the
FEATURE_COMPAT_ORPHAN_FILE also ensures that the first orphan in the
s_last_orphan list is the orphan inode and not just some random inode.

Cheers, Andreas





