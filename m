From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 2/4] generic: test setting and getting encryption policies
Date: Mon, 21 Nov 2016 11:11:45 -0800
Message-ID: <20161121191145.GC30672@google.com>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
 <1479412027-34416-3-git-send-email-ebiggers@google.com>
 <20161120220718.GJ28177@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34909 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753180AbcKUTLt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2016 14:11:49 -0500
Received: by mail-pf0-f172.google.com with SMTP id i88so65412005pfk.2
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2016 11:11:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161120220718.GJ28177@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 21, 2016 at 09:07:18AM +1100, Dave Chinner wrote:
> 
> i.e. we put all the functionality into the xfs_io comaand interface,
> and it just passes through whatever the test script tells it. In
> this case, the set_policy command needs several options to set
> different parts of the policy appropriately.
> 
> The reason we tend to put this sort of thing into xfs_io is that
> when we need to write a new test, all the commands we need to
> construct specific policies/contexts already exist and we don't have
> to write new helpers for each test....
> 

Thanks, I'll consider this.

> 
> Also, shouldn't a get without an args parameter always return
> EINVAL, regardless of whether the underlying file is encrypted or
> not?
> 

For most syscalls/ioctls, including this one (FS_IOC_GET_ENCRYPTION_POLICY),
it's not expected for the kernel to check that a userspace pointer is NULL as
opposed to some other random invalid value.  It will only notice at the very end
of the operation, when copying data to userspace, in which case it's expected to
fail with EFAULT.

It would still make sense to pass in a valid pointer when testing some other
failure case, though, to avoid confusion.

> > +	verify_policy(dir, fd, &policy);
> > +
> > +	/* invalid pointer (get) */
> > +	if (ioctl(fd, FS_IOC_GET_ENCRYPTION_POLICY, NULL) != -1 ||
> > +	    errno != EFAULT) {
> > +		die("expected FS_IOC_GET_ENCRYPTION_POLICY to fail with "
> > +		    "EFAULT when invalid pointer specified");
> > +	}
> 
> EINVAL - this should never get to copyout to generate EFAULT, so
> should not require separate tests for having no policy vs a valid
> policy.

This is specifically testing the EFAULT case.  The directory has been assigned
an encryption policy, so it does indeed get to this case.

> 
> These should all be in a single xfstest that "tests ioctl validity",
> rather than appended to a "set_policy behaviour" test.

Yes this may make sense.  It gets a little blurry when you talk about testing
behavior like "an encryption policy cannot be set on a directory", since that's
a type of validation too.

> 
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +here=`pwd`
> > +echo "QA output created by $seq"
> > +
> > +. ./common/encrypt
> 
> This is not the way to include all the required scripts, as I
> mentioned in my last email....
> 
> Also, please do not gut the test script preamble - it's there in the
> new test template for good reason and that is that all the common
> code that is included relies on the setup it does. e.g. this means $tmp
> is not properly set, so any common code that has been included that
> does 'rm -rf $tmp/*' if going to erase your root filesystem.
> 

Will do.  I think it's pretty riduculous for xfstests to potentially erase your
root filesystem if you don't set some random variable though...

What would be nice is for there to be a preamble that all the tests source that
handles these boilerplate tasks.

> > +# Should *not* be able to set an encryption policy on a directory on a
> > +# filesystem mounted readonly.  Regression test for ba63f23d69a3: "fscrypto:
> > +# require write access to mount to set encryption policy".  Test both a regular
> > +# readonly filesystem and a read-write filesystem remounted with "ro,bind",
> > +# which creates a readonly mount for a read-write filesystem.
> > +echo -e "\n*** Setting encryption policy on readonly filesystem ***"
> > +mkdir readonly_mnt_dir
> > +_scratch_mount -o ro,remount
> 
> scratch_remount ro
> 
> > +$FSCRYPT_UTIL set_policy 0000111122223333 readonly_mnt_dir
> > +_scratch_mount -o rw,remount
> 
> scratch_remount rw
> 
> > +_scratch_mount -o remount,ro,bind
> 
> Umm, what does a bind mount do when there's no source/target
> directory? Whatever you are doing here is not documented in the
> mount(8) man page....

As I noted in the comment above this is creating a readonly mount for a
read-write filesystem.  This is the way to tell the kernel to change the mount
flags to readonly but not the filesystem.  Think of "bind" as meaning "operate
on the mount, not on the filesystem".  Yes, mount(8) isn't clear that you can do
this.  It does document setting the readonly flag in the context of setting up a
new mount:

	mount --bind olddir newdir
	mount -o remount,ro,bind olddir newdir

The second command is misleading because 'olddir' isn't actually used at all;
the command is really just operating on 'newdir'.

Newer versions of mount also support 'mount -o bind,ro olddir newdir', which is
really only a shorthand for the above two commands.  mount can still only set
the readonly flag on the new mount using the mount syscall with
MS_RDONLY|MS_BIND|MS_REMOUNT.

Perhaps using the new mount syntax to set up a bind mount on a different
directory, rather than reusing the same directory, would make things less
confusing?

Eric
