From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 4/4] generic: test locking when setting encryption policy
Date: Mon, 21 Nov 2016 15:41:06 -0800
Message-ID: <20161121234106.GH30672@google.com>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
 <1479412027-34416-5-git-send-email-ebiggers@google.com>
 <20161120223536.GL28177@dastard>
 <20161121192519.GE30672@google.com>
 <20161121213251.GL31101@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121213251.GL31101@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 22, 2016 at 08:32:51AM +1100, Dave Chinner wrote:
> 
> This means that reproducing the race condition is going to be
> machine dependent regardless of how the test is written.
> 
> In cases like this for XFS, we tend towards adding a debug sysfs
> file to introduce a delay into the code that allows the race to be
> triggered reliably. The delay is only included in CONFIG_XFS_DEBUG=y
> builds, and the test is conditional on the sysfs file being present.
> 
> e.g. xfs/051 uses a log recovery delay to allow us to reliably
> trigger IO errors in the middle of log recovery and hence exercise
> the IO error failure paths in the middle of recovery. This made an
> extremely unreliable reproducer into a test case that triggered
> reliably on every machine the test is run on....
> 
> Can something like this be done in this case?
> 

I'd really rather not do something like that just for this test, which is really
just testing that the kernel does inode_lock()/inode_unlock() in
fscrypt_process_policy().  It would be more worthwhile if the testing-only
kernel code would help expose many race conditions, not just this one particular
race in this particular ioctl.

So if you don't want to have the C version of this test in xfstests, I think it
should just be dropped from the series.

Eric
