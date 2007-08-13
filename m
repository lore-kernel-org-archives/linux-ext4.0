From: Theodore Tso <tytso@mit.edu>
Subject: Re: Future of ext2 support in the Hurd?
Date: Mon, 13 Aug 2007 12:21:35 -0400
Message-ID: <20070813162135.GC28130@thunk.org>
References: <E1IKLAG-0002yi-8Z@candygram.thunk.org>
	<878x8g5mkc.wl%marcus.brinkmann@ruhr-uni-bochum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bug-hurd@gnu.org
To: Marcus Brinkmann <marcus.brinkmann@ruhr-uni-bochum.de>
Return-path: <bug-hurd-bounces+gnu-bug-hurd=m.gmane.org@gnu.org>
Content-Disposition: inline
In-Reply-To: <878x8g5mkc.wl%marcus.brinkmann@ruhr-uni-bochum.de>
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/bug-hurd>,
	<mailto:bug-hurd-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/pipermail/bug-hurd>
List-Post: <mailto:bug-hurd@gnu.org>
List-Help: <mailto:bug-hurd-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/bug-hurd>,
	<mailto:bug-hurd-request@gnu.org?subject=subscribe>
Sender: bug-hurd-bounces+gnu-bug-hurd=m.gmane.org@gnu.org
Errors-To: bug-hurd-bounces+gnu-bug-hurd=m.gmane.org@gnu.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 13, 2007 at 02:02:11AM +0200, Marcus Brinkmann wrote:
> In fact, I just searched for your name, and it pops up in the network
> stack, but not in the ext2fs translator (the above files are copyright
> Remy Card and Linus Torvald).

I only did a quick look, but I recognized some Linux code in balloc.c,
at least.  The code I think was probably written originally by Stephen
Tweedie.  We weren't very careful about maintaining authorship
attribution until after we moved to the BitKeeper (and later git) for
source code management.  I probably only have minimal kernel ownership
in terms of lines of code, with the exception being the directory
indexing changes and extended attribute code, which got reworked by me
before they were merged into mainline.  Most of my code ownership from
a copyright standpoint is in e2fsprogs.

> This matches my best understanding of the issues involved.  Beyond
> that, I can not say anything that applies particularly to the Hurd or
> its RPC interfaces.

It will be especially interesting since some RPC interfaces (mediated
by libc) will be used by GPLv2 userspace programs (such as e2fsck :-),
and some of those exact same interfaces will be used by Hurd
translators, and it will be interesting to see the legal
interpretations/contortions necessary to justify making some of these
distinctions.  :-)

> That is an important question, but for now the Hurd is GPLv2, for
> exactly that reason.  There are other significant parts of the Hurd
> taken from Linux, so we can't do a complete switch at this time.  To
> make a partial switch, we would have to address the issues you raised.
> 
> Beside the FSF' position, your position (and Remy Cards', Linus
> Torvalds' etc) matters as well, of course.

Well, the general consensus of the ext2/3/4 developers at this point
is to keep things at GPLv2.  My personal opinion matches with Linus
which is while I think that "Tivoization" in many cases will be a bad
choice from a marketing point of view (see how well Circuit City's
Divx venture fared), but it's not something that should be legislated
via the licenses.  If someone wants to use ext3 inside a locked down
device, that's fine with me, as long as I can get any improvements to
the source code back; I don't feel that it's worth it for the license
the mandate that I MUST be able to replace the running binaries inside
any embedded device.  So I don't see the Linux kernel going GPLv3 at
any time in the near future, and probably not ever.

Regards,

						- Ted
