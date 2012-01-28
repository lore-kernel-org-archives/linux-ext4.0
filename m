From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [dm-devel] can't recover ext4 on lvm from ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd
Date: Sat, 28 Jan 2012 01:34:28 -0700
Message-ID: <EBC820CD-E86F-48BB-ADA3-38B5C8A75187@dilger.ca>
References: <217150909.20120105113759@eikelenboom.it> <197607646.20120105142107@eikelenboom.it> <6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu> <4910694144.20120105171428@eikelenboom.it> <20120105181535.GB26382@thunk.org> <Pine.LNX.4.64.1201061133140.6954@hs20-bc2-1.build.redhat.com> <loom.20120128T050950-718@post.gmane.org> <loom.20120128T090712-530@post.gmane.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: WIMPy <WIMPy@yeti.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:39718 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2A1IeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Jan 2012 03:34:09 -0500
In-Reply-To: <loom.20120128T090712-530@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Could you please try to bisect the problem, if it is reproducible?

I was looking for a change which I thought might be responsible (removal of block bitmap initialization when inodes are first allocated from an uninitialized inode table) but I couldn't see it in the git log, so maybe that change has not landed yet.

I don't have any other ideas of which recent patches might be responsible at this point. 

Cheers, Andreas

On 2012-01-28, at 1:14, WIMPy <WIMPy@yeti.dk> wrote:

> Update:
> 
>>>>> this is a problem which apparently occurred when the user went from
>>>> v3.1.5 to v3.2, so this looks likes 3.2 regression.)
>> 
>> I am on 3.2.0 as well.
> 
> I didn't spot anything obvious in the logs.
> 
>> It happened for me on a freshly created FS.
>> "mke2fs -j -O sparse_super -O dir_index -O extents -O filetype -O uninit_bg"
>> mounted with no additional options for the first time I got an
>> "EXT4-fs error (device md127): ext4_mb_generate_buddy:739: group 28671, 32765 
>> clusters in bitmap, 32766 in gd"
>> after writing about 3TB of data.
>> I do not have RO snapshots as the OP, but my md sits on to of luks 
> containers. 
>> So we do have the device mapper in common.
> 
> After I did an fsck and tried to continue, I didn't get that far.
> After another 200GB or so it happened again.
> And now it's reproducible:
> I can run fsck and then try to continue (using rsync). But as soon as writing 
> starts, the process hangs for a long time. At least one minute, probably longer.
> Then the ext4_mb_generate_buddy comes again.
> 
> I upgraded e2fstools from 1.41.14 to 1.42 and the kernel to 3.2.2.
> No difference.
> That FS is unusable.
> 
>> Just for the records: Unlike the contents, the hardware is not new and did 
> not 
>> have any known issues.
>> 
>>  Greetings,
>>    WIMPy
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo <at> vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
