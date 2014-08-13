From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Wed, 13 Aug 2014 10:32:31 +0800
Message-ID: <CAPTn0cDY+sYFpFnPQmpLRCDdtvc3rThgNzSkevcyYkcia=poew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 12, 2014 at 11:35 PM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> I'll bet a box of "russian caviar" that AlViro will never ever allow
> to place project ID to generic inode. Because it is obviously has no
> reason for any other filesystem except xfs/ext4.
Yeah, understood. Maybe the discription is misleading. I added a
field of project ID in ext4_inode structure. The general ext4 inode
structure is not changed.
>
> BTW. Which quota options you use for performance testing? It looks like
> you use non-journaled quota. But this means that you have to fully
> recalculate quota in case of power failure. It is reasonable to enable
> journaled-quota, but it result in visible journaling overhead.
Yeah, we were using non-journaled quota. And we were doing this
benchmark to confirm that xattr based implementation has extra
overhead. We will run benchmarks on journaled-quota, and let's see
what is the performance difference between non-journaled and
journaled quotas.

Regards,
                                                  -Li Xi
