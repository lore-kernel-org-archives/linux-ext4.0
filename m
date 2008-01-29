From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Tue, 29 Jan 2008 09:35:37 -0500
Message-ID: <20080129143537.GH6774@mit.edu>
References: <20080124211728.GA24900@webber.adilger.int> <n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu> <n7x1w82nf7m.fsf@sor.suse.de> <20080128153802.GB17752@mit.edu> <n7xd4rkn3hx.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, hvogel@suse.de,
	Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60051 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759830AbYA2Og2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2008 09:36:28 -0500
Content-Disposition: inline
In-Reply-To: <n7xd4rkn3hx.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 29, 2008 at 02:52:10PM +0100, Matthias Koenig wrote:
> > Are you running aclocal?  That may be causing the issues since I think
> > that may be causing it to ignore the autoconf macros I've established
> > in the top-level aclocal.m4 file.
> 
> Yes, someone here fixed the german po file (I already sent it to
> translation project). So we have to rerun the
> gettext related part, which results in the requirement to rerun aclocal.

Hmm?  You should be able to rebuild the .gmo file without needing to
re-run aclocal.  I do it all the time.  :-)

> > The problem is that the FHS does not guarantee that the subdirectories
> > stick around, and a number of distro's are using mounting tmpfs for
> > /var/run.  Makes sense, it can significantly speed up operations ---
> > but upon reboot, everything in /var/run is *gone*.
> 
> I see, then there is a problem of course. This is not the way it is
> done in Suse, so I did not see this problem.
> But, shouldn't the daemon then have an rc init script which checks for
> the needed subdirectory in /var/run and creates this if necessary?  If I
> look into /var/run I see a lot of daemons running with their own UID/GID
> and having their own directory. In this case there must be a mechanism
> to guarantee the existence of this directory, which would obviously be
> done in the init script (not sure if any init scripts currently do this
> in Suse).

Well, it either needs to be done in the init script or the daemons run
with root privs, create the directory, and then drop root privs.  So
yes, there are alternatives.  (a) Yet Another init script, (b) setuid
root, with a hard-coded user name that has to be looked up via
getpwent() and configured into /etc/passwd or the LDAP server, (c)
just put the darned directory in /var/lib.

It's all about tradeoffs, and for me, (c) was the easist, especially
since /var/lib/libuuid/clock.txt needs to be persistent across boots
anyway, and so needs to be in /var/lib instead of /var/run.  So yes, I
could have created some machinery to make sure /var/run/uuidd is
always present, but why not just reuse the already existing
/var/lib/libuuid directory, which has the correct ownership and which
has to be in /var/lib anyway?

> > and I still haven't figured out how to easily build my own
> > custom kernel RPM's on OpenSUSE, but it's quite nice.
> 
> unfortunately we don't have make-kpkg.

Yeah, and the RPM macros for generating kernel are incredibly twisted.
At least they were for RHEL4, when I was figuring out how to generate
a real-time kernel rpm.  Serious temptations to gouge out my eyeballs
with a spoon by the time I was done....

       	     					- Ted
