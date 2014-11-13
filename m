From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstest generic/018 and ext4 defrag
Date: Thu, 13 Nov 2014 18:38:04 -0500
Message-ID: <20141113233804.GD28780@thunk.org>
References: <CAH2r5mvAGe-N0e2rOsEe4DBT1tRM0Uv8rNQChmQY+d7dkLxR2w@mail.gmail.com>
 <5465244D.2090708@redhat.com>
 <20141113220228.GC28780@thunk.org>
 <CAH2r5ms6W1GQwzC2TFb87PK8UpPXmCWikQZEnWpw6aZQNdry7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57630 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934464AbaKMXiI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 18:38:08 -0500
Content-Disposition: inline
In-Reply-To: <CAH2r5ms6W1GQwzC2TFb87PK8UpPXmCWikQZEnWpw6aZQNdry7w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2014 at 05:04:55PM -0600, Steve French wrote:
> Only other xfstest I saw failing on ext4 on 3.18-rc3 was generic/315
> (Ubuntu 14.10).
> 
> generic/315 [failed, exit status 1] - output mismatch (see
> /home/sfrench/xfstests/results//generic/315.out.bad)
>     --- tests/generic/315.out 2014-11-13 11:20:05.405440282 -0800
>     +++ /home/sfrench/xfstests/results//generic/315.out.bad 2014-11-13
> 13:34:57.346960909 -0800
>     @@ -1,2 +1,6 @@
>      QA output created by 315
>      Slience is golden
>     +ls: cannot access /mnt/test/testfile.315: No such file or directory
>     +./tests/generic/315: line 69: [: : integer expression expected
>     +File size is changed to ( Bytes)
>     +(see /home/sfrench/xfstests/results//generic/315.full for details)

That test works just fine for me.  The test is pretty simple; if the
file is not getting created, it sounds like problem with the fallocate
command.  I'd suggest trying to run the commands in tests/generic/315
by hand, and seeing what's going wrong, but I'm pretty sure this is a
configuration issue in your test environment.

This is one of the reasons why I set up the xfstests-bld /
kvm-xfstests infrastructure, BTW; it handles most of these setup
issues for ext4 developers who otherwise might not end up using
xfstests for regression testing.

					- Ted
