From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC V2] ext3: add ioctl to force 32-bit hashes from indexed
 dirs
Date: Mon, 01 Apr 2013 10:13:39 -0500
Message-ID: <5159A423.90503@redhat.com>
References: <51546EED.8030507@redhat.com> <5154AAB4.2000701@redhat.com> <20130329114334.GB5913@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Anand Avati <avati@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758407Ab3DAPOV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 11:14:21 -0400
In-Reply-To: <20130329114334.GB5913@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/29/13 6:43 AM, Jan Kara wrote:
> On Thu 28-03-13 15:40:20, Eric Sandeen wrote:
>> This adds a new ioctl, EXT3_IOC_32BITHASH, which allows a
>> userspace application to request 32-bit rather than 64-bit
>> hashes from readdir on an indexed / dx / htree directory.
>>
>> Gluster had been relying on the top bits of the d_off being
>> free; there are some reports that filling all 64 bits breaks
>> Samba as well.  The infrastructure to return 32-bit hashes
>> already exists; NFS can turn it on, and it's turned on for
>> 32-bit processes as well.  So it's just a matter of flipping
>> on the f_mode flag before readdir starts.
>>
>> Care needs to be taken that we don't change the FMODE flag
>> after readdir has been started, so we make sure that
>> filp->private_data has not yet been set before we set the flag.
>> (Thanks Zach!).
>>
>> Pre-submission-fixes-by: Zach Brown <zab@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> V2:
>> fix "readir" typo
>> rename goto target to *_out like others
>> remove parameter; we can't really ever turn this back off once it's used.
>> closing and reopening is the only way to get back to 64 bit hashes.
>   Looks good. Just one nit below:

Oh, of course, duh!  I'll send V3, thanks.

-Eric

>> diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
>> +	case EXT3_IOC_32BITHASH: {
>> +		int err = 0;
>> +
>> +		/* Serialize with readdir */
>> +		if ((err = mutex_lock_killable(&inode->i_mutex)))
>> +			return err;
>> +
>> +		/* protect f_mode */
>> +		spin_lock(&filp->f_lock);
>> +
>> +		/* Only valid for htree directories */
>> +		if (!S_ISDIR(inode->i_mode) || !is_dx_dir(inode)) {
>   Won't it be better to return ENOTDIR in !S_ISDIR case?
> 
>> +			err = -EINVAL;
>> +			goto hash32bits_out;
>> +		}
>> +
>> +		/* Have we already started readdir on this dx dir? */
>> +		if (filp->private_data) {
>> +			err = -EINVAL;
>   And here maybe EBUSY, but in this case I'm really undecided.
> 
>> +			goto hash32bits_out;
>> +		}
>> +
>> +		filp->f_mode |= FMODE_32BITHASH;
>> +hash32bits_out:
>> +		spin_unlock(&filp->f_lock);
>> +		mutex_unlock(&inode->i_mutex);
>> +		return err;
>> +	}
>>  	case FITRIM: {
>>  
>>  		struct super_block *sb = inode->i_sb;
> 
> 								Honza
> 

