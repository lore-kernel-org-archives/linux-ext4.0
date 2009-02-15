From: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: [RESEND/PATCH] ext[234]: Return -EIO not -ESTALE on directory
	traversal missing inode
Date: Sat, 14 Feb 2009 23:53:48 -0500
Message-ID: <3e8340490902142053x18ae3c20q7018e0d8bc42636d@mail.gmail.com>
References: <1234588099-8445-1-git-send-email-bdonlan@fushizen.net>
	 <1234588688-9497-1-git-send-email-bdonlan@gmail.com>
	 <20090214141411.GD26628@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Bryan Donlan <bdonlan@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:56787 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbZBOExu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Feb 2009 23:53:50 -0500
In-Reply-To: <20090214141411.GD26628@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 14, 2009 at 9:14 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Sat, Feb 14, 2009 at 12:18:08AM -0500, Bryan Donlan wrote:
>> The ext[234]_iget() functions in the ext[234] family of filesystems returns
>> -ESTALE if invoked on a deleted inode, in order to report errors to NFS
>> properly. However, in ext[234]_lookup(), this -ESTALE can be propagated to
>> userspace if the filesystem is corrupted, and a inode is linked even
>> though it is marked as deleted.
>
> I'm not sure what you mean by "inode is linked" here.  All you are
> really proposing to do here is to remap the ESTALE error to EIO, yes?

Sorry, I meant "if the an inode marked as deleted is linked in a
directory" - describing what causes the condition. But yes, I'm
basically proposing to remap ESTALE to EIO here.

>> Apologies for the resend so quickly for those on the CC list - my mailer was
>> misconfigured and the mail rejected by vger.
>
> RESEND is a code word meaning --- "I sent this a few days/weeks ago
> and no one responded; please look at it again?" I was confused when I
> saw this, because I didn't remember seeing this, either in my inbox or
> in the ext4 patchwork (which is really great and helping me make sure
> I don't miss patches), so I spent a few extra minutes googling to see
> what had gotten missed until I finally got to your apologies section....

Sorry about that; it's my first patch submission so I'm not entirely
up to speed on such keywords...

> I received two copies with the RESEND keyword; so I guess that means
> you ended up sending it three times?  Anyway, apparently the first
> time you sent it your mailer was so badly misconfigured that it got
> dropped by mit.edu's mailer as well.  :-) In general if you end up
> resending, don't worry about flagging it as a resend; deleting
> duplicates is easy enough to do.

Okay then - hopefully it won't happen again, but I'll keep that in
mind if there is a next time :)

>
>> --- a/fs/ext2/namei.c
>> +++ b/fs/ext2/namei.c
>> @@ -66,8 +66,12 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
>>       inode = NULL;
>>       if (ino) {
>>               inode = ext2_iget(dir->i_sb, ino);
>> -             if (IS_ERR(inode))
>> -                     return ERR_CAST(inode);
>> +             if (unlikely(IS_ERR(inode))) {
>
> I'm dubious about unlikely() here; OTOH, penalizing the error case
> seems reasonable.

I can leave it without the unlikely(), as it was before, but as far as
I can tell, this should never happen under a non-corrupted, non-broken
hardware filesystem, so it seems like a reasonable annotation to me.

>> +                     if (PTR_ERR(inode) == -ESTALE)
>
> Please add a call to ext2_error() here, and in make a similar change
> for the ext3 and ext4 patches:
>
>                                ext2_error(dir->i_sb, "ext2_lockup",
>                                           "deleted inode referenced: %u",
>                                           ino);

Okay, I'll update the patch and resubmit.

Thanks,

Bryan Donlan
