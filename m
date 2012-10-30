From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Tue, 30 Oct 2012 15:40:05 -0700
Message-ID: <50905745.1060509@panasas.com>
References: <20121026101909.GB19617@blackbox.djwong.org> <20121027013524.GA19591@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Mike Christie <michaelc@cs.wisc.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20121027013524.GA19591@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/26/2012 06:35 PM, Darrick J. Wong wrote:
> This creates BDI_CAP_STABLE_WRITES, which indicates that a device requires
> stable page writes.  It also plumbs in a sysfs attribute so that admins can
> check the device status.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
<>
> @@ -434,10 +438,14 @@ EXPORT_SYMBOL(blk_integrity_register);
>  void blk_integrity_unregister(struct gendisk *disk)
>  {
>  	struct blk_integrity *bi;
> +	struct backing_dev_info *bdi;
>  
>  	if (!disk || !disk->integrity)
>  		return;
>  
> +	bdi = &disk->queue->backing_dev_info;
> +	bdi->capabilities &= ~BDI_CAP_STABLE_WRITES;
> +

Once this patchset is in we'll need to add one such code site to
iscsi in the case data_integrity is turned on.

You are welcome to add such a patch to your patchset, (I can show
you where) but it will take a little while before I have the time to
tests such a change.

Currently if data_integrity is turned on iscsi reverts to copy-full
networking, as an hackish attempt to narrow the window of pages changing.
With such a patch in place, we can remove the hack.

But please note that your changes are only half the picture. Because not
all filesystems support stable pages, so it is not like if I turn this flag
on I will magically be protected. A more complete picture is if the FS could
communicate back to iscsi if it actually will provide stable pages, for it
to start trusting stable pages again.

But since iscsi's protection is just an hack, and an admin that mounts
a none supporting FS can always just turn off data_integrity for that
particular LUN, then I'd say it's fine. Even with this half of the
patchset iscsi should be fixed to use it.

But for the likes of future dm-raid5 that wants to be copy-less, you will
need in the future, a way for the FS to communicate back if it will actually
support stable-pages or the block device needs to revert to old tricks.

Thanks
Boaz

>  	bi = disk->integrity;
>  
>  	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
