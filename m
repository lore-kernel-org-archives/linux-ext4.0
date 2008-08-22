From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Fri, 22 Aug 2008 14:16:56 -0400
Message-ID: <20080822181656.GB15469@infradead.org>
References: <20080818212856t-sato@mail.jp.nec.com>
	<20080821132006.9949101c.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, Takashi Sato <t-sato@yk.jp.nec.com>,
	mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com,
	viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080821132006.9949101c.akpm@linux-foundation.org>
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

On Thu, Aug 21, 2008 at 01:20:06PM -0700, Andrew Morton wrote:
> I don't think the changelogs actually explained why this feature is
> being added?
> 
> Which userspace tools are expected to send these ioctls?  Something in
> util-linux?  dm-utils?  Are patches to those packages planned?

Currently the only surspace using freeze and thaw is xfs_freeze from
xfsprogs, which would work for various other filesystems that implement
->write_super_lockfs now instead of just XFS with patch 1.

The freeze stuff in this third patch isn't and won't be used by
xfs_freeze and doesn't make all that much sense (and we already had a
lot of previous discussion on this..)
