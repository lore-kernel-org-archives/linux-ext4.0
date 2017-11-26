From: Dave Chinner <david@fromorbit.com>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Mon, 27 Nov 2017 09:43:24 +1100
Message-ID: <20171126224324.GP4094@dastard>
References: <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
 <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
 <20171125223202.GL4094@dastard>
 <20171126154026.2cyhh3vsvhnszhvs@thunk.org>
 <20171126211427.GO4094@dastard>
 <6644604d-b7b3-d836-927d-1bfecc3fa6eb@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Reindl Harald <h.reindl@thelounge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:7248 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752094AbdKZWn1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 26 Nov 2017 17:43:27 -0500
Content-Disposition: inline
In-Reply-To: <6644604d-b7b3-d836-927d-1bfecc3fa6eb@thelounge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 26, 2017 at 10:35:08PM +0100, Reindl Harald wrote:
> 
> 
> Am 26.11.2017 um 22:14 schrieb Dave Chinner:
> >On Sun, Nov 26, 2017 at 10:40:26AM -0500, Theodore Ts'o wrote:
> >>Are you
> >>running some benchmarks that are logging into the root, and that's
> >>triggering the ENOSPC condition?
> >
> >No, I'm not doing anything like that on these machines. It's
> >straight forward "something filled the root fs unexpectedly" type of
> >error which I don't notice immediately...
> 
> have you ever considered to just buy larger disks or introduce quota
> because "Unlike ext3, ext4 is not a filesystem that takes kindly to
> being abused by an environment that involves machines being crashed,
> oopsed and forcibly rebooted without warning tens of times a day"

That's my normal production workload, been doing it successfully
on ext3 root filesystems for more than 10 years. This causes very
few problems for ext3 filesystems, but it causes real problems for
ext4 filesystems.

> caused by a full root fs

I don't think you've quite understood: a) I don't run my root
filesystems at ENOSPC (it's a rare event), and b) crashing kernels
and abusing filesystems is the one-line summary of my job
description.

> is anyhting but a reasonable workload and i
> doubt any filesystem is intended to run under such abused
> environment

Intended or not, we have to make filesystems robust in such
environments because that's the sort of abuse we see in production
environments. Users *expect* filesystems to handle crashes, ENOSPC,
etc conditions without losing data or corrupting themselves. 

If filesystem developers aren't abusing their filesystems and
attempting to break them into little pieces and put them back
together again, then they aren't doing their jobs properly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
