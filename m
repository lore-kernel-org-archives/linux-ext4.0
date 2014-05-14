From: Dave Chinner <david@fromorbit.com>
Subject: Re: Separate mailing list for xfstests
Date: Thu, 15 May 2014 07:35:29 +1000
Message-ID: <20140514213529.GT26353@dastard>
References: <alpine.LFD.2.00.1405141508150.9727@localhost.localdomain>
	<53738316.20601@redhat.com> <53738597.70305@fb.com>
	<20140514160447.GA3974@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com,
	Chris Mason <clm@fb.com>, dchinner@redhat.com,
	linux-fsdevel@vger.kernel.org,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20140514160447.GA3974@thunk.org>
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

On Wed, May 14, 2014 at 04:04:47PM +0000, tytso@mit.edu wrote:
> On Wed, May 14, 2014 at 11:02:47AM -0400, Chris Mason wrote:
> > >> linux-fsdevel might seem as a good candidate for it, but still I
> > >> think that it deserves a separate ML to point people to.
> 
> I'm personally in favor of using linux-fsdevel since it might
> encourage more fs developers who aren't using xfstests yet to start
> using it.

I'd prefer a separate mailing list - I don't really like the idea of
burying general lists in large amounts of specific topic-related
traffic. That way lies lkml - a dumping ground for everything that
has no stopic-related lists and that results in a very low signal to
noise ratio. Comparitively speaking, -fsdevel has a high SNR, so we
should try to keep it that way. ;)

That said, I can see the value in sending update/release
announcements to -fsdevel, but I'd prefer to keep all the xfstests
traffic separate.  A separate list makes things like archive
searching and patch tracking much simpler....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
