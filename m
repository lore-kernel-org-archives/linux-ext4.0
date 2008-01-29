From: Matthias Koenig <mkoenig@suse.de>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Tue, 29 Jan 2008 14:52:10 +0100
Message-ID: <n7xd4rkn3hx.fsf@sor.suse.de>
References: <20080124211728.GA24900@webber.adilger.int>
	<n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu>
	<n7x1w82nf7m.fsf@sor.suse.de> <20080128153802.GB17752@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, hvogel@suse.de,
	Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:55373 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932848AbYA2NwN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2008 08:52:13 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> On Mon, Jan 28, 2008 at 04:26:53PM +0100, Matthias Koenig wrote:
>> > Patch6:         e2fsprogs-mdraid.patch
>> >
>> > This apparently adds a new environment variable,
>> > BLKID_SKIP_CHECK_MDRAID, which forces blkid to not detect mdraid
>> > devices.  I'm not sure why.
>> 
>> Workaround for people having stale RAID signature on their disk:
>> https://bugzilla.novell.com/show_bug.cgi?id=100530
>
> Hmm... there's got to be a better way around this.
>
> I'm not authorized to look at that BZ entry.  Is there any way you can
> make my "tytso" account have access to any e2fsprogs related BZ
> entries?  Thanks!

Still waiting for the person with privileges to do this.
In the meanwhile I will add you to the CC list of this bug, then you
should also be able to access the bug.

>
>> > Patch12:        e2fsprogs-mkinstalldirs.patch
>> >
>> > Why?
>> 
>> Is needed since we recreate the auto* files.
>> But I agree that this patch should better set
>> MKINSTALLDIRS = @MKDIR_P@
>> not to literal "mkdir -p". The @MKINSTALLDIRS@ seems to be
>> obsolete in newer gettext (which seems to pull this in).
>
> Are you running aclocal?  That may be causing the issues since I think
> that may be causing it to ignore the autoconf macros I've established
> in the top-level aclocal.m4 file.

Yes, someone here fixed the german po file (I already sent it to
translation project). So we have to rerun the
gettext related part, which results in the requirement to rerun aclocal.

>
>> > Patch22:        e2fsprogs-1.40.4-uuidd_pid_path.patch
>> >
>> > The problem with this patch is that /var/run is cleared via rm -rf, so
>> > it is highly problamtic to put the scratch directory for uuidd in
>> > /var/run.
>> 
>> Are you really sure? My interpretation of FHS is, that files under
>> /var/run/ have to be cleared or truncated, but the subdirectories do not
>> get deleted.
>
> The problem is that the FHS does not guarantee that the subdirectories
> stick around, and a number of distro's are using mounting tmpfs for
> /var/run.  Makes sense, it can significantly speed up operations ---
> but upon reboot, everything in /var/run is *gone*.

I see, then there is a problem of course. This is not the way it is
done in Suse, so I did not see this problem.
But, shouldn't the daemon then have an rc init script which checks for
the needed subdirectory in /var/run and creates this if necessary?  If I
look into /var/run I see a lot of daemons running with their own UID/GID
and having their own directory. In this case there must be a mechanism
to guarantee the existence of this directory, which would obviously be
done in the init script (not sure if any init scripts currently do this
in Suse). The only problem with uuidd is that it is designed to run upon
demand. But on the other side it is also not strictly necessary to run
uuidd to create UUIDs, only if you have special requirements on the
UUIDs. So I don't see a problem if uuidd could not be started for the
creation of UUIDs *generally* and if people wanting really unique
time-based UUIDs are required to run the init script first upon boot, 
which guarantees the existence of the /var/run/uuidd directory.
Any problems with this approach?

> Please let me know when you have a newer OpenSUSE factory RPM ready
> for use, and I'll take a look at the remaining patches and see which
> ones are ready for merging upstream. 

Yes, will do so. I am currently still looking through all the patches
where they come from and why they are needed. Will probably submit
a new package today.

> and I still haven't figured out how to easily build my own
> custom kernel RPM's on OpenSUSE, but it's quite nice.

unfortunately we don't have make-kpkg.

Matthias
