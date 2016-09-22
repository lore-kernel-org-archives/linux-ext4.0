From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] ext4: Check for encryption feature before
 fscrypt_process_policy()
Date: Thu, 22 Sep 2016 22:17:47 +0200
Message-ID: <78d22e23-3cd5-245f-9a9f-35d314de13eb@nod.at>
References: <1474527054-24207-1-git-send-email-richard@nod.at>
 <20160922194931.GA53380@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        david@sigma-star.at, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160922194931.GA53380@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric,

On 22.09.2016 21:49, Eric Biggers wrote:
> On Thu, Sep 22, 2016 at 08:50:54AM +0200, Richard Weinberger wrote:
>> ...otherwise an user can enable encryption for certain files even
>> when the filesystem is unable to support it.
>> Such a case would be a filesystem created by mkfs.ext4's default
>> settings, 1KiB block size. Ext4 supports encyption only when block size
>> is equal to PAGE_SIZE.
>> But this constraint is only checked when the encryption feature flag
>> is set.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  fs/ext4/ioctl.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>> index 1bb7df5..9e9a73e 100644
>> --- a/fs/ext4/ioctl.c
>> +++ b/fs/ext4/ioctl.c
>> @@ -772,6 +772,9 @@ resizefs_out:
>>  #ifdef CONFIG_EXT4_FS_ENCRYPTION
>>  		struct fscrypt_policy policy;
>>  
>> +		if (!ext4_has_feature_encrypt(sb))
>> +			return -EOPNOTSUPP;
>> +
>>  		if (copy_from_user(&policy,
> 
> Hi Richard,
> 
> This is a good observation, and it happens this is already on my list of bugs to
> address.  I had not previously considered the fact that it allows the block_size
> == PAGE_SIZE restriction to be easily circumvented.
> 
> Ted had actually pointed out that the reason this hasn't already been fixed is
> that some users, e.g. Android, do not set the feature flag but still expect the
> filesystem encryption code to work.  Maybe he can chime in with regards to when
> (if ever) it would make sense to make this change.

We could automatically enable the feature flag in EXT4_IOC_SET_ENCRYPTION_POLICY,
if possible.
E.g.
                if (!ext4_sb_has_crypto(sb)) {
                        if (sb_min_blocksize(sb, EXT4_MIN_BLOCK_SIZE) != PAGE_SIZE)
                                return -EOPNOTSUPP;
                        else {
                                ext4_set_feature_encrypt(sb);
                                ext4_commit_super(sb, 1);
                        }
                }


> It should be noted that f2fs appears to have the same bug as well, with regards
> to the corresponding f2fs feature flag.  (Added Jaegeuk to the CC.)
> 
> With regards to the proposed patch, I did notice that the code to handle
> EXT4_IOC_GET_ENCRYPTION_PWSALT, just below the modified code, calls
> ext4_sb_has_crypto() instead of ext4_has_feature_encrypt().  These are actually
> the same thing, and ext4_sb_has_crypto() is only called from that one place.  I
> think the ioctl code should be consistent, so it may make sense to, as part of
> the patch, remove ext4_sb_has_crypto() and switch EXT4_IOC_GET_ENCRYPTION_PWSALT
> to using ext4_has_feature_encrypt().

Sure.

> Also, it seems the default block size for mkfs.ext4 is determined by a heuristic
> and isn't guaranteed to be 1 KiB.  So the commit message probably should say
> something more general like "filesystems created with a block size other than
> PAGE_SIZE".

Ahh, I thought 1KiB is default, my bad. Will happily update the commit log.

Thanks,
//richard
