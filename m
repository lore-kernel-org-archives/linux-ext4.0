From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 1/2] ext2fs: add multi-mount protection (INCOMPAT_MMP)
Date: Fri, 29 Jul 2011 12:25:45 -0600
Message-ID: <5E568C7A-6A5B-4699-9266-8A0CD2537E5F@whamcloud.com>
References: <1311937077-22262-1-git-send-email-adilger@whamcloud.com> <4E32F18B.6000800@itwm.fraunhofer.de>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Johann Lombardi <johann@whamcloud.com>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35660 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1G2SZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jul 2011 14:25:48 -0400
Received: by gwaa12 with SMTP id a12so674878gwa.19
        for <linux-ext4@vger.kernel.org>; Fri, 29 Jul 2011 11:25:47 -0700 (PDT)
In-Reply-To: <4E32F18B.6000800@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-29, at 11:44 AM, Bernd Schubert wrote:
> thanks a lot for sending those patches! From a previous review I still remember ext2fs_mmp_read(), see below.
> I will look through the other parts later on.
> 
>> +errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
>> +{
>> +	/* ext2fs_open reserves fd0,1,2 to avoid stdio collision */
>> +	if (fs->mmp_fd<= 0) {
>> +		fs->mmp_fd = open(fs->device_name, O_RDWR | O_DIRECT);
>> +		if (fs->mmp_fd<  0) {
>> +			retval = EXT2_ET_MMP_OPEN_DIRECT;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	if (ext2fs_llseek(fs->mmp_fd, mmp_blk * fs->blocksize, SEEK_SET) !=
>> +	    mmp_blk * fs->blocksize) {
>> +		retval = EXT2_ET_LLSEEK_FAILED;
>> +		goto out;
>> +	}
>> +
>> +	if (read(fs->mmp_fd, fs->mmp_cmp, fs->blocksize) != fs->blocksize) {
>> +		retval = EXT2_ET_SHORT_READ;
>> +		goto out;
>> +	}
> 
> While ext2fs_llseek() and read() works fine, I still wonder why the code does not use io_channel_read_blk64() here, similarly as io_channel_write_blk64() write in ext2fs_mmp_write().

One of the reasons for doing a direct open+seek+read here is because previous
versions of e2fsprogs did not allow O_DIRECT reads via io_channel_read_blk64(),
which is critical for the correct MMP functioning.  It cannot allow read from
a cached block, either in libext2fs or in the VM, though a cached block on the
disk is OK as long as it is visible to all hosts that are accessing it.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



