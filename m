From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH] ext3: handle deleting corrupted indirect blocks
Date: Tue, 24 Jun 2008 15:17:01 +0100
Message-ID: <e9e943910806240717p158d1f8fgef0dea9a14630158@mail.gmail.com>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
	 <1214315240-22950-1-git-send-email-duaneg@dghda.com>
	 <4860FD66.60003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	"Sami Liedes" <sliedes@cc.hut.fi>
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:20990 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760675AbYFXORE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2008 10:17:04 -0400
Received: by rv-out-0506.google.com with SMTP id k40so7677592rvb.1
        for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 07:17:04 -0700 (PDT)
In-Reply-To: <4860FD66.60003@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/6/24 Eric Sandeen <sandeen@redhat.com>:
>> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
>> index 6ae4ecf..8019bf2 100644
>> --- a/fs/ext3/inode.c
>> +++ b/fs/ext3/inode.c
>> @@ -2127,7 +2127,20 @@ static void ext3_free_data(handle_t *handle, struct inode *inode,
>>
>>       if (this_bh) {
>>               BUFFER_TRACE(this_bh, "call ext3_journal_dirty_metadata");
>> -             ext3_journal_dirty_metadata(handle, this_bh);
>> +
>> +             /*
>> +              * The buffer head should have an attached journal head at this
>> +              * point. However, if the data is corrupted and an indirect
>> +              * block pointed to itself, it would have been detached when
>> +              * the block was cleared. Check for this instead of OOPSing.
>> +              */
>> +             if (bh2jh(this_bh))
>
> Should it also (or only) be checking for buffer_jbd rather than testing
> bh2jh which is just shorthand for "is b_private non-null?"

I don't think so. The bug was occurring because journal_dirty_metadata
dereferences b_private (via bh2jh) unconditionally. In practice
checking with buffer_jbd should be equivalent, but this way seems more
robust since it is checking the actual pointer being accessed rather
than a separate bit, albeit one that should be in sync with it.

> Also maybe I should know this intuitively by now, but what is the path
> where b_private / BH_JBD got cleared on this corrupted image?

Immediately above the change, in the ext3_free_data function, we call
ext3_clear_blocks to clear the indirect blocks in this parent block.
If one of those blocks happens to actually be the parent block it will
clear b_private / BH_JBD.

I did the check at the end rather than earlier as it seemed more
elegant. I don't think there should be much practical difference,
although it is possible the FS may not be quite so badly corrupted if
we did it the other way (and didn't clear the block at all). To be
honest, I'm not convinced there aren't other similar failure modes
lurking in this code, although I couldn't find any with a quick
review.

Just let me know if you think it should be done another way.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
