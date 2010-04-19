From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4: batched discard support
Date: Mon, 19 Apr 2010 11:30:09 -0500
Message-ID: <4BCC8511.2070402@redhat.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com> <h2o87f94c371004190920h5e793818x4113da75dd21da8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>, Mark Lord <liml@rtr.ca>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab0DSQ4L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 12:56:11 -0400
In-Reply-To: <h2o87f94c371004190920h5e793818x4113da75dd21da8b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg Freemyer wrote:
> Adding Mark Lord in cc.
> 
> He wrote a preliminary discard solution last summer.  I'm not sure how
> it has progressed.

The difference here is that Mark's stuff wasn't as tightly integrated
with the kernel, IIRC.  What I saw was more at a user level - make a big
file, map it, discard all the blocks, unlink the file.

It was a good first step, but I think we can do a lot better by using
fs-specific calls to be efficient & targeted about the discards.

Christoph has a similar approach for XFS, FWIW.

-Eric

> Mark, you can find the 2 patches at:
> 
> http://patchwork.ozlabs.org/patch/50441/
> http://patchwork.ozlabs.org/patch/50442/
> 
> Greg
> 
> On Mon, Apr 19, 2010 at 6:55 AM, Lukas Czerner <lczerner@redhat.com> wrote:
>> Hi all,
>>
>> I would like to present a new way to deal with TRIM in ext4 file system.
>> The current solution is not ideal because of its bad performance impact.
>> So basic idea to improve things is to avoid discarding every time some
>> blocks are freed. and instead batching is together into bigger trims,
>> which tends to be more effective.
>>
>> The basic idea behind my discard support is to create an ioctl which
>> walks through all the free extents in each allocating group and discard
>> those extents. As an addition to improve its performance one can specify
>> minimum free extent length, so ioctl will not bother with shorter extents.
>>
>> This of course means, that with each invocation the ioctl must walk
>> through whole file system, checking and discarding free extents, which
>> is not very efficient. The best way to avoid this is to keep track of
>> deleted (freed) blocks. Then the ioctl have to trim just those free
>> extents which were recently freed.
>>
>> In order to implement this I have added new bitmap into ext4_group_info
>> (bb_bitmap_deleted) which stores recently freed blocks. The ioctl then
>> walk through bb_bitmap_deleted, compare deleted extents with free
>> extents trim them and then removes it from the bb_bitmap_deleted.
>>
>> But you may notice, that there is one problem. bb_bitmap_deleted does
>> not survive umount. To bypass the problem the first ioctl call have to
>> walk through whole file system trimming all free extents. But there is a
>> better solution to this problem. The bb_bitmap_deleted can be stored on
>> disk an can be restored in mount time along with other bitmaps, but I
>> think it is a quite big change and should be discussed further.
>>
>> I have also benchmarked it a little. You can find results here:
>>
>> people.redhat.com/jmoyer/discard/ext4_batched_discard/
>>
>> comparison with current solution included. Keep in mind that ideal ioctl
>> invocation interval is yet to be determined, so in benchmark I have used
>> the performance-worst scenario - without any sleep between execution.
>>
>>
>> There are two patches for this. The first one just creates file system
>> independent ioctl for this and the second one it the batched discard
>> support itself.
>>
>> I will very much appreciate any comment on this, your opinions, ideas to
>> make this better etc. Thanks.
>>
>> If you want to try it, just create EXT4 file system mount it and invoke
>> ioctl on the mount point. You can use following code for this (I have
>> taken this from xfs patch for the same thing). You can also see some
>> debugging messages, but you may want to set EXT4FS_DEBUG for this.
>>
>> #include <errno.h>
>> #include <fcntl.h>
>> #include <stdio.h>
>> #include <stdint.h>
>> #include <sys/ioctl.h>
>>
>> #define FITRIM          _IOWR('X', 121, int)
>>
>> int main(int argc, char **argv)
>> {
>>        int minsize = 4096;
>>        int fd;
>>
>>        if (argc != 2) {
>>                fprintf(stderr, "usage: %s mountpoint\n", argv[0]);
>>                return 1;
>>        }
>>
>>        fd = open(argv[1], O_RDONLY);
>>        if (fd < 0) {
>>                perror("open");
>>                return 1;
>>        }
>>
>>        if (ioctl(fd, FITRIM, &minsize)) {
>>                if (errno == EOPNOTSUPP)
>>                        fprintf(stderr, "TRIM not supported\n");
>>                else
>>                        perror("EXT4_IOC_TRIM");
>>                return 1;
>>        }
>>
>>        return 0;
>> }
>>
>>  fs/ioctl.c         |   31 +++++++++++++++++++++++++++++++
>>  include/linux/fs.h |    2 ++
>>  2 files changed, 33 insertions(+), 0 deletions(-)
>>
>>  fs/ext4/ext4.h    |    4 +
>>  fs/ext4/mballoc.c |  207 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>>  fs/ext4/super.c   |    1 +
>>  3 files changed, 202 insertions(+), 10 deletions(-)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

