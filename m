From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Thu, 18 Nov 2010 13:39:02 -0500
Message-ID: <1290105319-sup-9243@think>
References: <20101116110058.GA4298@amd> <20101116130146.GG4757@quack.suse.cz> <4CE35A6D.2040906@redhat.com> <20101117043845.GA3586@amd> <4CE362B0.6040607@redhat.com> <20101117061057.GA3989@amd> <20101118030613.GQ3290@thunk.org> <20101117192900.da859ac7.akpm@linux-foundation.org> <20101118060000.GA3509@amd> <20101117222834.2bb36ee1.akpm@linux-foundation.org> <4CE53E56.4090501@redhat.com> <20101118091053.c275e1f2.akpm@linux-foundation.org> <4CE56AA5.4030705@redhat.com> <4CE56F79.9040807@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@kernel.dk>, "Ted Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4CE56F79.9040807@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Excerpts from Eric Sandeen's message of 2010-11-18 13:24:57 -0500:
> > Um, ok, then, to answer the question directly :
> > 
> > No, please don't delete those functions, it will break ENOSPC handling
> > in ext4 as shown by xfstests regression test #204 ...
> 
> Further - 
> 
> What is going on here is that with delayed allocation, ext4 takes reservations
> against free blocks based on the data blocks it must write out, and the
> worst-case metadata that the writeout may take.  Getting writeback failing
> with ENOSPC would be bad.
> 
> But then we wind up with a bunch of unflushed writes sitting on huge
> metadata reservations, and start hitting ENOSPC due to that worst-case
> reservation.  After a sync we have tons of free space again, because
> the worst-case space reservations turned into usually best-case
> reality.
> 
> That's what the function is used for; once we start filling up the
> fs, we proactively flush data to free up the worst-case metadata
> reservations.
> 
> Dropping it will put us back in the bad situation.
> 
> If there are other ideas to fix it, I'm all ears, but this worked.

s/ext4/btrfs/g  We do the accounting and kick IO in different places,
but the idea is pretty much the same.  Some of the reservations are
freed when we start the IO and some are freed when the IO is done.

I understand that XFS is similar but does the writeback from its own
internal radix tree in the sky.

-chris
