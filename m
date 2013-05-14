From: Jan Kara <jack@suse.cz>
Subject: Re: Barriers
Date: Tue, 14 May 2013 23:41:58 +0200
Message-ID: <20130514214158.GB10769@quack.suse.cz>
References: <C0F0BC787567C848B2C90989451123DAE3A619@ATLEXMBX4.ARRS.ARRISI.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758357Ab3ENVmB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 May 2013 17:42:01 -0400
Content-Disposition: inline
In-Reply-To: <C0F0BC787567C848B2C90989451123DAE3A619@ATLEXMBX4.ARRS.ARRISI.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Mon 13-05-13 07:54:48, Sidorov, Andrei wrote:
> I'm curious if anyone ever tried fua-only jbd? If done with fua's, there
> will be no cache flushes at all, thus no occasional spikes. NCQ fua
> journalling is potentially more efficient than cache flush.
  If you have such HW, it may be an interesting thing to try.

> I know, stale data will be unavoidable (however unlikely) in fua-based
> implementation. It is a compromise between ordered,nobarrier (fs
> corruption is likely to happen upon power loss) and ordered,barrier (no
> fs corruption).
  Well, it will achieve guarantees of barrier,data=writeback mode.

> Any advise on what kind of workload to test?
  Not really...

> What about having single journal per device as opposed to partition/fs?
> What I've found of quick look at jbd2 code, it doesn't seem to be a
> problem to set up single journal for several filesystems on the same device.
> This will give an advantage of single commit per commit interval as
> opposed to several commits per likely to be same interval.
  Yes, that should be relatively easily possible and might be interesting
for other usecases as well (e.g. when you want to utilize one fast device
for the journal and use it for several slow disks).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
