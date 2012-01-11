From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Support "check=none" "nocheck" mount options
Date: Wed, 11 Jan 2012 09:13:40 -0600
Message-ID: <4F0DA724.2040506@redhat.com>
References: <20120110174118.GB3015@zod.bos.redhat.com> <4F0C78CD.6070809@redhat.com> <7A0721E1-689F-4B9B-BD8C-86A03DDF20CE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Josh Boyer <jwboyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, kernel-team@fedoraproject.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096Ab2AKPNp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jan 2012 10:13:45 -0500
In-Reply-To: <7A0721E1-689F-4B9B-BD8C-86A03DDF20CE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/11/12 4:07 AM, Andreas Dilger wrote:
> On 2012-01-10, at 10:43 AM, Eric Sandeen wrote:
>> On 1/10/12 11:41 AM, Josh Boyer wrote:
>>> The ext2/ext3 filesystems supported "check=none" and "nocheck" as mount options
>>> even though that was already the default behavior and it essentially did
>>> nothing.  When using ext4 to mount ext2/ext3 filesystems, that mount option
>>> causes the mount to fail.  That isn't as backward compatible as it could be,
>>> so add support to ext4 to accept the option.
>>
>> The only thing ext2 does with those options today is to clear the flag,
>> and I can't find anything in userspace or kernelspace which would have set
>> it in any case.  It seem dead, but we do need the compatibility in ext4
>> if it's to handle ext2&3 seamlessly, I guess.
> 
> At a minimum the use of obsolete options like this should print a warning
> at mount time so that there is some chance the user will notice and remove
> the old option from their config.  Otherwise it is impossible to even get
> rid of old useless cruft like this if we need to maintain functionally-useless
> compatibility forever.
> 
> Dredging through my memories, I recall that this option used to disable
> the checks done at mount(?) time that compared the bits set in the block
> and inode bitmaps against the summary values in the group descriptors
> (AFAIR).  Or maybe it was comparing the group descriptor summary values
> against the superblock values?
> 
> In any case, I can't imagine why a user would have this set for a kernel
> option that might have last been valid 10 years ago, and why the 5 users
> in the world that might have this set cannot simply remove it from their
> fstab, since it does absolutely nothing?

Well, I agree that it should be deprecated, but that's a separate issue from
making ext4 handle all current ext2/3 mount options.

Let's just push this one in, and can do another patch to add the dire
deprecation warnings to all filesystems, ok?  Then in 5 more years we can
remember to remove it ;)

-Eric

>>> ---
>>> fs/ext4/super.c |    7 ++++++-
>>> 1 files changed, 6 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>>> index 3e1329e..5ff09e7 100644
>>> --- a/fs/ext4/super.c
>>> +++ b/fs/ext4/super.c
>>> @@ -1333,7 +1333,7 @@ enum {
>>> 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
>>> 	Opt_inode_readahead_blks, Opt_journal_ioprio,
>>> 	Opt_dioread_nolock, Opt_dioread_lock,
>>> -	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
>>> +	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable, Opt_nocheck,
>>> };
>>>
>>> static const match_table_t tokens = {
>>> @@ -1409,6 +1409,8 @@ static const match_table_t tokens = {
>>> 	{Opt_init_itable, "init_itable=%u"},
>>> 	{Opt_init_itable, "init_itable"},
>>> 	{Opt_noinit_itable, "noinit_itable"},
>>> +	{Opt_nocheck, "check=none"},
>>> +	{Opt_nocheck, "nocheck"},
>>> 	{Opt_err, NULL},
>>> };
>>>
>>> @@ -1905,6 +1907,9 @@ set_qf_format:
>>> 		case Opt_noinit_itable:
>>> 			clear_opt(sb, INIT_INODE_TABLE);
>>> 			break;
>>> +		case Opt_nocheck:
>>> +			/* ext2/ext3 used to "support" this option.  Silently eat it */
>>> +			break;
>>> 		default:
>>> 			ext4_msg(sb, KERN_ERR,
>>> 			       "Unrecognized mount option \"%s\" "
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

