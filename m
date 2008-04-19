From: Theodore Tso <tytso@mit.edu>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
	checker)
Date: Sat, 19 Apr 2008 18:04:32 -0400
Message-ID: <20080419220432.GB30449@mit.edu>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <480A42F6.2030005@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Apr 19, 2008 at 02:07:34PM -0500, Eric Sandeen wrote:
> 
> It seems to me that what the proposed project really does, in essence,
> is a read-only check of a filesystem snapshot.  It's just that the
> snapshot is proposed to be constructed in a complex and non-generic (and
> maybe impossible) way.

That's not a bad way of thinking about it; except that the snapshot is
being maintained in userspace, without any discussion of some kind of
filesystem-level freeze (which would be hard because the freeze, in
the best case, would take as long as e2image -r would take --- which
is roughly time required for e2fsck's pass1, which is in general
approximately 70% of the e2fsck run-time.)  

> If you really just want to verify a snapshot of the fs at a point in
> time, surely there are simpler ways.  If the device is on lvm, there's
> already a script floating around to do it in automated fasion.  (I'd
> pondered the idea of introducing META_WRITE (to go with META_READ) and
> maybe lvm could do a "metadata-only" snapshot to be lighter weight?)

That would be great, although I think the major issue is not
necessarily the performance problems of using an LVM snapshot on a
very busy filesystem (althouh I could imagine for some users this
might be an issue), but rather for filesystem devices that aren't
using LVM at all.  (I've heard some complaints that LVM imposes a
performance penalty even if you aren't using a snapshot; has anyone
done any benchmarks of a filesystem with and without LVM to see
whether or not there really is a significant performance penalty;
whether or not there really is one, the perception is definitely out
there that it does.)

If we could do a lightweight snapshot that didn't require an LVM, that
would be really great.  But that's probably not an ext4 project, and
I'm not sure the it would be considered politically correct in the
LKML community.

					- Ted
