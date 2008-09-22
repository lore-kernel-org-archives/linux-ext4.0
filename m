From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/10] VFS: Fix error handling of
	write_super_lockfs/unlockfs
Date: Mon, 22 Sep 2008 06:59:56 -0400
Message-ID: <20080922105956.GA16069@infradead.org>
References: <20080922195526t-sato@mail.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080922195526t-sato@mail.jp.nec.com>
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

On Mon, Sep 22, 2008 at 07:55:26PM +0900, Takashi Sato wrote:
> I've changed the type of write_super_lockfs and unlockfs from "void" to
> "int" so that they can return an error. 

Returning an error from the freeze operation makes sense, but for the
unfreeze I don't see the point.  You must however change all existing
instances to actually return a value (even if it's always 0 for now)
to avoid breaking git bisect.

If you touch all instances anyway, it would be nice to rename them
to freeze / unfreze as the current names are more confusing.
