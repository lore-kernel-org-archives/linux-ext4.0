From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/4] Support discard if at least one underlying device
 supports it
Date: Fri, 2 Jul 2010 16:29:07 -0400
Message-ID: <20100702202907.GA21915@redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com>
 <20100702181430.GD26916@redhat.com>
 <Pine.LNX.4.64.1007021540150.6197@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030Ab0GBU3O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 16:29:14 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007021540150.6197@hs20-bc2-1.build.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 02 2010 at  3:49pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> > As we discussed, we have a challenge where we need DM to avoid issuing
> > a barrier before the discard IFF a target doesn't support the discard
> > (which the barrier is paired with).
> > 
> > My understanding is that blkdev_issue_discard() only cares if the
> > discard was supported.  Barrier is used just to decorate the discard
> > (for correctness).  So by returning -EOPNOTSUPP we're saying the discard
> > isn't supported; we're not making any claims about the implict barrier,
> > so best to avoid the barrier entirely.
> > 
> > Otherwise we'll be issuing unnecessary barriers (and associated
> > performance loss).
> > 
> > So yet another TODO item... Anyway:
> > 
> > Acked-by: Mike Snitzer <snitzer@redhat.com>
> 
> Unnecessary barriers are issued anyway. With each freed extent.
>
> The code must issue a "SYNCHRONIZE CACHE" to flush cache for previous 
> writes, then "UNMAP" and then another "SYNCHRONIZE CACHE" to commit that 
> unmap to disk. And this in loop for all extents in 
> "release_blocks_on_commit".

You're delving into the mechanics of the discard when it is supported;
which is fine but tangential to my point above.  My point was DM
shouldn't issue any barrier(s) at all if it the discard will not be sent
(because a device doesn't support discards).

> One idea behind "discard barriers" was to submit a discard request and not 
> wait for it. Then the request would need a barrier so that it doesn't get 
> reordered with further writes (that may potentially write to the same area 
> as the discarded area). But discard isn't used this way anyway, 
> sb_issue_discard waits for completion, so the barrier isn't needed.
> 
> Even if ext4 developers wanted asynchronous discard requests, they should 
> fire all the discards at once and then submit one zero-sized barrier. Not 
> barrier with each discard request.

sb_issue_discard() is the block layer api that ext4 uses for discards.
Ext4, or any other filesystem that uses sb_issue_discard(), has no
control over the barriers that are issued.
 
> This is up to ext4 developers to optimize and remove the barriers and we 
> can't do anything with it. Just send "SYNCHRONIZE 
> CACHE"+"UNMAP"+"SYNCHRONIZE CACHE" like the barrier specification wants...

In practice that is what I see when I remove a file in ext4:

        kdmflush-2537  [000] 911436.484481: scsi_dispatch_cmd_start: host_no=5 channel=0 id=0 lun=0 data_sgl=0 prot_sgl=0 cmnd=(SYNCHRONIZE_CACHE - raw=35 00 00 00 00 00 00 00 00 00)
        kdmflush-2537  [000] 911436.484482: scsi_dispatch_cmd_done: host_no=5 channel=0 id=0 lun=0 data_sgl=0 prot_sgl=0 cmnd=(SYNCHRONIZE_CACHE - raw=35 00 00 00 00 00 00 00 00 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_GOOD)

        kdmflush-2537  [000] 911436.484500: scsi_dispatch_cmd_start: host_no=5 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(UNMAP regions=1 raw=42 00 00 00 00 00 00 00 18 00)
          <idle>-0     [000] 911436.485238: scsi_dispatch_cmd_done: host_no=5 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(UNMAP regions=1 raw=42 00 00 00 00 00 00 00 18 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_GOOD)

        kdmflush-2537  [000] 911436.485283: scsi_dispatch_cmd_start: host_no=5 channel=0 id=0 lun=0 data_sgl=0 prot_sgl=0 cmnd=(SYNCHRONIZE_CACHE - raw=35 00 00 00 00 00 00 00 00 00)
        kdmflush-2537  [000] 911436.485284: scsi_dispatch_cmd_done: host_no=5 channel=0 id=0 lun=0 data_sgl=0 prot_sgl=0 cmnd=(SYNCHRONIZE_CACHE - raw=35 00 00 00 00 00 00 00 00 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_GOOD)

Mike
