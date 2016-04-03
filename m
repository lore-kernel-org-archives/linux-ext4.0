From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A few more filesystem encryption questions
Date: Sun, 3 Apr 2016 03:41:07 -0400
Message-ID: <20160403074106.GF3334@thunk.org>
References: <20160403055833.GA3214@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, jaegeuk@kernel.org,
	mhalcrow@google.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160403055833.GA3214@zzz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 03, 2016 at 12:58:33AM -0500, Eric Biggers wrote:
> 
> I found that a process without access to the master encryption key can read a
> file's full decrypted contents, provided that the file was opened recently by a
> process with access to the key.  This is true even if the privileged process
> merely opened and closed the file, without reading any bytes.  A similar story
> applies to filenames; a 'ls' by a process able to decrypt the names reveals them
> to all users/processes.  Essentially, it seems that despite the use of the
> kernel keyrings mechanism where different users/processes can have different
> keys, this doesn't fully carry over into filesystem encryption.  Is this a known
> and understood limitation of the design?

Yes.  I've regretted the use of keyrings and their IMHO, extremely
overly complex visibility rules.  The problem is that the page cache
and the dentry cache are global, and don't have the same complex
visibility rules as the keyring.  Since root can always gain access to
any user's keyring, one way or another, trying to restrict root is a
fool's errand from a security perspective.

I've considered using a single, global keyring and tying it to the
file system's struct super, and then adding explicit key management
ioctl's and not using the keyring space interface --- especially since
I consider keyctl to have a mostly user-hostile interface.

> The design document states that an encryption policy can be changed "if the
> directory is empty or the file is 0 bytes in length".  However, the code doesn't
> allow an existing encryption policy to be changed.  Which behavior was intended?

What is in the the design document has the original intention, but we
changed things deliberately.

Right now we enforce a very simple policy where an unencrypted
directory can contain encrypted directory (or files), but all of the
files or subdirectories in an encrypted directory must be encrypted,
and have the same policy (e.g., the same encryption algorithm and
key).

The reason for that is while the file names are encrypted, the inode
number is not integrity protected.  So an attacker can carry out an
off-line attacker where she can modify an directory entry so that it
points to some other file.  Specifically, the attacker could change a
directory inside a user's files to point at an unencrypted directory,
and then move the encrypted files into that unencrypted directory.  If
she can guess/reconstruct the filenames, the application might not
notice that tricky business had gone on, and any new files created in
that directory would be unencrypted.  As another potential attack, the
application might be tricked into appending personal data to an
unencrypted file.

To get around these problems, we constructed a simple rule which
essentially requires that top-level directory (e.g., /home) might be
unencrypted, and different directories underneath that directory might
be encrypted using different keys (e.g., /home/alice and /home/bob),
all of the files and subdirectories in /home/alice would have the same
key.

When the user logs in the system can verify that /home/alice has the
correct key, and then by inductive reasoning we can know that
everything under /home/alice will also have the correct key, or the
kernel will return an error.  This has to be enforced in the file
system, because applications aren't going to be checking to make sure
directories have the correct encryption policy.

I've thought about having more complex policies, so that
/home/alice/wallet would have "stronger" key than "/home/alice", with
some kind of data integrity protected xattr that certifies that the
/home/alice/wallet directory has a particular name and should have a
particular policy, and this would have a MAC keyed with the encryption
key of the parent directory.  But this is something that is not yet
been fully designed out, let alone implemented.

When it is, at that point we would allow a subdirectory to be created,
and have its encryption policy changed.

> I had brought up the question of the endianness of the XTS tweak value.  I also
> realized that since the page index is used, the XTS tweak will be dependent on
> PAGE_SIZE.  So the current behavior is that an encrypted filesystem can only be
> read on a device with the same endianness _and_ PAGE_SIZE.  Is is the case that
> due to the early Android users, it is too late to start using the byte offset
> instead of the PAGE_SIZE?  What about if the XTS tweak was fixed as the number
> of 4096-byte blocks from the start of the file as a le64 --- is that what the
> existing users are expected to be doing in practice?  Are there any
> architectures with PAGE_SIZE < 4096 for which that value wouldn't work?

Right now, we have a much more fundamental limitation, which is the
code requires that the page size be the same as the encryption block
size.  So the page index is the same as the logical block number.

This is a restriction that would be good to lift at some point, but
there are some things that make this not so simple, which is why we
took a bit of a short cut here at least for now.

(BTW, Linux fundamentally assumes that page size is >= fs block size.
So there are no architectures with a page size < 4096.  There are some
architectures with a page size > 4096, and this is where things will
get a bit complicated, since if you have a 64k page size, and you
mount a 4k encrypted file system, each 4k block would have to be
encrypted or decrypted separately, and it would make the readpage()
and writepage() operation much more complicated..)

Cheers,

						- Ted
