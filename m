From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: Re: [PATCH 3/3] Add timeout feature
Date: Thu, 3 Jul 2008 21:11:05 +0900
Message-ID: <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp>
References: <20080630212450t-sato@mail.jp.nec.com>
	<20080701081026.GB16691@infradead.org>
	<20080701105251.GC22522@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Christoph Hellwig" <hch@infradead.org>,
	"Alasdair G Kergon" <agk@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080701105251.GC22522@agk.fab.redhat.com>
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

Hi Christoph and Alasdair,

> On Tue, Jul 01, 2008 at 04:10:26AM -0400, Christoph Hellwig wrote:
>> I still disagree with this whole patch.
>
> Same here - if you want a timeout, what stops you from implementing it in a
> userspace process?  If your concern is that the process might die without
> thawing the filesystem, take a look at the userspace LVM/multipath code for
> ideas - lock into memory, disable OOM killer, run from ramdisk etc.
> In practice, those techniques seem to be good enough.

If the freezer accesses the frozen filesystem and causes a deadlock,
the above ideas can't solve it.  The timeout is useful to solve such a deadlock.
If you don't need the timeout, you can disable it by specifying "0" as the
timeout period.

> Similarly if a device-mapper device is involved, how should the following
> sequence behave - A, B or C?
>
> 1. dmsetup suspend (freezes)
> 2. FIFREEZE
> 3. FITHAW
> 4. dmsetup resume (thaws)
[...]
> C:
>  1 succeeds, freezes
>  2 fails, remains frozen
>  3 fails (because device-mapper owns the freeze/thaw), remains frozen
>  4 succeeds, thaws

I think C is appropriate and the following change makes it possible.
How do you think?

1. Add the new bit flag(BD_FREEZE_DM) in block_device.bd_state.
   It means that the volume is frozen by the device-mapper.

2. Operate and check this bit flag as followings.

  - Bit operations in the device-mapper's freeze/thaw
    FREEZE:
      dm_suspend():   set BD_FREEZE_DM
        freeze_bdev():set BD_FREEZE_OP

    THAW:
        thaw_bdev():   clear BD_FREEZE_OP
      dm_resume():    clear BD_FREEZE_DM

  -  Checks in FIFREEZE/FITHAW
    FREEZE:
      ioctl_freeze(): Not need to check BD_FREEZE_DM
        freeze_bdev():set BD_FREEZE_OP

    THAW:
      ioctl_thaw():   If BD_FREEZE_DM is set, fail, otherwise, call thaw_bdev()
        thaw_bdev():   clear BD_FREEZE_OP

Cheers, Takashi
