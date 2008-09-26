From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/10] freeze feature ver 1.13
Date: Fri, 26 Sep 2008 16:26:58 -0500
Message-ID: <1222464418.27833.7.camel@norville.austin.ibm.com>
References: <20080926175652t-sato@mail.jp.nec.com>
	 <30536.1222426096@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Takashi Sato <t-sato@yk.jp.nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <30536.1222426096@turing-police.cc.vt.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2008-09-26 at 06:48 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 26 Sep 2008 17:56:52 +0900, Takashi Sato said:

> Would it be a good idea to merge patch 10 into patch 8?   Otherwise, there's
> two issues I can see:
> 
> 1) A mostly theoretical problem if a bisect lands exactly on patch 9 it can
> hit the deadlock.

Really, there's no deadlock until someone uses the new function, so
that's not really an issue, is it?  However, this patchset breaks
bisection anyway.

A bisect anywhere between patch 1 and 7 will cause some number of
filesystems to fail to compile.  Patches 1-7 either need to be combined
into one, or patch 1 needs to add freeze_fs and unfreeze_fs while
leaving write_super_lockfs and unlockfs, then a patch between 7 and 8
could remove write_super_lockfs and unlockfs.

> 2) The API at patch 8 and patch 10 differs, that's going to make testing through
> a bisection of this patch series a pain.

There's no need to test the new interface during a bisection.  Bisection
is important in testing regressions, but not new function.
-- 
David Kleikamp
IBM Linux Technology Center

