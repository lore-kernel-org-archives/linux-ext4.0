From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [patch 069/283] ext3: handle corrupted orphan list at mount
Date: Fri, 25 Jul 2008 14:41:35 -0400
Message-ID: <170fa0d20807251141v4f0edfax958639b53daf7666@mail.gmail.com>
References: <200807250702.m6P721g8028456@imap1.linux-foundation.org>
	 <170fa0d20807251133y9a09dcaqcdc35de7d0ad2a4f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: duaneg@dghda.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:45771 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYGYSlg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2008 14:41:36 -0400
Received: by py-out-1112.google.com with SMTP id p76so2616061pyb.10
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 11:41:35 -0700 (PDT)
In-Reply-To: <170fa0d20807251133y9a09dcaqcdc35de7d0ad2a4f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2008 at 2:33 PM, Mike Snitzer <snitzer@gmail.com> wrote:
> On Fri, Jul 25, 2008 at 3:02 AM,  <akpm@linux-foundation.org> wrote:
>> From: "Duane Griffin" <duaneg@dghda.com>
>>
>> If the orphan node list includes valid, untruncatable nodes with nlink > 0
>> the ext3_orphan_cleanup loop which attempts to delete them will not do so,
>> causing it to loop forever. Fix by checking for such nodes in the
>> ext3_orphan_get function.
>>
>> This patch fixes the second case (image hdb.20000009.softlockup.gz)
>> reported in http://bugzilla.kernel.org/show_bug.cgi?id=10882.
>>
>> [akpm@linux-foundation.org: coding-style fixes]
>> [akpm@linux-foundation.org: printk warning fix]
>> Signed-off-by: Duane Griffin <duaneg@dghda.com>
>> Cc: <linux-ext4@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
>> diff -puN fs/ext3/inode.c~ext3-handle-corrupted-orphan-list-at-mount fs/ext3/inode.c
>> --- a/fs/ext3/inode.c~ext3-handle-corrupted-orphan-list-at-mount
>> +++ a/fs/ext3/inode.c
>> @@ -2253,6 +2253,19 @@ static void ext3_free_branches(handle_t
>>        }
>>  }
>>
>> +int ext3_can_truncate(struct inode *inode)
>> +{
>> +       if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
>> +               return 0;
>> +       if (S_ISREG(inode->i_mode))
>> +               return 1;
>> +       if (S_ISDIR(inode->i_mode))
>> +               return 1;
>> +       if (S_ISLNK(inode->i_mode))
>> +               return !ext3_inode_is_fast_symlink(inode);
>> +       return 0;
>> +}
>> +
>>  /*
>>  * ext3_truncate()
>>  *
>> @@ -2297,12 +2310,7 @@ void ext3_truncate(struct inode *inode)
>>        unsigned blocksize = inode->i_sb->s_blocksize;
>>        struct page *page;
>>
>> -       if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
>> -           S_ISLNK(inode->i_mode)))
>> -               return;
>> -       if (ext3_inode_is_fast_symlink(inode))
>> -               return;
>> -       if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
>> +       if (!ext3_can_truncate(inode))
>>                return;
>
> I may be missing something here but doesn't the above change the logic
> that was used in ext3_truncate for the S_ISDIR and S_ISLNK cases?
>
> Before ext3_truncate would be short-circuited if S_ISDIR or S_ISLNK,
> now it won't... is that intended?

Gah, I mistakenly read it as only being !S_ISDIR (I missed the fact
that it was !S_ISREG, !S_ISDIR, or !S_ISLNK). And after Duane's change
that logic is maintained... and more readable!

Sorry for the noise.
