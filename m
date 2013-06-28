From: Nagachandra P <nagachandra@gmail.com>
Subject: Re: Memory allocation can cause ext4 filesystem to be remounted r/o
Date: Fri, 28 Jun 2013 19:22:51 +0530
Message-ID: <CAFy9=U4+OmqvtuDv646EWYmmF58-Nh-GhRc47FPQzcttSY25ig@mail.gmail.com>
References: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
	<20130626140205.GE3875@thunk.org>
	<20130626145417.GB32092@thunk.org>
	<CAFy9=U5O9qQP5QU_Nw4fEbfy2oVxUub=ddYgJ_ZKXmjdChO4iA@mail.gmail.com>
	<20130626163450.GA2487@thunk.org>
	<CAFy9=U5m5uew586C2eZJ7HjkRN5PvKr8+FoDdj8xtJoBeuP-_A@mail.gmail.com>
	<20130626180345.GA4128@thunk.org>
	<CAFy9=U5bPbDqfU=NVdaxvK5gNX9O33LD6mYJYqoTQLq7UTjqFw@mail.gmail.com>
	<20130627173652.GA22107@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Vikram MP <mp.vikram@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36040 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3F1Nwx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Jun 2013 09:52:53 -0400
Received: by mail-lb0-f172.google.com with SMTP id v20so1050077lbc.3
        for <linux-ext4@vger.kernel.org>; Fri, 28 Jun 2013 06:52:51 -0700 (PDT)
In-Reply-To: <20130627173652.GA22107@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks a lot for explaining this.

I will have a look into the jbd2 code for having similar
implementation on ext4 as well. I will keep you posted on any patches
we try out and get your opinion.

Best regards
Naga

On Thu, Jun 27, 2013 at 11:06 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jun 27, 2013 at 06:28:21PM +0530, Nagachandra P wrote:
>> Hi Theodore,
>>
>> Could you point me to the code where ext4_std_err is not triggered
>> because of LMK? As I see it, if a memory allocation returns error in
>> some of the case ext4_std_error would invariably be called. Please
>> consider the following call stack
>
> Yes, that's one example where a memory allocation failure can lead to
> ext4_std_error() getting called, and I've already acknowledged that's
> one that we need to fix (although as I said, fixing it may be tricky,
> short of calling congestion_wait() and then retrying the allocation,
> and hoping that in the meantime the OOM killer has freed up some
> memory).
>
> If you'd could give me a list of other memory allocations where
> ext4_std_error() could get called, please let me know.  Note that in
> the jbd2 layer, though, we handle a memory allocation failure by
> retrying the allocation, to avoid this the file system getting marked
> read/only.  Examples of this include in jbd2_journal_write_metadata_buffer(),
> and in jbd2_journal_add_journal_head() when it calls
> journal_alloc_journal_head().  (Although the way we're doing the retry
> in the latter case is a bit ugly and we're not sleeping with a call to
> congestion_wait(), so it's something we should clean up.)
>
> To give you an example of the intended use of ext4_std_error(), if the
> journal commit code runs into a disk I/O error while writing to the
> journal, the jbd2 code has to mark the journal as aborted.  This could
> happen because the disk has gone off-line, or the HDD has run out of
> spare disk sectors in its bad block replacement pool, so it has to
> return a write error to the OS.  Once the journal has been marked as
> aborted, the next time the ext4 code tries to access the journal, by
> starting a new journal handle, or marking a metadata block dirty, the
> jbd2 function will return an error, and this will cause
> ext4_std_error() to be called so the file system can be marked as
> requiring a file system check.
>
> Regards,
>
>                                         - Ted
