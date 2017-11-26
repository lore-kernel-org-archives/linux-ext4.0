From: Dave Chinner <david@fromorbit.com>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Mon, 27 Nov 2017 08:14:27 +1100
Message-ID: <20171126211427.GO4094@dastard>
References: <20171123203330.GN2482@two.firstfloor.org>
 <20171123222317.bq2v26zm5i2jspui@thunk.org>
 <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
 <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
 <20171125223202.GL4094@dastard>
 <20171126154026.2cyhh3vsvhnszhvs@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        Andi Kleen <andi@firstfloor.org>,
        Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171126154026.2cyhh3vsvhnszhvs@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Nov 26, 2017 at 10:40:26AM -0500, Theodore Ts'o wrote:
> On Sun, Nov 26, 2017 at 09:32:02AM +1100, Dave Chinner wrote:
> > 
> > They don't have any whacky symlinks around, but the modern ext4 code
> > does try to eat these filesystems every so often. Extended operation
> > at ENOSPC will eventually corrupt the rootfs and crash the kernel,
> > and then I play the "e2fsck doesn't detect corruption, kernel does"
> > game to get them fixed up and working again....
> 
> If you have stack dumps or file system images which e2fsck doesn't
> detect any problems but the kernels do, please do feel free send
> reports to the ext4 mailing list.

Of course. I've done that every time I've come acros these sorts of
problems.

> > I'm running with everything up to date (debian unstable) on these
> > VMs, they are just an old filesystem because some distros have had
> > reliable rolling updates for the entire life of these VMs. :P
> 
> Or if you can make the VM's available and tell me how you are
> using/exercising them, I can try to see if I can repro the problem.

No, I can't xpamke them available. As for how I use them, they are
my test/devel VMs, so they are getting multiple kernels thrown at
them every day, and I'll just kill the VM via the qemu console (they
*never* get shut down clealy) when I need to install a new kernel.
Often they won't shut down anyway, because I've
oopsed/deadlocked/etc something on a different filesystem...

> I am wondering how you are running into ENOSPC on the root file
> systems; I take this is much more than running xfstests?

No, it isn't.  Just have a scratch filesystem failure during
xfstests such that mount fails during a "fill to enospc" test and it
will fill the root filesystem rather than the test/scratch device.
Or run a buggy test that dumps everything in $here. Or fill /tmp
without noticing it.  Then let fstests continue to run trying to
write state and logs for the next 500 tests...

> Are you
> running some benchmarks that are logging into the root, and that's
> triggering the ENOSPC condition?

No, I'm not doing anything like that on these machines. It's
straight forward "something filled the root fs unexpectedly" type of
error which I don't notice immediately...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
