From: Theodore Tso <tytso@mit.edu>
Subject: Re: Future of ext2 support in the Hurd?
Date: Mon, 13 Aug 2007 12:11:46 -0400
Message-ID: <20070813161146.GB28130@thunk.org>
References: <E1IKLAG-0002yi-8Z@candygram.thunk.org>
	<87absw5o6x.wl%marcus.brinkmann@ruhr-uni-bochum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bug-hurd@gnu.org
To: Marcus Brinkmann <marcus.brinkmann@ruhr-uni-bochum.de>
Return-path: <bug-hurd-bounces+gnu-bug-hurd=m.gmane.org@gnu.org>
Content-Disposition: inline
In-Reply-To: <87absw5o6x.wl%marcus.brinkmann@ruhr-uni-bochum.de>
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

On Mon, Aug 13, 2007 at 01:27:02AM +0200, Marcus Brinkmann wrote:
> We have no intention to drop support for it.  In fact, we are very
> happy with it.  How much are we a burden for you?  If it helps, we can
> probably arrange it so that a volunteer cooperates with you if work is
> involved in keeping the support active.

As long as there are people using it, we'll keep supporting it.  If we
could drop support for HURD-specific inode fields, it would clean up a
somewhat annoying union in the filesystem data structures, but that's
a minor point.

Something that *would* be good would be to have a volunteer
periodically check to make sure that the tip of the "maint" and
"master" branches of e2fsprogs builds and passes the regression test
suite on Hurd.  This may be somewhat happenning with the GNU/Hurd
Debian project, since the latest Debian version of e2fsprogs is
1.40.2, and I assume (although I don't know for sure) that the Debian
GNU/Hurd port is tracking Debian unstable, so if there were anything
embarassing, I would have gotten a complaint.  Still, it would be good
to explicitly run the regression test suite to make sure things are
working correctly --- and if not, to send patches.

This is just to make sure e2fsprogs is working fine for the Hurd, of
course; it's not like I would drop support if you can't find a
volunteer to do this, but at the moment we do no testing on Hurd and
there is no guarantees that a particular new release will work on the
Hurd because none of the active developers have a Hurd box.  

Regards,

					- Ted
