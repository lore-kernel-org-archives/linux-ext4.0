From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/3] freeze feature ver 1.8
Date: Mon, 30 Jun 2008 14:54:33 +0100
Message-ID: <20080630135433.GA22522@agk.fab.redhat.com>
References: <20080630212005t-sato@mail.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080630212005t-sato@mail.jp.nec.com>
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

On Mon, Jun 30, 2008 at 09:20:05PM +0900, Takashi Sato wrote:
> Currently, ext3 in mainline Linux doesn't have the freeze feature which
> suspends write requests.  So, we cannot take a backup which keeps
> the filesystem's consistency with the storage device's features
> (snapshot and replication) while it is mounted.
> In many case, a commercial filesystem (e.g. VxFS) has
> the freeze feature and it would be used to get the consistent backup.
> If Linux's standard filesytem ext3 has the freeze feature, we can do it
> without a commercial filesystem.
 
Is the following a fair summary?

1. Some filesystems have a freeze/thaw feature.  XFS exports this to
userspace directly through a couple of ioctls, but other filesystems
don't.  For filesystems on device-mapper block devices it is exported to
userspace through the DM_DEV_SUSPEND ioctl which LVM uses.

2. There is a desire to access this feature from userspace on non-XFS
filesystems without having to use device-mapper/LVM.

Alasdair
-- 
agk@redhat.com
