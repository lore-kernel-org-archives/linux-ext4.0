From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs, xfstests git trees pushed
Date: Tue, 16 Dec 2014 22:34:16 -0500
Message-ID: <20141217033416.GV17575@thunk.org>
References: <20141215193139.GA14298@thunk.org>
 <20141216205319.GW24183@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	fstests@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141216205319.GW24183@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 17, 2014 at 07:53:19AM +1100, Dave Chinner wrote:
> 
> And now pushed upstream, so your tree needs rebasing again.

Thanks; the workflow on my end is pretty straightforward.  "git pull
--rebase" generally does the trick without much fuss or bother.

I still have one patch left on ext4-test:

% git log --oneline master..
8a78b77 ext4/004: limit the amount of data written so test runs faster

but I'm sure that'll get picked up soon enough.

> Perhaps it would be better for kvm-xfstests to follow the upstream
> tree directly and work out some method of tagging the upstream tree
> that gives you a defined "release point" for your image builds.

There's a big fat warning on the github page that the branch is
constantly being rewound (ala linux-next) and not something should be
using for anything other than as release point.  So the current
workflow is fairly good from my perspective, and I point people at the
upstream git repo if they want to do any development.

Cheers,


	 	     	       	       	  - Ted
