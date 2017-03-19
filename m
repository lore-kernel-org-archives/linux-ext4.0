From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Add largedir feature
Date: Sun, 19 Mar 2017 19:54:40 -0400
Message-ID: <2F91584E-6351-4523-9821-54AD6A7CD889@dilger.ca>
References: <20170319133425.gxeg3mba3brvztjf@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E5C4DA09-759A-442F-8EDF-0D7F366CE7C5";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:33737 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752151AbdCSXzS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Mar 2017 19:55:18 -0400
Received: by mail-qt0-f195.google.com with SMTP id r45so15573584qte.0
        for <linux-ext4@vger.kernel.org>; Sun, 19 Mar 2017 16:54:48 -0700 (PDT)
In-Reply-To: <20170319133425.gxeg3mba3brvztjf@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E5C4DA09-759A-442F-8EDF-0D7F366CE7C5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Mar 19, 2017, at 9:34 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Sat, Mar 18, 2017 at 11:38:38PM -0600, Andreas Dilger wrote:
>> 
>> Actually, on a Lustre MDT there _are_ only zero-length files, since all
>> of the data is stored in another filesystem.  Fortunately, the parent
>> directory stores the last group successfully used for allocation
>> (i_alloc_group) so that new inode allocation doesn't have to scan the
>> whole filesystem each time from the parent's group.
> 
> So I'm going to ask a stupid question.  If Lustre is using only
> zero-length files, and so you're storing all of the data in the
> directory entries --- why didn't you use some kind of userspace store,
> such as Mysql or MongoDB?  Is it because the Lustre metadata server is
> all in kernel space, and using ext4 file system was the most
> expeditious way of moving forward?

Right - the Lustre servers are implemented in the kernel, to avoid
user-kernel data transfers from the network, and to avoid creating a new
disk filesystem while still allowing proper transactions.

> I'd be gratified... surprised, but gratified... if the answer was that
> ext4 used in this fashion was faster than MongoDB, but to be honest
> that would be very surprising indeed.  Most of the cluster file
> systems... e.g., GFS, hadoopfs, et.al, tend to use a purpose-built
> key-value store (for example GFS uses bigtable) to store the cluster
> metadata.
> 
>> The 4-billion inode limit is somewhat independent of large directories.
>> That said, the DIRDATA feature that is used for Lustre is also designed
>> to allow storing the high 32 bits of the inode number in the directory.
>> This would allow compatible upgrade of a directory to storing both
>> 32-bit and 64-bit inode numbers without the need for wholescale conversion
>> of directories, or having space for 64-bit inode numbers even if most
>> of the inodes are only 32-bit values.
> 
> Ah, I didn't realize that DIRDATA was still used by Lustre.  Is the
> reason why you haven't retried merging (I think the last time was
> ~2009) because it's only used by one or two machines (the MDS's) in a
> Lustre cluster?

Mostly because there hasn't been any interest for it whenever I proposed
merging it in the past. If there is some renewed interest in merging it
I could look into it...

> I brought up the 32-bit inode limit because Alexey was using this as
> an argument not to move ahead with merging the largedir feature.  Now
> that I understand his concerns are also based around Lustre, and the
> fact that we are inserting into the hash tree effectively randomly,
> that *is* a soluble problem for Lustre, if it has control over the
> directory names which are being stored in the MDS file.  For example,
> if you are storing in this gargantuan MDS directory file names which
> are composed of the 128-bit Lustre FileID, we could define a new hash
> type which, if the filename fits the format of the Lustre FID, parses
> the filename and uses the low the 32-bit object ID concatenated with
> the low-32 bits of the sequence id (which is used to name the target).

No, the directory tree for the Lustre MDS is just a regular directory
tree (under "ROOT/" so we can have other files outside the visible
namespace) with regular filenames as with local ext4.  The one difference
is that there are also 128-bit FIDs stored in the dirents to allow readdir
to work efficiently, but the majority of the other Lustre attributes
are stored in xattrs on the inode.

Cheers, Andreas

> On Sun, Mar 19, 2017 at 12:13:00AM -0600, Andreas Dilger wrote:
>> 
>> We have seen large directories at the htree limit unable to add new
>> entries because the htree/leaf blocks become fragmented from repeated
>> create/delete cycles.  I agree that handling directory shrinking
>> would probably solve that problem, since the htree and leaf blocks
>> would be compacted during deletion and then the htree would be able
>> to split the leaf blocks in the right location for the new entries.
> 
> Right, and the one thing that makes directory shrinking hard is what
> to do with the now-unused block.  I've been thinking about this, and
> it *is* possible to do this without having to change the on disk
> format.
> 
> What we could do is make a copy of the last block in the directory and
> write it on top of the now-empty (and now-unlinked) directory block.
> We then find where to find the parent pointer for that block by
> looking at the first hash value stored in the block if it is an index
> block, or hash the first directory entry if it is a leaf block, and
> then walk the directory htree to find the block which needs to be
> patched to point at the new copy of that directory block, and then
> truncate the directory to remove that last 4k block.
> 
> It's actually not that bad; it would require taking a full mutex on
> the whole directory tree, but it could be done in workqueue since it's
> a cleanup operation so we don't have to slowdown the unlink or rmdir
> operation.
> 
> If someone would like to code this up, patches would be gratefully
> accepted.  :-)
> 
> Cheers,
> 
> 					- Ted


Cheers, Andreas






--Apple-Mail=_E5C4DA09-759A-442F-8EDF-0D7F366CE7C5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYzxpCpIg59Q01vtYRAmwsAJ9GDIfwFYu2+rESzEvChzvxsqETsQCdGW40
mnwNB9X3+FRGLikGS2gf7aA=
=7BZ2
-----END PGP SIGNATURE-----

--Apple-Mail=_E5C4DA09-759A-442F-8EDF-0D7F366CE7C5--
