From: Dave Chinner <david@fromorbit.com>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Sun, 26 Nov 2017 09:57:42 +1100
Message-ID: <20171125225742.GN4094@dastard>
References: <20171123203330.GN2482@two.firstfloor.org>
 <20171123222317.bq2v26zm5i2jspui@thunk.org>
 <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
 <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
 <20171125223202.GL4094@dastard>
 <d5020ffd-a174-8a57-5b0f-1b6424e74467@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Andi Kleen <andi@firstfloor.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Reindl Harald <h.reindl@thelounge.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d5020ffd-a174-8a57-5b0f-1b6424e74467@thelounge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Nov 25, 2017 at 11:45:07PM +0100, Reindl Harald wrote:
> 
> Am 25.11.2017 um 23:32 schrieb Dave Chinner:
> >On Fri, Nov 24, 2017 at 03:03:37PM -0700, Andreas Dilger wrote:
> >>Any worse an idea than running a new kernel on an old system?
> >>Newer e2fsck fixes a lot of bugs that are present in older
> >>e2fsck as well...
> >
> >I'm running with everything up to date (debian unstable) on these
> >VMs, they are just an old filesystem because some distros have had
> >reliable rolling updates for the entire life of these VMs. :P
> 
> but why not update the FS to ext4?

Unlike ext3, ext4 is not a filesystem that takes kindly to being
abused by an environment that involves machines being crashed,
oopsed and forcibly rebooted without warning tens of times a day.
Every ext4 root filesytsem I've tried on these VMs has lasted less
than two weeks before being unrecoverably corrupted and needing to
be rebuilt from scratch.

Last time I tried a couple of years ago, the ext4 filesystems lasted
less than a day because corrupting itself in a way that it couldn't
mount but e2fsck didn't detect anything wrong and so it couldn't be
repaired. ext4 is just not robust enough for my use case.

And, FWIW, I don't use XFS for these root filesystems because the
reason I'm doing this to machines is that I'm trashing throwaway XFS
filesystems with broken XFS code on other devices on the VM...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
