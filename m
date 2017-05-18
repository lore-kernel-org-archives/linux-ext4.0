From: Ming Lei <ming.lei@redhat.com>
Subject: Re: BUG: hot removal during writes on ext4 formatted nvme device
Date: Thu, 18 May 2017 09:34:59 +0800
Message-ID: <20170518013454.GA13864@ming.t460p>
References: <037dd98d-595e-f96b-6241-2474bd2c3e8f@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        sagi@grimberg.me, Keith Busch <keith.busch@intel.com>
To: Jon Derrick <jonathan.derrick@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754435AbdERBfQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 17 May 2017 21:35:16 -0400
Content-Disposition: inline
In-Reply-To: <037dd98d-595e-f96b-6241-2474bd2c3e8f@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 22, 2017 at 06:38:12PM -0600, Jon Derrick wrote:
> Hello,
> 
> I've encountered a BUG that I've experienced during hot removal on an
> ext4-formatted nvme device undergoing writes. I have been able to verify
> that 4.5, 4.6, 4.10.12, 4.11, and 4.12-rc1 show similar issues (the v4.6
> trace below shows issues with block that have already been fixed). I'm
> using VMD hardware for my hotplug controller so 4.5 is as far back as I
> can go (maybe someone else can verify on non-VMD hardware?).
> 
> To reproduce:
> 1) mkfs.ext4 <nvme>
> 2) mount <nvme> <mnt>
> 3) dd if=/dev/zero of=<mnt>/file bs=1M count=10000
> 4) Hot remove the drive while above is writing
> 
> From what I can tell, the ext4 sb is trying to be committed in the error
> path. There is supposed to be a check if the device is still alive via
> block_device_ejected(), but my guess is that there is a race between the
> removal/deletion in genhd and this check. I would appreciate any help
> resolving this.
>

Recently I played fio over NVMe partition direclty with hot-remove too, and
found that d3cfb2a0ac0b8487d28(block: block new I/O just after queue is set
as dying) is helpful for this kind of issue.

Also the following patch fixes one issue in remove path.

	http://marc.info/?l=linux-block&m=149498450028434&w=2

So could you test v4.12-rc1(d3cfb2a0 is merged) with the above patch?

With these patches in, block layer & NVMe should make sure that all I/O can
be finished with -EIO before del_gendisk() returns once after hot-remove
is triggered, then the failure handling of fs might need further investigation.


Thanks,
Ming
