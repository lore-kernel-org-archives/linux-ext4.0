From: Theodore Tso <tytso@mit.edu>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Mon, 28 Jan 2008 10:38:02 -0500
Message-ID: <20080128153802.GB17752@mit.edu>
References: <20080124211728.GA24900@webber.adilger.int> <n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu> <n7x1w82nf7m.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, hvogel@suse.de,
	Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:56082 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752120AbYA1PiN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2008 10:38:13 -0500
Content-Disposition: inline
In-Reply-To: <n7x1w82nf7m.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2008 at 04:26:53PM +0100, Matthias Koenig wrote:
> > Patch6:         e2fsprogs-mdraid.patch
> >
> > This apparently adds a new environment variable,
> > BLKID_SKIP_CHECK_MDRAID, which forces blkid to not detect mdraid
> > devices.  I'm not sure why.
> 
> Workaround for people having stale RAID signature on their disk:
> https://bugzilla.novell.com/show_bug.cgi?id=100530

Hmm... there's got to be a better way around this.

I'm not authorized to look at that BZ entry.  Is there any way you can
make my "tytso" account have access to any e2fsprogs related BZ
entries?  Thanks!

> > Patch12:        e2fsprogs-mkinstalldirs.patch
> >
> > Why?
> 
> Is needed since we recreate the auto* files.
> But I agree that this patch should better set
> MKINSTALLDIRS = @MKDIR_P@
> not to literal "mkdir -p". The @MKINSTALLDIRS@ seems to be
> obsolete in newer gettext (which seems to pull this in).

Are you running aclocal?  That may be causing the issues since I think
that may be causing it to ignore the autoconf macros I've established
in the top-level aclocal.m4 file.

> > Patch22:        e2fsprogs-1.40.4-uuidd_pid_path.patch
> >
> > The problem with this patch is that /var/run is cleared via rm -rf, so
> > it is highly problamtic to put the scratch directory for uuidd in
> > /var/run.
> 
> Are you really sure? My interpretation of FHS is, that files under
> /var/run/ have to be cleared or truncated, but the subdirectories do not
> get deleted.

The problem is that the FHS does not guarantee that the subdirectories
stick around, and a number of distro's are using mounting tmpfs for
/var/run.  Makes sense, it can significantly speed up operations ---
but upon reboot, everything in /var/run is *gone*.


Please let me know when you have a newer OpenSUSE factory RPM ready
for use, and I'll take a look at the remaining patches and see which
ones are ready for merging upstream.  Markus managed to convince me it
was worthwhile to install the latest OpenSUSE on a laptop so I could
see how things are shaping up, and I have to say I'm pretty impressed.
I haven't updated it to try tracking the latest OpenSUSE factory
RPM's, and I still haven't figured out how to easily build my own
custom kernel RPM's on OpenSUSE, but it's quite nice.

On my "one of these days" list is to get another cheap/used laptop so
I can try out the latest Fedora Core Rawhide without having to fire up
a huge (noisy) x86_64 box....

						- Ted
