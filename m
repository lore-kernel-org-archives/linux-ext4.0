From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: limit xattr size to INT_MAX
Date: Fri, 30 Mar 2018 17:19:24 -0400
Message-ID: <20180330211923.GD9300@thunk.org>
References: <20180329194125.GC3790@thunk.org>
 <20180330191320.7270-1-tytso@mit.edu>
 <20180330195016.GC180083@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        adilger@dilger.ca, wen.xu@gatech.edu, ebiggers@google.com,
        stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180330195016.GC180083@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 30, 2018 at 12:50:16PM -0700, Eric Biggers wrote:
> Hi Ted,
> 
> On Fri, Mar 30, 2018 at 03:13:20PM -0400, Theodore Ts'o wrote:
> >
> > Also if the xattr block is corrupted, mark the file system as
> > containing an error.
> 
> Weren't we doing that already?

Actually, not everywhere, but I decided to move that into a separate
commit and forgot to remove this from the description.  See the commit
"ext4: move call to ext4_error() into ext4_xattr_check_block()".

> > This issue has been assigned CVE-2018-1095.
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=199185
> > https://bugzilla.redhat.com/show_bug.cgi?id=1560793
> > 
> > Reported-by: Wen Xu <wen.xu@gatech.edu>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Cc: stable@vger.kernel.org
> 
> I'm still confused why you removed my Fixes: line and the mentions of the bug
> affecting external inode xattrs only.  Wasn't the size validation correct before
> then?  We might want to send d7614cc16146 to the stable trees, but after that
> the sizes were being validated correctly, right?

Sorry, I forgot to add back the Fixes line.   I'll fix that.

I removed the text because it was confusing me when I was originally
parsing it.  (The details of the ea-in-inode code had been swapped
out, I'm embarassed to say.)  I do see what you are driving at, and
I'll add some text that makes the point you are trying to make.

> I still think the new checks here are misleading and shouldn't be added.  If
> someone can actually modify the buffer_head concurrently then they could just
> make the size larger than the block but <= INT_MAX, so that the following
> page(s) are also copied to the xattr, disclosing memory or crashing.  Or they
> could modify ->e_value_offs to point past the block.  Also since this is not
> using a volatile memory access, the compiler is free to reload the value and
> assume it's the same.

The most common case where we run into this problem is where it's not
a CPU-CPU race, but rather where the buffer head gets read into memory
and is validated, and then minutes later, file system corruption
causes the buffer head to be modifeid.  So I wasn't worried about
races where we would need to copy the buffer to a temp buffer, and
validate it every time before using it.

You're right that against someone who has both malicoiusly crafted the
corrupted file system, *and* maliciously crafts the access patterns to
deliberately trigger a race, the check that I've added isn't
sufficient.  Unfortunately, doing the copy and validate every time is
a problem from a performance perspective.

The condition I added does protect us against a class of attacks.  But
it is not a universal protection, agreed.  The way to fix the concern
you raised would be to add a check for
le16_to_cpu(entry->e_value_offs) before we using it.  But that's for a
different attack, and it's something we should add in a separate
commit.

Looking at fs/ext4/xattr.c, there are a number of places where we are
relying on buffer_verified() bit --- I'd call that a "target rich
environment" for fixes.  In my opinion, the check I added to fix this
POC attack, or an explicit check for entry->e_value_offs in
ext4_xattr_block_get() should be the primary protection for malformed
on-disk data structures that might lead to buffer overflow attacks,
since it eliminates the TOCTTOU gap.  The buffer_verified bit should
be a backup just in case we missed a check.

Cheers,

						- Ted

P.S.  If you are concerned that the extra checks makes it hard to find
bugs, I would much rather add a #ifdef which disable the the
ext4_xattr_*verify() functions, and see if Wen Xu's can find problems
--- and if so, we should fix them.
