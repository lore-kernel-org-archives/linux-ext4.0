From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] mess in jbd2_block_tag_csum_verify()
Date: Wed, 8 May 2013 23:58:37 +0100
Message-ID: <20130508225837.GB25399@ZenIV.linux.org.uk>
References: <20130508155130.GT25399@ZenIV.linux.org.uk>
 <41D3CA9A-6284-4E5A-97AD-4D11E2307B01@dilger.ca>
 <20130508164508.GA5625@blackbox.djwong.org>
 <20130508170751.GV25399@ZenIV.linux.org.uk>
 <20130508215541.GA7730@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59661 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3EHW6o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 18:58:44 -0400
Content-Disposition: inline
In-Reply-To: <20130508215541.GA7730@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 08, 2013 at 02:55:41PM -0700, Darrick J. Wong wrote:

> Interesting... I have something that calls itself sparse 0.4.3 and I don't see
> any endianness warnings at all.  Is endian checking new for 0.4.4?  Or maybe I
> simply don't have it configured correctly?

make C=2 CF=-D__CHECK_ENDIAN__ fs/jbd2/, actually.  Not sure if 0.4.3 will
be recent enough - the endianness checks per se are not a problem, but it
needs to recognize __builting_bswap32() as builtin instead of spewing
an error on undefined identifier...

> Hmm, I thought "__u" implied native endian.  Any reason why we need to force
> the parameter to "__be"?  I'd rather leave the call sites alone, but I don't
> have any strong opinions either way.

*shrug*

We can do
f(..., __u32 n,...)
{
	__be32 n1 = cpu_to_be32(n);
	...
}

or we can simply pass the result of conversion to the function and be
done with that.  IMO the latter is easier, especially when there is only
one caller to start with.  Per se passing around host-endian values
is neither better nor worse than passing big-endian ones - depends on which
variant ends up being more readable.

What we really shouldn't do is use of the same variable to hold host-endian
value at one point and big-endian at another; if compiler sees
	__be32 n1 = cpu_to_be32(n);
notices that this is the last use of n and reuses the same memory location -
let it, it's a valid optimization, but doing it manually and saying something
like
	n = cpu_to_be32(n);
is a Damn Bad Idea(tm).  Because sooner or later you'll lose track and end
up with e.g. a variable containing a host-endian some instruction if you take
one path leading to it and big-endian if you take another.  I've seen enough
bugs of that kind; it's a very bad habit.  Sane rules for endianness
stuff are very simple:
	* treat big-endian, little-endian and host-endian as separate types
	* use whatever makes for more readable code
	* do arithmetics only on host-endian
	* do bitwise operations only on the values of the same type and
treat result of such operation as value of the same type
	* use explicit conversions; the fact that cpu_to_le32 and le32_to_cpu
shuffle the bits in the same way is an accident.  The former should be
used only on host-endian, the latter - only on __le32.  Sure, they'll produce
the same instructions; let compiler take care of that.
	* don't mix these types; yes, __be32 and __u32 have the same size and
compiler might very well decide to use the same memory location for values
of those types; let it take care of that.

sparse can enforce that discipline; if you really need to violate it (e.g.
you want to use a big-endian value as search key in binary tree) add explicit
(__force __u32) in such places.  gcc won't care (__be32 ends up typedefed to
unsigned int as far as gcc is aware, so the cast is simply a no-op), sparse
will know that you really mean it and readers of the code will have a visible
warning that something subtle is going on.  You want to have as few places of
that kind as possible, of course.

You can add more types of that sort, BTW - grep for __bitwise in include/
or fs/*/ for examples.
