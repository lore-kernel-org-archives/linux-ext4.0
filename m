From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Sun, 27 Jan 2008 22:40:25 -0600
Message-ID: <479D5CB9.5060801@redhat.com>
References: <20080124211728.GA24900@webber.adilger.int> <n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu> <479C9E13.8040209@redhat.com> <20080127202725.GA2545@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Matthias Koenig <mkoenig@suse.de>, linux-ext4@vger.kernel.org,
	hvogel@suse.de, Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYA1Ekv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jan 2008 23:40:51 -0500
In-Reply-To: <20080127202725.GA2545@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sun, Jan 27, 2008 at 09:06:59AM -0600, Eric Sandeen wrote:

>>> Patch12:        e2fsprogs-mkinstalldirs.patch
>>>
>>> Why?
>>>
>> Probably same as why we have something similar; for one reason or other
>> need to rerun autoconf, and e2fsprogs isn't compatible with latest
>> autoconf.  (This is a patch I inherited, and haven't yet investigated
>> all the details)
> 
> Define "latest autoconf"?  I'm using autoconf 2.61, which is
> reasonably up-to-date.  Can you send me the output of config.status,
> so I can see what it's setting @MKINSTALLDIRS@ to?

[esandeen@neon devel]$ rpm -q autoconf automake
autoconf-2.61-9.fc8
automake-1.10-6

in our spec file we do:

%build
aclocal
autoconf
%configure --enable-elf-shlibs --enable-nls --disable-e2initrd-helper
--enable-blkid-devmapper --enable-blkid-selinux --enable-dynamic-e2fsck
make %{?_smp_mflags}

and if I fire off the rpm w/o our changes, it terminates with:

making install in e2fsck
make[1]: Entering directory `/usr/src/redhat/BUILD/e2fsprogs-1.40.4/e2fsck'
	MKINSTALLDIRS /sbin /usr/share/man/man8
make[1]: MKINSTALLDIRS@: Command not found
make[1]: *** [installdirs] Error 127

the rpm-generated config.status has no reference to MKINSTALLDIRS.

The e2fsck looks like:

MKINSTALLDIRS = @MKINSTALLDIRS@
...
installdirs:
        @echo " MKINSTALLDIRS $(root_sbindir) $(man8dir)"
        @$(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
                $(DESTDIR)$(man8dir) $(DESTDIR)$(man5dir)

sooo... dunno.  I've never been proficient at autotools.  There's a RH
bug, btw, https://bugzilla.redhat.com/show_bug.cgi?id=220715, which was
"resolved" with the patch we're carrying.

But if you have to chose, I'd rather have extents support in e2fsprogs
than have this problem fixed. ;)

>>> Patch22:        e2fsprogs-1.40.4-uuidd_pid_path.patch
>>>
>>> The problem with this patch is that /var/run is cleared via rm -rf, so
>>> it is highly problamtic to put the scratch directory for uuidd in
>>> /var/run.
>> Hm, I had similar issues with uuidd too - common theme here?
> 
> What issues?  I thought you agreed that using /var/lib was the best
> approach for now.  The Novell patch moves it back to /var/run, which
> will cause significant problems if uuidd is run setuid to a non-root
> user.

Yeah, I ended up leaving it as is - I just mean I went around a bit on
this one too.

>>> Patch32:        libcom_err-no-e2fsck.static.patch
>>>
>>> This patch does two completely unrelated things.  One is to disable
>>> the libcom_err regression test suite (probably because some of the
>>> other changes made) and the other is to disable building the
>>> e2fsck.static file.  Why these two are bundled into a single patch I'm
>>> not sure.
>> And I have a patch to do the latter as well.  Interesting how we've
>> arrived at similar needed changes, independently.  :)
> 
> Yeah, I'll check in a change so that e2fsck is built dynamically by
> default, and e2fsck.static is only built if it is explicitly
> requiested via --enable-static-e2fsck.

That'd be great, thanks, tho again I have a small patch to disable it
too (which I sent, tho I expect you'll do something different)

>> and Patch99:        e2fsprogs-no_cmd_hiding.patch
>>
>> honestly I like that; I should whip up a nice patch to emulate kbuild,
>> with V=1 or something, unless there is some other easy way to show full
>> build commands already?
> 
> Yes, a way to do kbuild with V=1 would be nice.  The main thing that
> makes this difficult is that I've tried to make e2fsprogs not rely on
> any GNU make'isms, since it builds on a number of non-Linux platforms,
> including *BSD, MacOS, Solaris, etc. 
> 
> Personally, it's not a big deal; whenever I need to see what is going
> on, I just edit the makefile and quickly remove the '@' signs.  It's
> really not that hard, and it's rare that I need to look at things.  Of
> course, that could be because I'm more familiar with e2fsprog's build
> system.  :-)

Yes, but when you're sending it off to some multi-arch-build mothership,
and something fails, it's nice to be able to just look at the generated
logs and see exactly what was going on.... ah well.  Again, not the
biggest issue.

-Eric
