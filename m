From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: ext3: slow symlink corruption on umount...
Date: Fri, 31 Oct 2008 20:47:20 +1100
Message-ID: <200810312047.20306.nickpiggin@yahoo.com.au>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081029210949.GA27274@mit.edu> <4909B8D6.7070206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Arthur Jones <ajones@riverbed.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	sct@redhat.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754622AbYKCDEk@vger.kernel.org>
In-Reply-To: <4909B8D6.7070206@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Friday 31 October 2008 00:38, Eric Sandeen wrote:
> Theodore Tso wrote:
> > On Wed, Oct 29, 2008 at 03:36:33PM -0500, Eric Sandeen wrote:
> >> Sorry for the silence, this is a nice bug you've found :)
> >>
> >> I'll look into it ...
> >
> > You may want to take a quick look at this thread:
> >
> >     http://lkml.org/lkml/2008/10/28/413
> >
> > 					- Ted
>
> I thought about that, but at least at first glance I don't see how the
> gfp mask change would cause this behavior...?  At least, I don't think
> we're seeing recursion back into the filesystem... but I'll ponder that.

That's definitely a bug which I'll have to fix for 2.6.28, but
I agree it's unlikely to recurse frequently like this (would only
happen under high memory pressure, and only when writeout from
page reclaim happens).


> (Also, Arthur reports seeing this as long ago as 2.6.9...)

OK, well that would confirm it.
