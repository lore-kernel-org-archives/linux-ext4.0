From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH 1/2] ext2fs: add multi-mount protection (INCOMPAT_MMP)
Date: Wed, 03 Aug 2011 13:39:55 +0200
Message-ID: <4E39338B.8020308@itwm.fraunhofer.de>
References: <1311937077-22262-1-git-send-email-adilger@whamcloud.com> <4E32F18B.6000800@itwm.fraunhofer.de> <5E568C7A-6A5B-4699-9266-8A0CD2537E5F@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Johann Lombardi <johann@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:33749 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1HCLj7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2011 07:39:59 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p73Bdu7I023749
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 3 Aug 2011 13:39:57 +0200
In-Reply-To: <5E568C7A-6A5B-4699-9266-8A0CD2537E5F@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/29/2011 08:25 PM, Andreas Dilger wrote:
> On 2011-07-29, at 11:44 AM, Bernd Schubert wrote:
>> thanks a lot for sending those patches! From a previous review I still remember ext2fs_mmp_read(), see below.
>> I will look through the other parts later on.
>>
>>> +errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
>>> +{
>>> +	/* ext2fs_open reserves fd0,1,2 to avoid stdio collision */
>>> +	if (fs->mmp_fd<= 0) {
>>> +		fs->mmp_fd = open(fs->device_name, O_RDWR | O_DIRECT);
>>> +		if (fs->mmp_fd<   0) {
>>> +			retval = EXT2_ET_MMP_OPEN_DIRECT;
>>> +			goto out;
>>> +		}
>>> +	}
>>> +
>>> +	if (ext2fs_llseek(fs->mmp_fd, mmp_blk * fs->blocksize, SEEK_SET) !=
>>> +	    mmp_blk * fs->blocksize) {
>>> +		retval = EXT2_ET_LLSEEK_FAILED;
>>> +		goto out;
>>> +	}
>>> +
>>> +	if (read(fs->mmp_fd, fs->mmp_cmp, fs->blocksize) != fs->blocksize) {
>>> +		retval = EXT2_ET_SHORT_READ;
>>> +		goto out;
>>> +	}
>>
>> While ext2fs_llseek() and read() works fine, I still wonder why the code does not use io_channel_read_blk64() here, similarly as io_channel_write_blk64() write in ext2fs_mmp_write().
>
> One of the reasons for doing a direct open+seek+read here is because previous
> versions of e2fsprogs did not allow O_DIRECT reads via io_channel_read_blk64(),
> which is critical for the correct MMP functioning.  It cannot allow read from
> a cached block, either in libext2fs or in the VM, though a cached block on the
> disk is OK as long as it is visible to all hosts that are accessing it.

Yeah, I understand that it had to be O_DIRECT, but I didn't know about 
(previous) limitation of io_channel_read_blk64(). Maybe you could add a 
comment about it to the code about that, if you want to keep it? 
Something like
"/* We don't use io_channel_read_blk64() here to make sure blocks are 
really not cached */"?

Thanks,
Bernd
