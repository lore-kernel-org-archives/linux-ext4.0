From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: ext4 filesystem corruption with 4.10-rc2 on ppc64le
Date: Mon, 09 Jan 2017 09:40:29 +0530
Message-ID: <14716846.DtMXVimRBg@localhost.localdomain>
References: <20170104161808.5ad7b4fd@kryten> <6085340.JSrffQ0Szo@localhost.localdomain> <20170104152837.wdh7cdncs7gyged7@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Anton Blanchard <anton@samba.org>, jack@suse.cz,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, axboe@fb.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, torvalds@linux-foundation.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170104152837.wdh7cdncs7gyged7@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday, January 04, 2017 10:28:37 AM Theodore Ts'o wrote:
> On Wed, Jan 04, 2017 at 11:32:42AM +0530, Chandan Rajendra wrote:
> > On Wednesday, January 04, 2017 04:18:08 PM Anton Blanchard wrote:
> > > I'm consistently seeing ext4 filesystem corruption using a mainline
> > > kernel. It doesn't take much to trigger it - download a ppc64le Ubuntu
> > > cloud image, boot it in KVM and run:
> > > 
> > > sudo apt-get update
> > > sudo apt-get dist-upgrade
> > > sudo reboot
> > > 
> > > And it never makes it back up, dying with rather severe filesystem
> > > corruption.
> > 
> > The patch at https://patchwork.kernel.org/patch/9488235/ should fix the
> > bug.
> 
> It looks like this patch is already queued up on the "for-linus"
> branch on the linux-block.git tree.
> 
> Chandra, thanks for pointing this out!  I had missed your e-mail from
> Christmas day, and it was on my todo list to figure out why I was
> seeing lots of 1k block regressions on gce-xfstests post-merge window
> that wasn't showing up on the ext4.git tree before I sent my pull
> request to Linus.
> 
> Jens, could you expedite a pull request to Linus?  This is affecting
> ext4 on 1k block file systems on x86/x86_64, so this is not a ppc-only
> regression.  
> 
> Anton or Chandan, could you do me a favor and verify whether or not
> 64k block sizes are working for you on ppcle on ext4 by running
> xfstests?  Light duty testing works for me but when I stress ext4 with
> pagesize==blocksize on ppcle64 via xfstests, it blows up.  I suspect
> (but am not sure) it's due to (non-upstream) device driver issues, and
> a verification that you can run xfstests on your ppcle64 systems using
> standard upstream device drivers would be very helpful, since I don't
> have easy console access on the machines I have access to at $WORK.  :-(

Hi Ted,

I found one regression w.r.t 64k blocksize. I posted a patch
(http://marc.info/?l=linux-block&m=148388687722745&w=2) to fix the issue. 

-- 
chandan
