From: Jan Kara <jack@suse.cz>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Tue, 15 Sep 2015 07:31:20 +0200
Message-ID: <20150915053120.GC2392@quack.suse.cz>
References: <20150831061920.GA2751@quack.suse.cz>
 <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
 <20150902165201.GW12432@techsingularity.net>
 <20150902184522.GA10390@birch.djwong.org>
 <CA+55aFy4LZP3_eNq=tBjkbPaVVRuQxuXRXV=+yLsvqzD9jXqyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFy4LZP3_eNq=tBjkbPaVVRuQxuXRXV=+yLsvqzD9jXqyA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 02-09-15 16:47:24, Linus Torvalds wrote:
> On Wed, Sep 2, 2015 at 11:45 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Wed, Sep 02, 2015 at 05:52:01PM +0100, Mel Gorman wrote:
> >> On the flip side, there does not appear to be any good reason for
> >> keeping the ext3 driver around because if there ever is a case where an
> >> old kernel is required to mount an ext3 filesystem then it appears the
> >> ext4 developers would consider it a bug.
> >
> > Yes, that would be a bug.
> 
> So the thing I'm happy to see is that the ext4 developers seem to
> unanimously agree that maintaining ext3 compatibility is part of their
> job, and nobody seems to be arguing for keeping ext3 around. As long
> as any possible regressions from ext3 removal have a clear "yup, it's
> on us" from the ext4 people,  I don't mind removing it. I was
> expecting ext4 people to not be thrilled about supporting possible
> legacy cases.
> 
> As a result, I'm personally convinced. I'll get around to the
> filesystem pulls tomorrow unless something unexpected happens, and
> expect to pull Jan's ext3-removal tree unless somebody suddenly speaks
> up.

Thanks for pulling. Next time I will do a better job when writing a
changelog for such large change. We were discussing this on and off for
last two years with other ext4 developers so when I finally decided the
time for removal has come, it felt obvious to me...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
