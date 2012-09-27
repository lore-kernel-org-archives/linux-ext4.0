From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v2 06/10] vfs: enable hot data tracking
Date: Thu, 27 Sep 2012 15:12:51 +0800
Message-ID: <CAEH94LhgPKONsdXF-P0vo5oSGXi1NWkwkyv14y=zO4UAnG3OBQ@mail.gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
	<1348404995-14372-7-git-send-email-zwu.kernel@gmail.com>
	<20120927035425.GN15236@dastard>
	<CAEH94LgxOLhyP50hyjQxsECZP1knkYB+11N4=UtJ4mTb5Bmm1g@mail.gmail.com>
	<20120927065953.GQ15236@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120927065953.GQ15236@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 27, 2012 at 2:59 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Sep 27, 2012 at 02:28:12PM +0800, Zhi Yong Wu wrote:
>> On Thu, Sep 27, 2012 at 11:54 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sun, Sep 23, 2012 at 08:56:31PM +0800, zwu.kernel@gmail.com wrote:
>> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >>
>> >>   Miscellaneous features that implement hot data tracking
>> >> and generally make the hot data functions a bit more friendly.
>> >>
>> >> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >> ---
>> >>  fs/direct-io.c               |   10 ++++++++++
>> >>  include/linux/hot_tracking.h |   11 +++++++++++
>> >>  mm/filemap.c                 |    8 ++++++++
>> >>  mm/page-writeback.c          |   21 +++++++++++++++++++++
>> >>  mm/readahead.c               |    9 +++++++++
>> >>  5 files changed, 59 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/fs/direct-io.c b/fs/direct-io.c
>> >> index f86c720..3773f44 100644
>> >> --- a/fs/direct-io.c
>> >> +++ b/fs/direct-io.c
>> >> @@ -37,6 +37,7 @@
>> >>  #include <linux/uio.h>
>> >>  #include <linux/atomic.h>
>> >>  #include <linux/prefetch.h>
>> >> +#include "hot_tracking.h"
>> >>
>> >>  /*
>> >>   * How many user pages to map in one call to get_user_pages().  This determines
>> >> @@ -1297,6 +1298,15 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>> >>       prefetch(bdev->bd_queue);
>> >>       prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
>> >>
>> >> +     /* Hot data tracking */
>> >> +     if (TRACK_THIS_INODE(iocb->ki_filp->f_mapping->host)
>> >> +                     && iov_length(iov, nr_segs) > 0) {
>> >> +             hot_rb_update_freqs(iocb->ki_filp->f_mapping->host,
>> >> +                             (u64)offset,
>> >> +                             (u64)iov_length(iov, nr_segs),
>> >> +                             rw & WRITE);
>> >> +     }
>> >
>> > That's a bit messy. I'd prefer a static inline function that hides
>> > all this. e.g.
>> Do you think of moving the condition into hot_inode_udate_freqs(), not
>> adding another new function?
>
> Moving it into hot_inode_udate_freqs() will add a function call
> overhead even when tracking is not enabled. a static inline function
Can we not directly define hot_inode_udate_freqs to be a static inline?:)

> will just result in no extra overhead other than the if
> statement....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
