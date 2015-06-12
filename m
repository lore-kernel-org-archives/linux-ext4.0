From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] xfstests-bld: exclude ext4 defrag tests from unsupported
 configurations
Date: Thu, 11 Jun 2015 20:24:21 -0400
Message-ID: <20150612002421.GB505@localhost.localdomain>
References: <20150610181319.GA23530@localhost.localdomain>
 <20150610192810.GB24181@thunk.org>
 <20150611200051.GA505@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:46692 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbbFLAYE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jun 2015 20:24:04 -0400
Received: by vnbf7 with SMTP id f7so3341127vnb.13
        for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2015 17:24:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150611200051.GA505@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Spoke too soon - hit what looks like the old problem on ARM running 4.1-rc7
on the ninth trial run.  Various components of the test are left in the 'D'
state after a familiar oops - kernel BUG at fs/jbd2/transaction.c:2150 while
truncating.

I'll see if I can still get the problem to appear on x86_64.

Eric

* Eric Whitney <enwlinux@gmail.com>:
> I haven't tried to run generic/068 in quite a while, but do see it's passing
> now.  I'll close the related bugzillas.  Do you know which patch fixed this?
> 
> Thanks,
> Eric
> 
> 
> * Theodore Ts'o <tytso@mit.edu>:
> > On Wed, Jun 10, 2015 at 02:13:19PM -0400, Eric Whitney wrote:
> > > Online defrag is not currently implemented for journaled data and
> > > bigalloc ext4 file systems.  The xfstests that exercise online defrag
> > > do not verify that the test file system supports that feature before
> > > executing, resulting in spurious test failures.  (In the case of
> > > ext4/307, the test reports success but actually fails because the
> > > e4compact test component is ignoring failures.)
> > > 
> > > For the time being, simply exclude these tests to eliminate the test
> > > failure noise.
> > > 
> > > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > 
> > Thanks, applied.  BTW, I had since removed data_journal.exclude
> > because generic/068 should be passing with data journalling enabled.
> > 
> > 		    	      	      	   - Ted
