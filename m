From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: double free of blocks occurred during online defrag
Date: Thu, 26 Feb 2009 17:38:08 -0500
Message-ID: <170fa0d20902261438s79a04780wbbe477fa899426df@mail.gmail.com>
References: <49A4E7B8.2040804@sx.jp.nec.com> <20090225104446.GA25714@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:60625 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZBZWiL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Feb 2009 17:38:11 -0500
Received: by qw-out-2122.google.com with SMTP id 5so1350350qwi.37
        for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2009 14:38:09 -0800 (PST)
In-Reply-To: <20090225104446.GA25714@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 5:44 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
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

Aneesh,

I occasionally hit the "Double free" ext4_error in
ext4_mb_free_metadata() as well as the (free != pa->pa_free)
ext4_error in ext4_mb_release_inode_pa().

I'm exploring your patch to see if it eliminates my problems.

I'm missing why the meta-data blocks on the free_list are a concern.
Yes, ext4_mb_generate_from_freelist() will set all these
free'd-but-not-yet-committed metadata blocks in the temporary bitmap.
ext4_mb_release_inode_pa() will then use that bitmap, which happens to
have extra bits set for metadata blocks, but because those bits are
set they will continue to be left unchanged in the buddy bitmap
(because AFAIK ext4_mb_release_inode_pa()'s search only cares about
regions of the pa space that are _not_ set in the temporary bitmap).

So why do these metadata blocks' bits being set in the temporary
bitmap _really_ matter for the purposes of maintaining correctness in
the buddy bitmap?

thanks,
Mike
