From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Sun, 26 Nov 2017 10:40:26 -0500
Message-ID: <20171126154026.2cyhh3vsvhnszhvs@thunk.org>
References: <20171123203330.GN2482@two.firstfloor.org>
 <20171123222317.bq2v26zm5i2jspui@thunk.org>
 <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
 <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
 <20171125223202.GL4094@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Andi Kleen <andi@firstfloor.org>,
        Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171125223202.GL4094@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Nov 26, 2017 at 09:32:02AM +1100, Dave Chinner wrote:
> 
> They don't have any whacky symlinks around, but the modern ext4 code
> does try to eat these filesystems every so often. Extended operation
> at ENOSPC will eventually corrupt the rootfs and crash the kernel,
> and then I play the "e2fsck doesn't detect corruption, kernel does"
> game to get them fixed up and working again....

If you have stack dumps or file system images which e2fsck doesn't
detect any problems but the kernels do, please do feel free send
reports to the ext4 mailing list.

> I'm running with everything up to date (debian unstable) on these
> VMs, they are just an old filesystem because some distros have had
> reliable rolling updates for the entire life of these VMs. :P

Or if you can make the VM's available and tell me how you are
using/exercising them, I can try to see if I can repro the problem.

I am wondering how you are running into ENOSPC on the root file
systems; I take this is much more than running xfstests?  Are you
running some benchmarks that are logging into the root, and that's
triggering the ENOSPC condition?

Thanks,

						- Ted
