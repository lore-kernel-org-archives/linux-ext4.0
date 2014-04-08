From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v7] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
Date: Tue, 8 Apr 2014 20:55:04 +1000
Message-ID: <20140408105504.GE22917@dastard>
References: <1393769538-3784-1-git-send-email-linkinjeon@gmail.com>
 <20140316031745.GA9916@thunk.org>
 <CAKYAXd-EO0pp=wz_Tg+2NEw9Nyu23sKXc-3n-fZUieES3+xt7w@mail.gmail.com>
 <20140402164258.GH6901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37007 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756477AbaDHKzG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2014 06:55:06 -0400
Content-Disposition: inline
In-Reply-To: <20140402164258.GH6901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 02, 2014 at 12:42:58PM -0400, Theodore Ts'o wrote:
> Some final testing luckily caught a bug in your patch.  I'll fix it
> up, but for future reference, it's important to check to see if the
> handle is valid (i.e., we are not in no-journal mode) before using any
> of the journalling functions.  Otherwise, you will crash if you try
> using the code path when the file system does not have a journal.
> 
> BTW, I would strongly recommend using the automated regression test
> system found at:
> 
> 	git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git
> 
> It finds these sorts of problems very quickly.  After you build a
> kernel, running "kvm-xfstests -g quick" would have found the problem
> very quickly.  The fastest reproducer for the bug that I found is:
> "kvm-xfstests -c nojournal shared/001".

Hi Ted,

If you check the xfstests commit history, I think you'll find that
Namjae wrote the xfstests that triggered the failure you are
seeing.

You're just testing more esoteric configurations than most people do
- same as I do for XFS. We can't expect every developer to test
their code on every possible configuration before they submit
it.... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
