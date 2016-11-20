From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] generic: test setting and getting encryption policies
Date: Mon, 21 Nov 2016 09:07:18 +1100
Message-ID: <20161120220718.GJ28177@dastard>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
 <1479412027-34416-3-git-send-email-ebiggers@google.com>
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
In-Reply-To: <1479412027-34416-3-git-send-email-ebiggers@google.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 17, 2016 at 11:47:05AM -0800, Eric Biggers wrote:
> Several kernel bugs were recently fixed regarding the constraints for
> setting encryption policies.  Add tests for these cases and a few more.

more comments below, but in general this sort of test should be
driven through xfs_io command line parameters.

i.e. we put all the functionality into the xfs_io comaand interface,
and it just passes through whatever the test script tells it. In
this case, the set_policy command needs several options to set
different parts of the policy appropriately.

The reason we tend to put this sort of thing into xfs_io is that
when we need to write a new test, all the commands we need to
construct specific policies/contexts already exist and we don't have
to write new helpers for each test....

> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  src/fscrypt_util.c    | 82 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/400     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/400.out | 24 ++++++++++++++
>  tests/generic/group   |  1 +
>  4 files changed, 195 insertions(+)
>  create mode 100755 tests/generic/400
>  create mode 100644 tests/generic/400.out
> 
> diff --git a/src/fscrypt_util.c b/src/fscrypt_util.c
> index de63667..9428cb4 100644
> --- a/src/fscrypt_util.c
> +++ b/src/fscrypt_util.c
> @@ -96,6 +96,7 @@ usage(void)
>  "    fscrypt_util gen_key\n"
>  "    fscrypt_util rm_key KEYDESC\n"
>  "    fscrypt_util set_policy KEYDESC DIR\n"
> +"    fscrypt_util test_ioctl_validation DIR\n"
>  );
>  	exit(2);
>  }
> @@ -276,6 +277,86 @@ static int set_policy(int argc, char **argv)
>  	return 0;
>  }
>  
> +/*
> + * Test that the kernel does basic validation of the arguments to
> + * FS_IOC_SET_ENCRYPTION_POLICY and FS_IOC_GET_ENCRYPTION_POLICY.
> + */
> +static int test_ioctl_validation(int argc, char **argv)
> +{
> +	const char *dir;
> +	int fd;
> +	struct fscrypt_policy policy;
> +
> +	if (argc != 1)
> +		usage();
> +	dir = argv[0];
> +
> +	fd = open(dir, O_RDONLY);
> +	if (fd < 0)
> +		die_errno("%s: Unable to open", dir);
> +
> +	/* trying to get encryption policy for unencrypted file */
> +	if (ioctl(fd, FS_IOC_GET_ENCRYPTION_POLICY, NULL) != -1 ||
> +	    (errno != ENODATA && errno != ENOENT)) {
> +		die("expected FS_IOC_GET_ENCRYPTION_POLICY to fail with "
> +		    "ENODATA or ENOENT when unencrypted file specified");
> +	}

Can we format these in the normal way? i.e.

	error = ioctl();
	if (error < 0 &&
	    (errno exceptions))
		die()

Also, shouldn't a get without an args parameter always return
EINVAL, regardless of whether the underlying file is encrypted or
not?

> +	/* invalid pointer */
> +	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, NULL) != -1 ||
> +	    errno != EFAULT) {
> +		die("expected FS_IOC_SET_ENCRYPTION_POLICY to fail with "
> +		    "EFAULT when invalid pointer specified");
> +	}

>From the command line, shouldn't this be triggered by "set_policy
NULL"?

> +	/* invalid flags */
> +	init_policy_default(&policy);
> +	policy.flags = 0xFF;
> +	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) != -1 ||
> +	    errno != EINVAL) {
> +		die("expected FS_IOC_SET_ENCRYPTION_POLICY to fail with "
> +		    "EINVAL when invalid flags specified");
> +	}

"set_policy -f 0xff"

> +
> +	/* invalid encryption modes */
> +	init_policy_default(&policy);
> +	policy.contents_encryption_mode = 0xFF;
> +	policy.filenames_encryption_mode = 0xFF;
> +	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) != -1 ||
> +	    errno != EINVAL) {
> +		die("expected FS_IOC_SET_ENCRYPTION_POLICY to fail with "
> +		    "EINVAL when invalid encryption modes specified");
> +	}

"set_policy -c 0xff -n 0xff"

> +
> +	/* invalid policy version */
> +	init_policy_default(&policy);
> +	policy.version = 0xFF;
> +	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) != -1 ||
> +	    errno != EINVAL) {
> +		die("expected FS_IOC_SET_ENCRYPTION_POLICY to fail with "
> +		    "EINVAL when invalid policy version specified");
> +	}

"set_policy -v 0xff"

> +
> +	/* success case */
> +	init_policy_default(&policy);
> +	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) != 0)
> +		die_errno("expected FS_IOC_SET_ENCRYPTION_POLICY to succeed");

"set_policy default"

> +	verify_policy(dir, fd, &policy);
> +
> +	/* invalid pointer (get) */
> +	if (ioctl(fd, FS_IOC_GET_ENCRYPTION_POLICY, NULL) != -1 ||
> +	    errno != EFAULT) {
> +		die("expected FS_IOC_GET_ENCRYPTION_POLICY to fail with "
> +		    "EFAULT when invalid pointer specified");
> +	}

EINVAL - this should never get to copyout to generate EFAULT, so
should not require separate tests for having no policy vs a valid
policy.

These should all be in a single xfstest that "tests ioctl validity",
rather than appended to a "set_policy behaviour" test.

> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, see <http://www.gnu.org/licenses/>.
> +#-----------------------------------------------------------------------
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +here=`pwd`
> +echo "QA output created by $seq"
> +
> +. ./common/encrypt

This is not the way to include all the required scripts, as I
mentioned in my last email....

Also, please do not gut the test script preamble - it's there in the
new test template for good reason and that is that all the common
code that is included relies on the setup it does. e.g. this means $tmp
is not properly set, so any common code that has been included that
does 'rm -rf $tmp/*' if going to erase your root filesystem.

> +_require_user
> +_begin_encryption_test
> +
> +cd $SCRATCH_MNT
> +
> +_require_user
> +_begin_encryption_test
> +
> +cd $SCRATCH_MNT

... because mounting scratch without having first run _scratch_mkfs
is just wrong. People familiar with xfstests setup are going to look
at this and think the test is broken, because it doesn't
_require_scratch, it doesn't run mkfs or mount, etc....

> +# Should *not* be able to set an encryption policy on a directory on a
> +# filesystem mounted readonly.  Regression test for ba63f23d69a3: "fscrypto:
> +# require write access to mount to set encryption policy".  Test both a regular
> +# readonly filesystem and a read-write filesystem remounted with "ro,bind",
> +# which creates a readonly mount for a read-write filesystem.
> +echo -e "\n*** Setting encryption policy on readonly filesystem ***"
> +mkdir readonly_mnt_dir
> +_scratch_mount -o ro,remount

scratch_remount ro

> +$FSCRYPT_UTIL set_policy 0000111122223333 readonly_mnt_dir
> +_scratch_mount -o rw,remount

scratch_remount rw

> +_scratch_mount -o remount,ro,bind

Umm, what does a bind mount do when there's no source/target
directory? Whatever you are doing here is not documented in the
mount(8) man page....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
