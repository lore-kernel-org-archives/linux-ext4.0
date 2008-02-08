From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Fri, 8 Feb 2008 14:47:20 +0100
Message-ID: <20080208134720.GA9027@alice>
References: <20080131140137.GA20780@alice> <20080131154207.GA22201@alice> <20080204060055.GC7494@skywalker> <1202335188.6886.15.camel@norville.austin.ibm.com> <20080207125548.GA8701@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52738 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753522AbYBHNrW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2008 08:47:22 -0500
Content-Disposition: inline
In-Reply-To: <20080207125548.GA8701@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Aneesh Kumar K.V (aneesh.kumar@linux.vnet.ibm.com) wrote:
> On Wed, Feb 06, 2008 at 03:59:48PM -0600, Dave Kleikamp wrote:
> > 
> > File systems should not call BUG() due to a corrupt file system.
> > Instead the code should fail the operation, possibly marking the file
> > system read-only (or panicking) depending on the errors= mount option.
> > 
> 
> Eric Sandeen explained me the same on IRC. I was busy with the migrate
> locking bug. That's why i didn't update here. Today i tried to reproduce
> the problem using the image provided. But in my case it is not hitting
> the BUG_ON (mostly due to single cpu). I did look at the code and am not
> still not clear how we can hit that BUG_ON. prealloc free space pa_free is
> generated out of bitmap. So only if something corrupted bitmap after we
> initialized prealloc space we will hit this case. In mballoc we error out
> if the block allocated or fall in system zone. One thing i noticed is,
> the journal is corrupt. So the only possibility that i have is journal write
> resulted in bitmap corruption.
> 
> I also looked at the mballoc to make sure we don't panic in case of a
> corrupt bitmap. Below is the patch that i have now. This one is yet to
> go through the ABAT test but it would be nice to see whether the below
> change cause any other issues.
> 
> Eric ,
> can you run the test with below patch and see if this makes any
> difference ?. I know we are not fixing any bugs in the below patch.

hi,

so far i am not able to reproduce this on 2.6.24-08039-g488b5ec neither
with the
ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record.patch nor
without it. I will try 2.6.24-05749-g8af03e7 with the patch and your
change later today.

Greetings, Eric
