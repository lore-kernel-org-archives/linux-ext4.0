From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Journal under-reservation bug on first >2G file
Date: Wed, 01 Oct 2014 15:37:17 -0500
Message-ID: <542C65FD.5040405@redhat.com>
References: <542B1C38.9010409@redhat.com> <542B1EFC.4050500@redhat.com> <C355A8E9-1799-43AB-9F57-4EFE1BBE3767@dilger.ca> <20141001115320.GA2903@thunk.org> <542C1314.3030603@redhat.com> <20141001195954.GD2903@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbaJAUhV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 16:37:21 -0400
In-Reply-To: <20141001195954.GD2903@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/1/14 2:59 PM, Theodore Ts'o wrote:
> On Wed, Oct 01, 2014 at 09:43:32AM -0500, Eric Sandeen wrote:
>>> That sounds like a plan.  If we only enable it automatically at mount
>>> time (iff we mounted the file system read/write) if any of the ext3 or
>>> ext4 specific features are enabled, that should be completely safe.
>>
>> Ok, so do that, and don't bump the reservations? I suppose
>> the size test & superblock write can be removed, then...
>>
>> This does bug me a little; at one point we were very carefully not
>> enabling any new features by mounting with a new kernel; that was
>> specific to mounting-ext2-with-ext4 etc, but it still feels slightly
>> inconsistent.  Although I guess we enable it today by mounting-and-
>> writing-a-big-enough-file.
> 
> Yeah, this behaviour was one that dates back a *long* time, before we
> established the rule that we don't enable any new features
> automatically.  If this was a new feature, I wouldn't be advocating
> this.  But if we change this now, we could introduce a regression, or
> at least a surprising breakage.
> 
>> Something like this should fix it too, though, with less unexpected
>> behind-your-back behavior:
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 3aa26e9..2f94cd6 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -2563,9 +2563,15 @@ retry_grab:
>>          * if there is delayed block allocation. But we still need
>>          * to journalling the i_disksize update if writes to the end
>>          * of file which has an already mapped buffer.
>> +        * If this write might need to update the superblock due to the
>> +        * filesize adding a new superblock feature flag, add that too.
>>          */
>>  retry_journal:
>> -       handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, 1);
>> +       handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
>> +                                   EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> +                                       EXT4_FEATURE_RO_COMPAT_LARGE_FILE) ?
>> +                                   1 : 2);
>> +
> 
> Yes, I suppose that would work as well.  It means that file systems
> which don't have LARGE_FILE will waste a bit more space in the
> journal, causing the journal to potentially close prematurely.
> 
> The code would be a bit simpler if we removed "set only if i_size has
> gotten too big", and replaced it with a "set it unconditionally at
> mount time".  So there are tradeoffs with either approach.  At this
> point I'm slightly in favor of enabling it by default if ext4 features
> are enabled, either in the kernel or in the e2fsck.  And if we're
> going to do that, doing it in the kernel is more foolproof, and it
> will have the same net result.

Ok.  I guess this is only an issue for ext4 - well, at least this specific
issue.  Delalloc makes it much different than ext2 & ext3, which reserve quite a
lot more.  Whether there's a corner case over there which breaks, I dunno...

So it seems like the simplest test is simply: Are we RW mounted with delalloc?
And if so, update the feature.  Seems simpler than mucking with "which features
are unique to ext4"

(because we could be mounting ext3-with-ext4, having no ext4-specific features,
and still hit the problem right?   ... test test test ... right.)

I'll whip that up.

Thanks,
-Eric

> 				- Ted
> 

