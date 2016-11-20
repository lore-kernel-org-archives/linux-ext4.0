From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] generic: test encrypted file access
Date: Mon, 21 Nov 2016 09:31:51 +1100
Message-ID: <20161120223151.GK28177@dastard>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
 <1479412027-34416-4-git-send-email-ebiggers@google.com>
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
In-Reply-To: <1479412027-34416-4-git-send-email-ebiggers@google.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 17, 2016 at 11:47:06AM -0800, Eric Biggers wrote:
> Test accessing encrypted files with and without the encryption key.
> Access with the key is more of a sanity check, whereas access without
> the key should result in some particular behaviors.
> 
> As noted in the comment, as currently written this test is expected to
> fail on ext4 pre-4.8 and f2fs pre-4.6.  This could be avoided by using
> the filesystem-specific key prefix instead of the generic one, but I'd
> prefer to have the tests use the generic prefix.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
....
> +
> +cd $SCRATCH_MNT

Just noticed this, but it's in all the tests. We don't tend to
move into the test directories like this, because that means we
have to cd back out when we need to cycle a mount.

Just prepend things that are created with $SCRATCH_MNT/, or use
local variables for everything that hide this. e.g:

dirs="$SCRATCH_MNT/edir $SCRATCH_MNT/ref_dir"

mkdir $dirs
for dir in $dirs; do
....

> +
> +mkdir edir ref_dir
> +keydesc=$($FSCRYPT_UTIL gen_key)
> +$FSCRYPT_UTIL set_policy $keydesc edir > /dev/null
> +for dir in edir ref_dir; do
> +	touch $dir/empty > /dev/null
> +	$XFS_IO_PROG -t -f -c "pwrite 0 4k" $dir/a > /dev/null
> +	$XFS_IO_PROG -t -f -c "pwrite 0 33k" $dir/abcdefghijklmnopqrstuvwxyz > /dev/null
> +	maxname=$(yes | head -255 | tr -d '\n') # 255 character filename
> +	$XFS_IO_PROG -t -f -c "pwrite 0 1k" $dir/$maxname > /dev/null
> +	ln -s a $dir/symlink
> +	ln -s abcdefghijklmnopqrstuvwxyz $dir/symlink2
> +	ln -s $maxname $dir/symlink3
> +	mkdir $dir/subdir
> +	mkdir $dir/subdir/subsubdir
> +done
> +# Diff encrypted directory with unencrypted reference directory
> +diff -r edir ref_dir
> +# Cycle mount and diff again
> +cd $here
> +_scratch_cycle_mount
> +cd $SCRATCH_MNT
> +diff -r edir ref_dir
> +
> +# Now try accessing the files without the encryption key.
> +# It should still be possible to list the directory and remove files.
> +# But filenames should be encrypted, and it should not be possible to read
> +# regular files or to create new files or subdirectories.
> +cd $here
> +_scratch_unmount
> +$FSCRYPT_UTIL rm_key $keydesc
> +_scratch_mount
> +cd $SCRATCH_MNT
> +if [ $(ls edir | wc -l) -ne 8 ]; then
> +	echo "Wrong number of files"
> +	exit 1
> +fi

Number matching can done at the end of the test via the golden
image comparison. i.e. all you do here is:

ls edir | wc -l

And if the result is wrong then the test harness will catch it at
the end of the test.

But, then again, why wouldn't you just dump:

ls -lR edir |_filter_scratch

to the golden output file to confirm everything is exactly as you
expect it to be in the encrypted directory? It'll catch un-encrypted
names, wrong subdir depth, etc.


> +if [ -e edir/empty -o -e edir/symlink ]; then
> +	echo "Filenames were not encrypted!"
> +	exit 1
> +fi

stat edir/empty edir/symlink > /dev/null

And that will dump the error messages (No such file or directory)
to the golden output file. Again, test harness will catch
mismatches.

> +if [ $(find edir -mindepth 2 -maxdepth 2 -type d | wc -l) -ne 1 ]; then
> +	echo "Wrong number of subdirs"
> +	exit 1
> +fi

find edir -mindepth 2 -maxdepth 2 -type d | wc -l

> +cat $(find edir -maxdepth 1 -type f | head -1) 2>tmp
> +if ! egrep -q 'Required key not available' tmp; then
> +	echo "Reading encrypted file w/o key didn't fail with ENOKEY"
> +	cat tmp
> +	exit 1
> +fi

md5sum `find edir -maxdepth 1 -type f | head -1` | _filter_scratch

You'll either get a md5sum of the data or an error message
in the golden output. The wrong one will trigger a failure.

> +ls -l edir > /dev/null # should succeed

No necessary if you've already use ls -lR to validate all the above
files...

> +# There are some inconsistencies in which error codes are returned on different
> +# kernel versions and filesystems when trying to create a file or subdirectory
> +# without access to the parent directory's encryption key.  Furthermore, on some
> +# kernels correctly encoded filenames cause a different error (EACCES instead of
> +# ENOENT) because these names make it though ->lookup() and fail in ->create()
> +# or ->mkdir() instead.  For now we just accept multiple error codes.
> +
> +$XFS_IO_PROG -f edir/newfile &> tmp
> +if ! egrep -q 'Permission denied|No such file or directory' tmp; then
> +	echo "Creating file w/o key (unencoded) didn't fail with EACCES or ENOENT"
> +	cat tmp
> +	exit 1
> +fi

filter_enoent()
{
	sed -e 's/No such file or directory/Permission denied/'
}

filter_eperm()
{
	sed -e 's/Operation not permitted/Permission denied/'
}

$XFS_IO_PROG -f edir/newfile 2>&1 >/dev/null | _filter_enoent
mkdir edir/newfile  2>&1 >/dev/null | filter_enoent
$XFS_IO_PROG -f edir/0123456789abcdef 2>&1 >/dev/null | filter_eperm
mkdir edir/0123456789abcdef  2>&1 >/dev/null | filter_eperm

> +rm -r edir # should succeed
> +[ -e edir ] && echo "Directory wasn't deleted!"

ls edir

> +echo "Silence is golden."

No, not in this case. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
