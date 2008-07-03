From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH 3/3] Add timeout feature
Date: Thu, 3 Jul 2008 13:47:10 +0100
Message-ID: <20080703124709.GI22522@agk.fab.redhat.com>
References: <20080630212450t-sato@mail.jp.nec.com>
	<20080701081026.GB16691@infradead.org>
	<20080701105251.GC22522@agk.fab.redhat.com>
	<9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 03, 2008 at 09:11:05PM +0900, Takashi Sato wrote:
> If the freezer accesses the frozen filesystem and causes a deadlock,
> the above ideas can't solve it

But you could also say that if the 'freezer' process accesses the frozen
filesystem and deadlocks then that's just a bug and that userspace code
should be fixed and there's no need to introduce the complexity of a
timeout parameter.

> >Similarly if a device-mapper device is involved, how should the following
> >sequence behave - A, B or C?
> >
> >1. dmsetup suspend (freezes)
> >2. FIFREEZE
> >3. FITHAW
> >4. dmsetup resume (thaws)
> [...]
> >C:
> > 1 succeeds, freezes
> > 2 fails, remains frozen
> > 3 fails (because device-mapper owns the freeze/thaw), remains frozen
> > 4 succeeds, thaws
> 
> I think C is appropriate and the following change makes it possible.
> How do you think?
 
The point I'm trying to make here is:
  Under what real-world circumstances might multiple concurrent freezing
  attempts occur, and which of A, B or C (or other variations) would be
  the most appropriate way of handling such situations?

A common example is people running xfs_freeze followed by an lvm command
which also attempts to freeze the filesystem.

I can see a case for B or C, but personally I prefer A:

> > 1 succeeds, freezes
> > 2 succeeds, remains frozen
> > 3 succeeds, remains frozen
> > 4 succeeds, thaws

Alasdair
-- 
agk@redhat.com
