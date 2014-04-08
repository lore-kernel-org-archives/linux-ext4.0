From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [ANNOUNCE] xfstests: updated to cf1ed54
Date: Tue, 8 Apr 2014 12:07:39 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404081206190.2152@localhost.localdomain>
References: <20140404090357.GW17603@dastard> <CAL3q7H6q7M-hrvniaVkAm_L6aSHANmnfdTKGEHHLFqXUhWfY5w@mail.gmail.com> <20140404211224.GX17603@dastard>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Filipe David Manana <fdmanana@gmail.com>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbaDHKHx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2014 06:07:53 -0400
In-Reply-To: <20140404211224.GX17603@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 5 Apr 2014, Dave Chinner wrote:

> Date: Sat, 5 Apr 2014 08:12:25 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Filipe David Manana <fdmanana@gmail.com>
> Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
>     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
>     linux-ext4@vger.kernel.org, lczerner@redhat.com
> Subject: Re: [ANNOUNCE] xfstests: updated to cf1ed54
> 
> On Fri, Apr 04, 2014 at 02:07:16PM +0100, Filipe David Manana wrote:
> > On Fri, Apr 4, 2014 at 10:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> > > Hi folks,
> > >
> > > The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
> > > just been updated. Patches often get missed, so please check if your
> > > outstanding patches were in this update. If they have not been in
> > > this update, please resubmit them to xfs@oss.sgi.com so they can be
> > > picked up in the next update.
> > >
> > > The new head of the master branch is commit:
> > >
> > > cf1ed54 check: fix RESULT_BASE typo in check script
> > >
> > > The major new functionality worth mentioning in this update is the
> > > new config file format from Lukas. The existing format config files
> > > should continue to work without change, but the new format is much
> > > richer and allows specification of multiple different configurations
> > > to run test under. Hence testing multiple mount an dmkfs
> > > configurations becomes as simple as iterating the configurations
> > > in the config file.
> > 
> > Hi,
> > 
> > I might be missing something, but after checking out these changes, I
> > am no longer able to run btrfs tests. Example:
> > 
> > $ ./check btrfs/041
> > common/config: Error: $SCRATCH_DEV should be unset when $SCRATCH_DEV_POOL is set
> > Passed all 0 tests
> > 
> > $ cat local.config
> > export TEST_DEV=/dev/sdb
> > export TEST_DIR=/home/fdmanana/btrfs-tests/dev
> > export SCRATCH_MNT="/home/fdmanana/btrfs-tests/scratch_1"
> > export SCRATCH_DEV_POOL="/dev/sdc /dev/sdd"
> 
> OK, that'll be a bug in the new config file parsing code. Lukas,
> can you have a look at this?

Oh, yes. I'll take a look at this. Honestly I was not aware of
SCRATCH_DEV_POOL.

Thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 
