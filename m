From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Mon, 25 Apr 2011 18:58:24 -0600
Message-ID: <EBD186D7-7A9A-4EA4-AB05-D1E9CF2D5006@dilger.ca>
References: <1303762999-20541-1-git-send-email-curtw@google.com> <4194C4D6-BE86-42CA-BBB4-A8A0E7E94EAC@dilger.ca> <BANLkTim0_yS_zHEs9sksFq4u_FFEHGO+7g@mail.gmail.com> <BANLkTikA83YP4p3JL=SFqNAnNzvPSaC7Bg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, jim@meyering.net, cmm@us.ibm.com,
	hughd@google.com, tytso@mit.edu
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:59259 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab1DZA60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 20:58:26 -0400
In-Reply-To: <BANLkTikA83YP4p3JL=SFqNAnNzvPSaC7Bg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-25, at 5:20 PM, Curt Wohlgemuth wrote:
> On Mon, Apr 25, 2011 at 3:45 PM, Curt Wohlgemuth <curtw@google.com> wrote:
>> On Mon, Apr 25, 2011 at 3:40 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>>> On 2011-04-25, at 2:23 PM, Curt Wohlgemuth wrote:
>>>> In the bio completion routine, we should not be setting
>>>> PageUptodate at all -- it's set at sys_write() time, and is
>>>> unaffected by success/failure of the write to disk.
>>>> 
>>>> This can cause a page corruption bug when
>>>> 
>>>>    block size < page size
>>>> 
>>>> @@ -203,46 +203,29 @@ static void ext4_end_bio(struct bio *bio, int error)
>>>> -             /*
>>>> -              * If this is a partial write which happened to make
>>>> -              * all buffers uptodate then we can optimize away a
>>>> -              * bogus readpage() for the next read(). Here we
>>>> -              * 'discover' whether the page went uptodate as a
>>>> -              * result of this (potentially partial) write.
>>>> -              */
>>>> -             if (!partial_write)
>>>> -                     SetPageUptodate(page);
>>>> -
>>> 
>>> I think this is the important part of the code - if there is a read-after-write for a file that was written in "blocksize" units (blocksize < pagesize), does the page get set uptodate when all of the blocks have been written and/or the writing is at EOF?  Otherwise, a read-after-write will always cause data to be fetched from disk needlessly, even though the uptodate information is already in cache.
>> 
>> Hmm, that's a good question.  I would kind of doubt that the page
>> would be marked uptodate when the final block was written, and this
>> might be what the code above was trying to do.  It wasn't doing it
>> correctly :-), but it might have possibly avoided the extra read when
>> it there was no error.
>> 
>> I'll look at this some more, and see if I can't test for your scenario
>> above.  Perhaps at least checking that all BHs in the page are mapped
>> + uptodate => SetPageUptodate would not be out of line.
> 
> My testing is now showing the read coming through after writing to the
> 4 blocks of a 4K file, using 1K blocksize.

Sorry, but could you please clarify?  Does "read coming through" mean that there is an IO sent to the disk, or that the page is uptodate and the read is handled from the page cache?

>  And it seems to me that
> this is taken care of in __block_commit_write(), which is called from
> all the .write_end callbacks for ext4, at least.

It does indeed look like that should be handling this case.  It would be good to verify that this is still true with your patch, just in case theory and reality don't align.

Cheers, Andreas





