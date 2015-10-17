From: Dave Chinner <david@fromorbit.com>
Subject: Re: e2fsprogs: Richacl support
Date: Sun, 18 Oct 2015 09:59:10 +1100
Message-ID: <20151017225910.GT27164@dastard>
References: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
	<20151016231615.GF15011@thunk.org>
	<CAHc6FU5B35D30Cc0-iSAfKDrCfc29paYe-tg-GGP7KEH08+2rA@mail.gmail.com>
	<20151017143951.GA2678@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20151017143951.GA2678@thunk.org>
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

On Sat, Oct 17, 2015 at 10:39:51AM -0400, Theodore Ts'o wrote:
> On Sat, Oct 17, 2015 at 02:22:25AM +0200, Andreas Gruenbacher wrote:
> One way of dealing with this is would be use a new mount option to
> enable richacls (e.g., "richacl"), which older kernels would fail to
> recognize and would thus fail the mount.  This works since the most
> likely failure case is if the user boots into an older kernel.

I don't think this is a good idea. The rich-ACL feature bit is an
/on-disk format/ identifier. Both the kernel and the filesystem need
to support the feature for it to work, and that's exactly what we
use feature bits for.

For XFS userspace we also need this feature bit for xfs_repair so
that it doesn't attempt to validate the on-disk ACL format is in a
valid posix ACL format. IOWs, we need an on-disk feature bit to
indicate the on-disk format of the ACL in XFS.

Further, a user could mount the ext4 fs with "norichacl,acl" to
force the kernel to parse the rich acls as posix acls because
without a feature bit the fs does not know what format it's acls are
in on-disk. This will only end in tears for users.

> This doesn't protect against the case where someone is using richacls
> on a USB stick, and moves it over to another system --- but that seems
> like a use case that's not very likely.  It also doesn't help against
> someone using an old rescue cd-rom, but in that case, it's not clear
> that it's hugely problematic, either -- someone using rescue media has
> physical access to the machine, so access controls are generally not a
> major concern, and they are also not likely to be making wholesale
> changes to the file system where acl inheritance is going to be a
> primary concern, either.
> 
> This is basically how we handled the POSIX acl situation for ext4 ---
> we just required a mount option to enable it, originally and
> eventually we defaulted the option to always on once it was highly
> unlikely someone was going to be trying to install, say, a 2.6 kernel
> on an enterprise userspace --- which was not likely to work at all.

Using a mount option was wrong here, too, because ext4 was a *brand
new filesystem*. ext4 should have just defaulted to enabling posix
acls if the support was built into the kernel. Just like XFS had
already been doing for years before ext4 came along....

> What do you think?  If we really want to burn a feature flag, I'd
> probably use a RO_INCOMPAT flag rather than an INCOMPAT flag, on the
> theory that read-only mounts are much more often used for system
> administration.  But it might be using a mount option is a better way
> to go here.

I asked this same question on the kernel side of things. While I
think that from an "on-disk consistency" POV using RO_INCOMPAT would
be fine, from a user visible POV the behaviour won't be compatible
and so INCOMPAT makes sense from that perspective.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
