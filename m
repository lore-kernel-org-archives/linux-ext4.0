From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Mon, 19 May 2008 20:29:21 -0400
Message-ID: <200805192029.21688.chris.mason@oracle.com>
References: <482DDA56.6000301@redhat.com> <200805191439.36577.chris.mason@oracle.com> <20080519223959.GA14602@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080519223959.GA14602@atrey.karlin.mff.cuni.cz>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 19 May 2008, Jan Kara wrote:
> > On Monday 19 May 2008, Chris Mason wrote:
> > > Here's a test workload that corrupts ext3 50% of the time on power fail
> > > testing for me.  The machine in this test is my poor dell desktop
> > > (3ghz, dual core, 2GB of ram), and the power controller is me walking
> > > over and ripping the plug out the back.
> >
> > Here's a new version that still gets about corruptions 50% of the time,
> > but does it with fewer files by using longer file names (240 chars
> > instead of 160 chars).
> >
> > I tested this one with a larger FS (40GB instead of 2GB) and larger log
> > (128MB instead of 32MB).  barrier-test -s 32 -p 1500 was still able to
> > get a 50% corruption rate on the larger FS.
>
>   Hmm, this is worse than I'd have expected :( If it is that bad, I
> think we should really enable them by default... I can give your script
> a try on my test machine when I get back (which is next week).

That would be great, I'd like to confirm that my machine isn't the only one on 
the planet so easily broken ;)

I was also able to trigger corruptions on XFS (one run out of two), so it is 
unlikely I'm seeing bugs in the ext3 replay or logging code.

-chris
