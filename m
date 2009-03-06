From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: double free of blocks occurred during online defrag
Date: Fri, 06 Mar 2009 17:18:52 +0900
Message-ID: <49B0DC6C.9090700@sx.jp.nec.com>
References: <49A4E7B8.2040804@sx.jp.nec.com> <20090225104446.GA25714@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:46865 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbZCFIYI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Mar 2009 03:24:08 -0500
In-Reply-To: <20090225104446.GA25714@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Wed, Feb 25, 2009 at 03:39:52PM +0900, Kazuya Mio wrote:
>> Hi Aneesh,
>>
>> When I remove the file that is running online defrag, the following error occurs
>> after closing the file descriptor:
>>
>> Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8):
>> ext4_mb_release_inode_pa: free 2048, pa_free 1562
>> Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
>> double-free of inode 0's block 802817(bit 0 in group 98)
>> Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
>> double-free of inode 0's block 802818(bit 1 in group 98)
>> Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
>> double-free of inode 0's block 802819(bit 2 in group 98)
>> Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
>> double-free of inode 0's block 802820(bit 3 in group 98)
>> Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
>> double-free of inode 0's block 802821(bit 4 in group 98)
>> Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
>> double-free of inode 0's block 802822(bit 5 in group 98)
>>
>> So, online defrag calls ext4_discard_preallocations() at the end of
>> ext4_defrag() to avoid double-free error.
>> However, above error hasn't occurred since applying your patch posted on Nov
>> 6th, 2008 because this error is caused by the same reason of your report.
>> http://marc.info/?l=linux-ext4&m=122599787406193&w=4
>>
>> What is the status of this patch?
> 
> We dropped the patch because I found that the double free in my case was
> not exactly due the explanation given in the patch above.
> 
> I asked to drop the patch in
> 
> http://article.gmane.org/gmane.comp.file-systems.ext4/10199
> 
> I also found that the patch is not completely correct. The meta-data
> blocks which are added to the free_list are not allocated from any
> prealloc space.
> 
> So what you are seeing may be a different problem which the patch is
> hiding from happening.  I guess you will have to look more closely at why the
> double-free is happening in your case.
> 
> -aneesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I looked into double-free error I had reported, and found out that it was
caused by online defrag. The steps to be caused double-free error are as
follows:

1. We have two files. "DATA" shows data blocks, "used PA" shows the
    preallocation space (called PA) that is allocated, and "free PA" shows PA
    that is free.

    file1: [ DATA1 | used PA1 | free PA1 ]
    file2: [ DATA2 | used PA2 | free PA2 ]

2. Exchange data blocks. The blocks exchanged by defrag are DATA and used PA.

    file1: [ DATA2 | used PA2 | free PA1 ]
    file2: [ DATA1 | used PA1 | free PA2 ]

3. When file1 is closed, ext4_truncate() is called by removing file1. DATA2
    and used PA2 are freed via ext4_truncate(). Moreover,
    ext4_discard_preallocations() is called via ext4_truncate(). But online
    defrag does not change the PA list, so ext4_discard_preallocations()
    frees PA of file1 (used PA1 and free PA1).

    file1: [ FREE SPACE(DATA2) | FREE SPACE(used PA2) | FREE SPACE(free PA1) ]
    file2: [ DATA1 | FREE SPACE(used PA1) | free PA2 ]

4. When file2 is closed, ext4_descard_preallocations() is called via
    ext4_release_file(). However used PA2 is already freed. Therefore,
    double-free error is occurred.

    file1: [ FREE SPACE(DATA2) | *DOUBLE FREE(used PA2)* | FREE SPACE(free PA1) ]
    file2: [ DATA1 | FREE SPACE(used PA1) | FREE SPACE(free PA2) ]

To prevent double-free error, I decided to call ext4_discard_preallocations()
as usual in defrag. If defrag exchanges PA list after defrag, double-free error
will occur by aborting defrag. On the other hand, exchanging the list to each
other every one page (4KB) sounds good. However, above method will change PA
list a lot of times. I think it needs many resources.

Any comment on this?

Regards,
Kazuya Mio
