From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.3-rc1, regression] ext2 vs ext3/ext4 fs probing issues
Date: Mon, 28 Sep 2015 10:04:08 +1000
Message-ID: <20150928000408.GX19114@dastard>
References: <20150921070715.GL26895@dastard>
 <20150925235126.GW19114@dastard>
 <20150927231458.GA8638@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150927231458.GA8638@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Sep 27, 2015 at 07:14:58PM -0400, Theodore Ts'o wrote:
> On Sat, Sep 26, 2015 at 09:51:26AM +1000, Dave Chinner wrote:
> > Ping?
> 
> Sorry, I somehow missed this the first time you posted this.
> 
> > > Which tells me that there's a problem with fstype probe ordering
> > > regressions w.r.t ext2 and ext3 as a result of removing the ext3
> > > module. It also doesn't fail fsck checks now, so boots successfully
> > > every time. I suspect the "boot hang" problem is that e2fsck sees a
> > > dirty journal, fixes everything and then asks for a reboot, which
> > > fails.
> 
> The original probe ordering was: ext3, ext2, ext4.  As you've
> correctly pointed out, this allowed us to preferentially use ext3 over
> ext2 even if the file system did not need a file system replay.  We
> put ext4 at the end so that if there was an ext2-only root file
> system, we would use ext2 in preference over ext4.  This was useful
> for backwards compatibility for certain ancient enterprise
> distributions, and/or when ext4 was still under development and we
> wanted to make sure for an ext2-only root, we would use ext2 if
> possible.
> 
> When ext3 was removed, we were now left with the boot order: ext2,
> ext4. 

Yup, that's what I thought, given the way the ext4 code explictly
registers ext3/ext2/ext4 in that order when ext4 is being used for
all of themmm.

> P.S.  Regarding the problem which triggered your investigation of the
> boot order:
> 
> > > One the first cold boot of a new kernel, the boot appears to hang.
> > > What i've discovered (which took a long time thanks to the shitpile
> > > that is systemd) is that it appears to be doing a e2fsck on the root
> > > device, and that is failing resulting in systemd outputing:
> > >
> > > [FAILED] Failed to start File System Check on Root Device.
> 
> Clearly both you and I don't have the same refined tastes as Lennart
> Poettering.  :-)
> 
> After all, instead of grepping through shell scripts, Lennart clearly
> prefers people to have to go diving through C source code to figure
> out what is going on....

That's the single biggest problem systemd has - you need another
machine with source code on it to debug a machine that is failing to
boot.

> I could be wrong, since the systemd sources is a twisty maze of C
> code, all different, but I *believe* that error is caused by the fact

[snip]

I didn't feel like doing this when it became clear that I could just
work around systemd's issues by using a different kernel config.

> And it *does* appear that if we had modified the root file system and
> had requested a reboot (at least from the version of systemd sources I
> examined) , it does appear that systemd should have immediately
> started rebooting the system, having printed the exit code (probably
> 3, i.e. FSCK_NONDESTRUCT | FSCK_REBOOT).
> 
> So I think something else was going on here, but given the inability
> for systemd to save logs in this instance, I'm not sure we'll be able
> to figure out what was going on.

That something else is probably the fact that ever since systemd
took over the init scripts, reboot/halt operations fail to actually
reboot/halt my VMs - they just hang instead, which in most
cases is just fine so I've never bothered to track down what magic
kernel config option I need to set to make it work again.

The thing here is that systemd output is not making it clear that it
is rebooting and the fact that the e2fsck output like "**** REBOOT
IMMEDIATELY ****" are swallowed and never appear on the console
means that it's pretty much impossible to determine what went wrong.
Add to that the console log being a massive confusion of things
still starting and some things stopping, and it ends up being
completely indecipherable as to what is going on when it finally
stops doing stuff....

Brave new world, eh?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
