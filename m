From: "George Spelvin" <linux@horizon.com>
Subject: Re: Sign, more experimentation and broken features...
Date: 12 Mar 2013 08:04:25 -0400
Message-ID: <20130312120425.4665.qmail@science.horizon.com>
References: <20130312040649.GD18595@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:56034 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754991Ab3CLME0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Mar 2013 08:04:26 -0400
In-Reply-To: <20130312040649.GD18595@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I'm going to guess there may be problems with using the e2fsck -D
> option with bigalloc.  I could imagine potential problems with that,
> and it's probably not something we've explicitly tested. 

Ah.  I'll see if I can re-create and test that.

> Also, just to check.... all of this was done with the file system
> unmounted, right?

Definitely.  I would hope the lack of error message from e2fsck
made that clear, but I suppose it could have been mounted RO.

> The good news is that this appears to be a newly added group, so
> hopefully there was no data lost.

I noticed that, too.  I also have the ability to leave this FS alone for
a while, so I haven't touched it yet.  Is there some more useful debug
information to be gathered before I start contaminating the scene?

> It may be worth mounting the file system read-only and copying all of
> your data off before you do anything else....

Yeah, I'll have to borrow some additional drives to do that with...

> Also, it looks like there may be some problems with the metadata_csum
> option when resizing, either alone or in combination with bigalloc.
> Please note that I have ___not___ really done a lot of exhaustive
> testing with metadata_csum, since it's not in a released final state
> in e2fsprogs, and I've had lots of other things I've been busy trying
> to make sure is stablized.  For example, we are still working on
> fixing various test failures with bigalloc.  It's probably good enough
> for fairly simple workloads (mostly using fallocate and direct I/O),
> but there are corner cases which we are still working on fixing.

I've jyst been running it successfully on a few machines since my last round
of complaints, so I figured I'd try a *new* feature as well.  :-)

(I would have turned on INLINE_DATA too if I could figure out how to
enable it.  Ah, -O inline_data seems to be it.)

Unfortunately, I was stupid and didn't grab the latest e2fsprogs that
includes the bigalloc warnings.
