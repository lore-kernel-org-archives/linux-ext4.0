From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH 3/3] Add timeout feature
Date: Tue, 1 Jul 2008 11:52:51 +0100
Message-ID: <20080701105251.GC22522@agk.fab.redhat.com>
References: <20080630212450t-sato@mail.jp.nec.com>
	<20080701081026.GB16691@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, viro@ZenIV.linux.org.uk,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	akpm@linux-foundation.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080701081026.GB16691@infradead.org>
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

On Tue, Jul 01, 2008 at 04:10:26AM -0400, Christoph Hellwig wrote:
> I still disagree with this whole patch.  

Same here - if you want a timeout, what stops you from implementing it in a
userspace process?  If your concern is that the process might die without
thawing the filesystem, take a look at the userspace LVM/multipath code for
ideas - lock into memory, disable OOM killer, run from ramdisk etc.
In practice, those techniques seem to be good enough.

> call can hang and this would be theoretically useful is when the
> filesystem is already frozen by someone else, but this should be fixed
> by refusing to do the second freeze, as suggested in my comment to patch
> 1.

Similarly if a device-mapper device is involved, how should the following
sequence behave - A, B or C?

1. dmsetup suspend (freezes)
2. FIFREEZE
3. FITHAW
4. dmsetup resume (thaws)

A:
  1 succeeds, freezes
  2 succeeds, remains frozen
  3 succeeds, remains frozen
  4 succeeds, thaws

B:
  1 succeeds, freezes
  2 fails, remains frozen
  3 shouldn't be called because 2 failed but if it is: succeeds, thaws
  4 succeeds (already thawed, but still does the device-mapper parts)

C:
  1 succeeds, freezes
  2 fails, remains frozen
  3 fails (because device-mapper owns the freeze/thaw), remains frozen 
  4 succeeds, thaws

Alasdair
-- 
agk@redhat.com
