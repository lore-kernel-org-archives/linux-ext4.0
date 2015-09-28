From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [4.3-rc1, regression] ext2 vs ext3/ext4 fs probing issues
Date: Mon, 28 Sep 2015 10:36:29 -0700
Message-ID: <20150928173629.GH10390@birch.djwong.org>
References: <20150921070715.GL26895@dastard>
 <20150925235126.GW19114@dastard>
 <20150927231458.GA8638@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
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
> ext4.  We could swap this around, but in that case, ext4 would
> *always* be used in preference to ext2, which not necessarily the best
> thing.  Especially since in most cases most people will be using
> distro initrd's, which don't use the brute-force probe order in
> init/do_mounts.c.  The main people who still use the kernel boot order
> tend to be us died-in-the stick developers who don't believe in
> initrd's (and probably wouldn't be using systemd unless our distro was
> forcing us to).
> 
> Something which I'm thinking about doing --- but which is an awful
> hack --- is to switch the order so we probe ext4 first, but also add
> code in ext4's mount function which checks to see if (a) the pid is 1
> in the root pid namespace, (b) the file system feature set is one that
> can be supported by the ext2 driver, and (c) the ext2 driver is
> available.  In that case, we could fail the mount, so that in the case
> where we are doing the initial boot time probing, and the root file
> system is an ext2 file system, we properly use the ext2 file system if
> it's available.
> 
> This should do what we want in all circumstances, but the question is
> whether I'd respect myself in the morning.....  :-)

How about teaching ext2 to check for compat features that only ext4 handles
(i.e. the journal) and fail the mount so that ext4 will pick it up?  I figure
that most users aren't going to want to mount an ext3 fs with ext2 when ext4
is available.

(But this discussion turns into systemd, so I'm also warily backing away...)

--D

> 
> 	    	    	      	  		- Ted
> 
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
> 
> I could be wrong, since the systemd sources is a twisty maze of C
> code, all different, but I *believe* that error is caused by the fact
> that for some reason, systemd wasn't able to start the executable
> /lib/systemd/systemd-fsck (The string "File System Check on Root
> Device" comes from the file
> /lib/systemd/system/systemd-fsck-root.service, and I'm pretty sure
> this means it wasn't able to start the ExecStart program,
> /lib/systemd/systemd-fsck).
> 
> If /lib/systemd/systemd-fsck (a C program, why use a shell script when
> you can force hard-working programmres to have to comprehend someone
> else's C code) had managed to start fsck.ext[234] and it returned an
> error, you should have seen an explicit message about fsck failing
> with a specific error code and/or signal:
> 
>         if (status.si_code != CLD_EXITED || (status.si_status & ~1)) {
> 
>                 if (status.si_code == CLD_KILLED || status.si_code == CLD_DUMPED)
>                         log_error("fsck terminated by signal %s.", signal_to_string(status.si_status));
>                 else if (status.si_code == CLD_EXITED)
>                         log_error("fsck failed with error code %i.", status.si_status);
>                 else
>                         log_error("fsck failed due to unknown reason.");
> 
>                 if (status.si_code == CLD_EXITED && (status.si_status & 2) && root_directory)
>                         /* System should be rebooted. */
>                         start_target(SPECIAL_REBOOT_TARGET);
>                 else if (status.si_code == CLD_EXITED && (status.si_status & 6))
>                         /* Some other problem */
>                         start_target(SPECIAL_EMERGENCY_TARGET);
>                 else {
>                         r = EXIT_SUCCESS;
>                         log_warning("Ignoring error.");
>                 }
> 
> And it *does* appear that if we had modified the root file system and
> had requested a reboot (at least from the version of systemd sources I
> examined) , it does appear that systemd should have immediately
> started rebooting the system, having printed the exit code (probably
> 3, i.e. FSCK_NONDESTRUCT | FSCK_REBOOT).
> 
> So I think something else was going on here, but given the inability
> for systemd to save logs in this instance, I'm not sure we'll be able
> to figure out what was going on.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
