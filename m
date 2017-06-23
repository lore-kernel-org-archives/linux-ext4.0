From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ubifs: don't bother checking for
 encryption key in ->mmap()
Date: Fri, 23 Jun 2017 13:28:56 -0400
Message-ID: <20170623172856.aixyqcd4o4te6neb@thunk.org>
References: <20170523003945.14279-1-ebiggers3@gmail.com>
	<20170523003945.14279-4-ebiggers3@gmail.com>
	<CAFLxGvxaiWFKH5L_BwPXGuG9PxA+0BkJ1qMvaDgAeVwBw+nCoQ@mail.gmail.com>
	<20170623160907.ppwcqehvrehjtury@thunk.org>
	<20170623171807.GA84943@gmail.com>
	<82e7cbcc-5de8-4e10-8c5e-1537c9584a50@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@google.com>, Eric Biggers <ebiggers3@gmail.com>,
	linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <82e7cbcc-5de8-4e10-8c5e-1537c9584a50@nod.at>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 23, 2017 at 07:20:51PM +0200, Richard Weinberger wrote:
> 
> The plan is that the fscrypt tree will just contain fscrypt "core" patches and
> global changes/cleanups go thought the individual filesystem trees, right?

Yes, it minimizes potential conflicts against other individual file
system trees if we keep patches that are file system specific in their
own tree.

There will be times when we can't do that --- for example, if we need
to make a change in the fscrypt directory that requires matching
changes in all of the users of fscrypt at the same time.  But when we
do that there is always the chance that there will be merge conflicts
that have to be manually reconciled by both Stephen Rothwell for
linux-next and Linus during the merge window.  But if we can avoid
needing to do that, it's generally easier for all concerned.

Cheers,

						- Ted

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
