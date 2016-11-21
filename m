From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] generic: test setting and getting encryption policies
Date: Tue, 22 Nov 2016 08:21:40 +1100
Message-ID: <20161121212140.GJ31101@dastard>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
 <1479412027-34416-3-git-send-email-ebiggers@google.com>
 <20161120220718.GJ28177@dastard>
 <20161121191145.GC30672@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>
To: Eric Biggers <ebiggers@google.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121191145.GC30672@google.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 21, 2016 at 11:11:45AM -0800, Eric Biggers wrote:
> On Mon, Nov 21, 2016 at 09:07:18AM +1100, Dave Chinner wrote:
> > Also, shouldn't a get without an args parameter always return
> > EINVAL, regardless of whether the underlying file is encrypted or
> > not?
> > 
> 
> For most syscalls/ioctls, including this one (FS_IOC_GET_ENCRYPTION_POLICY),
> it's not expected for the kernel to check that a userspace pointer is NULL as
> opposed to some other random invalid value.  It will only notice at the very end
> of the operation, when copying data to userspace, in which case it's expected to
> fail with EFAULT.

Ok, makes sense.

> > These should all be in a single xfstest that "tests ioctl
> > validity", rather than appended to a "set_policy behaviour"
> > test.
> 
> Yes this may make sense.  It gets a little blurry when you talk
> about testing behavior like "an encryption policy cannot be set on
> a directory", since that's a type of validation too.

Yes, it's a a type of validation, but I see it as a completely
different class of validation. That is, one set of tests is doing
boundary condition testing on the ioctl (i.e. does it reject invalid
input?), the other is doing behavioural tests (i.e. does it behave
correctly on different types of inodes given otherwise valid input?).

> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +here=`pwd`
> > > +echo "QA output created by $seq"
> > > +
> > > +. ./common/encrypt
> > 
> > This is not the way to include all the required scripts, as I
> > mentioned in my last email....
> > 
> > Also, please do not gut the test script preamble - it's there in the
> > new test template for good reason and that is that all the common
> > code that is included relies on the setup it does. e.g. this means $tmp
> > is not properly set, so any common code that has been included that
> > does 'rm -rf $tmp/*' if going to erase your root filesystem.
> > 
> 
> Will do.  I think it's pretty riduculous for xfstests to potentially erase your
> root filesystem if you don't set some random variable though...

$tmp is /not a random variable/. It is required to be set in every
test. The common code is unlikely to need to do something like "rm -rf
$tmp/*" but it does require it to be set. The rm -rf commands are more
likely to be found in test specific _cleanup functions which should
be defined immediately after $tmp....

> What would be nice is for there to be a preamble that all the tests source that
> handles these boilerplate tasks.

Just use the 'new' script to generate your test templates, and you
don't have to care.

> > > +_scratch_mount -o remount,ro,bind
> > 
> > Umm, what does a bind mount do when there's no source/target
> > directory? Whatever you are doing here is not documented in the
> > mount(8) man page....
> 
> As I noted in the comment above this is creating a readonly mount for a
> read-write filesystem.

I realise that. I was commenting on it not being done in the
documented way...

[snip the crazy]

> Perhaps using the new mount syntax to set up a bind mount on a different
> directory, rather than reusing the same directory, would make things less
> confusing?

Yes, that's a good idea...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
