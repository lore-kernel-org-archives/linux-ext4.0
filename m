From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable 	"kernel
 BUG 	at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 5 Apr 2011 10:30:11 -0500
Message-ID: <8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com><BE4E
 C1DF-4DFC-4B94-923D-0197B16BD7B4@boeing.com><20110403020227.GA19963@thunk.o
 rg><15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com>
 <20110405001542.GE2832@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:61766 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1DEQgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 12:36:22 -0400
In-Reply-To: <20110405001542.GE2832@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 04, 2011, at 20:15, Ted Ts'o wrote:
> On Mon, Apr 04, 2011 at 09:24:28AM -0500, Moffett, Kyle D wrote:
>> 
>> Unfortunately it was not a trivial process to install Debian
>> "squeeze" onto an EC2 instance; it took a couple ugly Perl scripts,
>> a patched Debian-Installer, and several manual
>> post-install-but-before-reboot steps (like fixing up GRUB 0.99).
>> One of these days I may get time to update all that to the official
>> "wheezy" release and submit bug reports.
> 
> Sigh, I was whoping someone was maintaining semi-official EC2 images
> for Debian, much like alestic has been maintaining for Ubuntu.  (Hmm,
> actually, he has EC2 images for Lenny and Etch, but unfortunately not
> for squeeze.  Sigh....)

The Alestic EC2 images (now replaced by official Ubuntu images) use
kernel images formed as AKIs, which means users can't upload their
own.  Prior to a couple of Ubuntu staff getting special permission
to upload kernel images, all the Alestic EC2 images just borrowed
RedHat or Fedora kernels and copied over the modules.

The big problem for Squeeze is that it uses new udev which is not
compatible with those older kernels.

For the Debian-Installer and my Debian images, I use the PV-GRUB
AKI to load a kernel image from my rootfs.

Specifically, one of the Perl scripts builds an S3-based AMI
containing a Debian-Installer kernel and initramfs (using a tweaked
and preseeded D-I build).  It uploads the AMI to my account and
registers it with EC2.

Then another Perl script starts the uploaded AMI and attaches one
or more EBS volumes for the Debian-Instalelr to use.  When you've
completed the install it takes EBS snapshots and creates an
EBS-backed AMI from those.

The scripts use an odd mix of the Net::Amazon::EC2 CPAN module and
shell callouts to the ec2 tools, but they seem to work well enough.

I'm actually using the official Debian Xen kernels for both the
install process and the operational system, but the regular pv_ops
kernels (without extra Xen patches) work fine too.  The only bug I
found so far was a known workaround for old buggy hypervisors:

  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=592428

That one is fixed in the official "squeeze" release.

>> It's probably easier for me to halt email delivery and clone the
>> working instance and try to reproduce from there.  If I recall, the
>> (easily undone) workaround was to remount from "data=journal" to
>> "data=ordered" on a couple filesystems.  It may take a day or two to
>> get this done, though.
> 
> Couple of questions which might give me some clues:
>   (a) was this a natively formatted ext4 file system, or a ext3 file
>       system which was later converted to ext4?

All the filesystems were formatted like this using Debian e2fstools
as of 9 months ago:

  mke2fs -t ext4 -E lazy_itable_init=1 -L db:mail /dev/mapper/db-mail
  tune2fs -i 0 -c 1 -e remount-ro -o acl,user_xattr,journal_data /dev/mapper/db-mail

Ooooh.... could the lazy_itable_init have anything to do with it?

>   (b) How big are the files/directories involved?  In particular,
>       how big is the Postfix mail queue directory, and it is an
>       extent-based directory?  (what does lsattr on the mail queue
>       directory report)

Ok, there's a couple relatively small filesystems:
  /var/spool/postfix (20971520 sectors, 728K used right now)
  /var/lib/postfix (262144 sectors, 26K used right now)
  /var/mail (8380416 sectors, 340K used right now)

As far as I can tell, everything in each filesystem is using
extents (at least I assume that's what this means from lsattr -R):
  -----------------e- .
  -----------------e- ./corrupt
  -----------------e- ./deferred
  [...]

The "/var/spool/postfix" is the Postfix chroot as per the default
Debian configuration.

I should also mention that the EC2 hypervisor does not seem to
support barriers or flushes.  PV-GRUB complains about that very
early during the boot process.

>   (c) As far as file sizes, does it matter how big the e-mail
>       messages are, and are there any other database files that
>       postgress might be touching at the time that you get the OOPS?

I assume you mean "postfix" instead of "postgres" here.   I'm not
entirely sure because I can't reproduce the OOPS anymore, but there
does not seem to be anything in the Postfix directories other than
the individual spooled-mail files (one per email), some libraries,
some PID files, some UNIX-domain sockets, and a couple of static
files in etc/, so I would assume not.  I'm pretty sure that it is
/var/spool/postfix that was crashing.

The emails that were triggering the issue were between 4k and 120k,
but no more than 100-120 stuck emails total.

The SSL session cache files are stored in /var/lib/postfix, which
as I said above is an entirely separate filesystem.


> I have found a bug in ext4 where we were underestimating how many
> journal credits were needed when modifying direct/indirect-mapped
> files (which would be seen on ext4 if you had a ext3 file system that
> was converted to start using extents; but old, pre-existing
> directories wouldn't be converted), which is why I'm asking the
> question about whether this was an ext2/ext3 file system which was
> converted to use ext4.

I'm not entirely clear if this applies to me or not, but I'm more
than happy to try patches.


> I have a patch to fix it, but backporting it into a kernel which will
> work with EC2 is not something I've done before.  Can anyone point me
> at a web page that gives me the quick cheat sheet?

As I said above, I'm just using unmodified Debian "squeeze" kernels.
The EC2 stuff is basically a really old version of Xen, and latest
upstream kernels with paravirt_ops seem to work.  Not sure how much
good it does since I can't seem to reproduce...

I've switched the relevant filesystems back to data=journal mode,
so if you want to send me a patch for 2.6.32 that I can apply to a
Debian kernel I will keep that kernel around and if I see it happen
again I'll check if the patch fixes it.


>> If it comes down to it I also have a base image (from "squeeze" as of 9 months ago) that could be made public after updating with new SSH keys. 
> 
> If we can reproduce the problem on that base image it would be really
> great!  I have an Amazon AWS account; contact me when you have an
> image you want to share, if you want to share it just with my AWS
> account id, instead of sharing it publically...

Well, the base image is essentially a somewhat basic Debian "squeeze"
for EC2 with our SSH public keys and a couple generic customizations
applied.  It does not have Postfix installed or configured, so there
would be some work involved.

I also didn't see any problems with the system at all until the
queue got backed up with ~100-120 stuck emails.  After Postfix tried
and failed to deliver a bunch of emails I would get the OOPS.

Cheers,
Kyle Moffett