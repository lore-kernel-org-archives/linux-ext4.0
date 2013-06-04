From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] jbd2: Fix block tag checksum verification brokenness
Date: Mon, 3 Jun 2013 17:40:18 -0700
Message-ID: <20130604004015.GA6087@blackbox.djwong.org>
References: <20130603021630.13790.qmail@science.horizon.com>
 <20130603075521.GA6088@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: George Spelvin <linux@horizon.com>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130603075521.GA6088@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[adding tytso and linux-ext4 to cc]

On Mon, Jun 03, 2013 at 12:55:21AM -0700, Darrick J. Wong wrote:
> On Sun, Jun 02, 2013 at 10:16:30PM -0400, George Spelvin wrote:
> > > Fortunately metadata checksumming is still "experimental" and not in a shipping
> > > e2fsprogs, so there should be few users affected by this.
> > 
> > Am I reading this patch correctly that this changes which half of
> > the 32-bit checksum is stored on little-endian (e.g. x86) machines?
> > Before, it stored the low 16 bits of cpu_to_be32(csum), meaning the
> > high 16 bits of csum.
> 
> ...unless you're using a BE system in which case it's the low 16 bits. :)
> 
> > Now, it's cpu_to_be16(csum32), which is the low 16 bits of csum32.
> > 
> > It so happens that I have multiple metadata_csum file systems.
> > (I enabled it a while ago on a machine where I wasn't sure if corruption
> > was RAM or disk, and have been using it on SSE4.2 machines since.)
> > 
> > Is there an upgrade path?  Also, what's the corresponding e2fsprogs
> > commit that supports this change?
> 
> The kernel patch fixes journal bogosity when moving a disk between big and
> little endian systems.  e2fsprogs didn't have the brokenness, so there's no

Drat, I was writing this email too late at night.  There /is/ a related
e2fsprogs patch for this:
http://comments.gmane.org/gmane.comp.file-systems.ext4/38621

Hey Ted, any thoughts on this jbd2/e2fsprogs patch pair?  Al acked the jbd2
part.

--D

> change needed.  In theory you'd only hit this if you happened to crash an x86
> box with an ext4 fs, move the disk to a ppc, and try to recover it there.
> 
> The upgrade path is to umount cleanly and reboot with a patched kernel while
> hoping that you don't crash while rebooting.  Sorry about the bumpy
> metadata_csum ride.
> 
> --D
