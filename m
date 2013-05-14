From: Jan Kara <jack@suse.cz>
Subject: Re: EXT4 regression caused 4eec7
Date: Wed, 15 May 2013 00:04:14 +0200
Message-ID: <20130514220414.GD10769@quack.suse.cz>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17>
 <20130510192747.GA11707@thunk.org>
 <87y5bm53z3.fsf@openvz.org>
 <87txm96fkd.fsf@openvz.org>
 <87mws1eq6y.fsf@openvz.org>
 <20130511230559.GD26298@thunk.org>
 <87a9o01siw.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	EUNBONG SONG <eunb.song@samsung.com>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87a9o01siw.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 12-05-13 13:01:11, Dmitry Monakhov wrote:
> On Sat, 11 May 2013 19:05:59 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Sat, May 11, 2013 at 03:00:53PM +0400, Dmitry Monakhov wrote:
> > > I've bisected ext4 related issue. It is appeared that it is pure ext4
> > > specific. Regression caused by  following commit
> > > commit 4eec708d263f0ee10861d69251708a225b64cac7
> > > Author: Jan Kara <jack@suse.cz>
> > > Date:   Thu Apr 11 23:56:53 2013 -0400
> > >     ext4: use io_end for multiple bios
> > 
> > Hmm... the next question is why did I see this in my testing.  Did you
> > find this on ia64, or x86?
> No simple x86_64. 
> > Also what about the slab corruption which
> > you saw when running XFS; was that unrelated?
> My theory about mysterious corruption in mm layer which broke everything
> was wrong. We have to absolutely independent regressions in  different
> filesystems:
> * Slub corruption on XFS
>   - testcase: xfstests/generic/007
>   - bad commit: 666d64 
>   - LINK: https://lkml.org/lkml/2013/5/11/154
> 
> * Slub corruption on EXT4
>   - testcase: xfstests/generic/299
>   - bad commit: 4eec70
>   - link: https://lkml.org/lkml/2013/5/11/37
>   - fix: https://lkml.org/lkml/2013/5/11/142
> 
> In fact '4eec70' are vexing because I have reviewed and tested this patch
> before it was marked as Review-by, but missed the bug. This is because
> xfstests was executed manually logs was full of warnings but tainted flag
> was not checked at the end. To prevent this thing in future I'll always
> use my local autotest(http://autotest.github.io/) farm next time.
  OK, so I finally nailed this down. DIO code has that peculiarity that it
doesn't call ->end_io callback when no IO was actually submitted. As a
bonus the generic code does a cleanup of generic stuff that is otherwise left
to ->end_io callback. Since I need to do io_end cleanup in ->end_io callback
I have to compensate for that in ext4_ext_direct_IO(). Sadly I've got the
condition wrong and also forgot that generic code already decremented
i_dio_count in the error failure case so cleanup sometimes happened twice.
I'll add fixed version of the patch back in my series (since the patch got
reverted upstream).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
