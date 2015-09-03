From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Thu, 3 Sep 2015 14:49:24 -0700
Message-ID: <20150903214924.GB10391@birch.djwong.org>
References: <20150831061920.GA2751@quack.suse.cz>
 <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
 <20150902165201.GW12432@techsingularity.net>
 <20150902184522.GA10390@birch.djwong.org>
 <CA+55aFy4LZP3_eNq=tBjkbPaVVRuQxuXRXV=+yLsvqzD9jXqyA@mail.gmail.com>
 <CAMu38xLf-b_re4vCFuZP3i6sR5gVZE25Wak4+s1KNd6heSST6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Albino B Neto <bino@riseup.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMu38xLf-b_re4vCFuZP3i6sR5gVZE25Wak4+s1KNd6heSST6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 03, 2015 at 08:28:38AM -0300, Albino B Neto wrote:
> 2015-09-02 20:47 GMT-03:00 Linus Torvalds <torvalds@linux-foundation.org>:
> > On Wed, Sep 2, 2015 at 11:45 AM, Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> >> Yes, that would be a bug.
> >
> > So the thing I'm happy to see is that the ext4 developers seem to
> > unanimously agree that maintaining ext3 compatibility is part of their
> > job, and nobody seems to be arguing for keeping ext3 around. As long
> > as any possible regressions from ext3 removal have a clear "yup, it's
> > on us" from the ext4 people,  I don't mind removing it. I was
> > expecting ext4 people to not be thrilled about supporting possible
> > legacy cases.
> 
> Good.
> 
> The future of ext4 ? Are you (developers) write other file system ?

Well I was working on a new one called EXT3000 with all new servos, but then I
had to reuse the start and stop controls for something else and now the whole
thing is SOL.  I guess I'll go watch a movie instead.

;)

--D

> 
> -- 
> Albino B Neto
> www.bino.us
> "Debian. Freedom to code. Code to freedom!" faw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
