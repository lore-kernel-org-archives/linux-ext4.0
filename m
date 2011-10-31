From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: bigalloc and max file size
Date: Mon, 31 Oct 2011 13:09:34 -0600
Message-ID: <7EB4969C-BE2B-49A6-9905-7694D14C7A5F@whamcloud.com>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EAA2217.5020002@tao.ma> <A0C1821A-B597-4617-BD14-B638143DC3C2@mit.edu> <4EAE780D.3090005@tao.ma> <4EAEEEB6.8010102@oracle.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Tao Ma <tm@tao.ma>, Theodore Tso <tytso@MIT.EDU>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57767 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033Ab1JaTJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 15:09:27 -0400
Received: by qabj40 with SMTP id j40so5246481qab.19
        for <linux-ext4@vger.kernel.org>; Mon, 31 Oct 2011 12:09:26 -0700 (PDT)
In-Reply-To: <4EAEEEB6.8010102@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-10-31, at 12:53 PM, Sunil Mushran wrote:
> On 10/31/2011 03:27 AM, Tao Ma wrote:
>> OK, so let me explain why the big cluster length works.
>> 
>> In the new bigalloc case if chunk size=64k, and with the linux-3.0
>> source, every file will be allocated a chunk, but they aren't contiguous
>> if we only write the 1st 4k bytes. In this case, writeback and the block
>> layer below can't merge all the requests sent by ext4. And in our test
>> case, the total io will be around 20000. While with the cluster size, we
>> have to zero the whole cluster. From the upper point of view. we have to
>> write more bytes. But from the block layer, the write is contiguous and
>> it can merge them to be a big one. In our test, it will only do around
>> 2000 ios. So it helps the test case.
> 
> Am I missing something but you cannot zero the entire cluster because
> block_write_full_page() drops pages past i_size.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5693486bad2bc2ac585a2c24f7e2f3964b478df9

With ext4_ext_zeroout->blkdev_issue_zeroout() it submits the zeroing
request directly to the block layer (with cloned ZERO_PAGE pages) and
skips the VM entirely.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



