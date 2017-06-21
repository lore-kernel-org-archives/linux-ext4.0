From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH v5 27/28] ext4: xattr inode deduplication
Date: Wed, 21 Jun 2017 14:34:12 -0700
Message-ID: <CAAeU0aN8_WUTkBM8XgiNXtGFxCRqjeftnG_v3V_8dCaiWmYwog@mail.gmail.com>
References: <6E41DA31-A524-4E0E-BD0B-5C994399BBC6@dilger.ca>
 <20170620090721.12480-1-tahsin@google.com> <C5BD0B33-E343-405A-B74F-1F1717B618F9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <C5BD0B33-E343-405A-B74F-1F1717B618F9@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Tashin, we are already using the "no_mbcache" option name, so would prefer
> to keep that working.  It would be OK to accept both option names to mean
> the same thing, and only document the "nombcache" option.

Updated patch to accept both nombcache and no_mbcache.

>>       struct mb_cache *s_mb_cache;
>> +     struct mb_cache *s_ea_inode_cache;
>
> These names should be consistent, like "s_ea_block_cache".

Yes, I will rename this to s_ea_block_cache.

>> #define EXT4_GET_MB_CACHE(inode)      (((struct ext4_sb_info *) \
>>                               inode->i_sb->s_fs_info)->s_mb_cache)
>>
>> +#define EA_INODE_CACHE(inode)        (((struct ext4_sb_info *) \
>> +                             inode->i_sb->s_fs_info)->s_ea_inode_cache)
>
> These names should be consistent, like EXT4_GET_EA_CACHE() or maybe
> EXT4_GET_EA_BLOCK_CACHE() and EXT4_GET_EA_INODE_CACHE().

How about EA_BLOCK_CACHE() and EA_INODE_CACHE() to keep them short?
