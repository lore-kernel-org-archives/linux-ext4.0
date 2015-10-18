From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: e2fsprogs: Richacl support
Date: Sun, 18 Oct 2015 22:46:23 +0200
Message-ID: <CAHc6FU6U-r4YjxdvhW_OAmdekzK-tBT62Hs_JBYFB0V65qDw4w@mail.gmail.com>
References: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
	<20151016231615.GF15011@thunk.org>
	<CAHc6FU5B35D30Cc0-iSAfKDrCfc29paYe-tg-GGP7KEH08+2rA@mail.gmail.com>
	<20151017143951.GA2678@thunk.org> <20151017225910.GT27164@dastard>
	<20151018003532.GD2678@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20151018003532.GD2678@thunk.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Sun, Oct 18, 2015 at 2:35 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Oct 18, 2015 at 09:59:10AM +1100, Dave Chinner wrote:
>> For XFS userspace we also need this feature bit for xfs_repair so
>> that it doesn't attempt to validate the on-disk ACL format is in a
>> valid posix ACL format. IOWs, we need an on-disk feature bit to
>> indicate the on-disk format of the ACL in XFS.
>>
>> Further, a user could mount the ext4 fs with "norichacl,acl" to
>> force the kernel to parse the rich acls as posix acls because
>> without a feature bit the fs does not know what format it's acls are
>> in on-disk. This will only end in tears for users.
>
> So at least for ext4, the richacl xattr using a completely different
> index, and so it's not possible to interpret the richacl as an acl.

It's the same on xfs.

> The only question is whether we pay attention to the richacl acl's at
> all.  One thing that's not clear to me is what VFS is supposed to do
> if an inode has both an Posix ACL xattr and a Richacl xattr at the
> same time.

The VFS will either look for POSIX ACLs or for a richacl; it won't
even notice if both are present.

> We're also not trying to validate the on-disk ACL format at all using
> e2fsck, just as we're not trying to validate say, the SELinux xattr.
> They are just bags of bits as far as e2fsck is concerned.

Right now, filesystems that e2fsck is perfectly happy with can still
cause errors when used. It would be nice to fix that.

With POSIX ACLs, this problem is slightly less severe because the ACL
isn't looked at for the owner; it would even be possible to replace a
corrupted POSIX ACL. Richacls unfortunately don't allow this
optimization.

>> I asked this same question on the kernel side of things. While I
>> think that from an "on-disk consistency" POV using RO_INCOMPAT would
>> be fine, from a user visible POV the behaviour won't be compatible
>> and so INCOMPAT makes sense from that perspective.
>
> If you believe that the only real use of richacl will be primarily for
> supporting Samba and NFSv4 servers, then using a read-only compat
> feature flag isn't that terrible, and it might be helpful in the case
> of someone using a rescue media that hasn't been updated yet to be
> able to access the system --- since it seems unlikely that the user
> would try to launch a Samba or NFSv4 server from a rescue CD.

You wouldn't be able to fsck a filesystem that has unknown features,
incompat or ro-incompat, from such a rescue environment.

> But I different people of good will can differ with each other, and at
> the end of the day I don't think it makes *that* much difference
> unless we drop the use of the feature flag entirely.

This really should be a feature flag and not a mount option, it just
doesn't make sense to switch at mount time.

>From this discussion, I'm even more convinced that we should use an
incompat feature rather than a ro-incompat feature.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
