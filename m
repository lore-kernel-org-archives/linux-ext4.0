From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: EXT4-fs: group descriptors corrupted!
Date: Wed, 25 Feb 2009 18:41:42 -0500
Message-ID: <87f94c370902251541h35aa3ccj69a62c7c1e81f7e6@mail.gmail.com>
References: <49A5AC83.1020009@cox.net> <20090225213046.GF1363@mit.edu>
	 <49A5BC63.9030104@cox.net> <20090225231853.GG1363@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ron Johnson <ron.l.johnson@cox.net>,
	Linux-Ext4 <linux-ext4@vger.kernel.org>,
	Ric Wheeler <rwheeler@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:38654 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbZBYXlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 18:41:44 -0500
Received: by qw-out-2122.google.com with SMTP id 5so465121qwi.37
        for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 15:41:42 -0800 (PST)
In-Reply-To: <20090225231853.GG1363@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Smart ass comment about the new ATA spec intentionally top-posted.

Question:  How do you know those sectors did not somehow get
discarded, then modified behind the scenes by a SSD, then fixated to
new deterministic values by a read.

Answer: Because devices that do that aren't shipping yet.

Damn the future looks good from here.

On Wed, Feb 25, 2009 at 6:18 PM, Theodore Tso <tytso@mit.edu> wrote:
> Huh. =A0OK, there's something really strange going on here.
>
> The kernel never updates the backup superblock; that's by design, to
> avoid corruption problems. =A0So for example, on my laptop, if I run
> dumpe2fs on my root partition, I see this:
>
> Filesystem created: =A0 =A0 =A0 Fri Feb 13 09:00:02 2009
> Last mount time: =A0 =A0 =A0 =A0 =A0Tue Feb 24 14:34:19 2009
> Last write time: =A0 =A0 =A0 =A0 =A0Tue Feb 24 14:34:19 2009
> Mount count: =A0 =A0 =A0 =A0 =A0 =A0 =A03
> Maximum mount count: =A0 =A0 =A030
> Last checked: =A0 =A0 =A0 =A0 =A0 =A0 Sat Feb 14 10:46:41 2009
> Check interval: =A0 =A0 =A0 =A0 =A0 15552000 (6 months)
> Next check after: =A0 =A0 =A0 =A0 Thu Aug 13 11:46:41 2009
>
> However, if I run dumpe2fs -o superblock=3D32768 on my root partition=
,
> I'll see this:
>
> Filesystem created: =A0 =A0 =A0 Fri Feb 13 09:00:02 2009
> Last mount time: =A0 =A0 =A0 =A0 =A0Fri Feb 13 11:22:06 2009
> Last write time: =A0 =A0 =A0 =A0 =A0Sat Feb 14 10:47:11 2009
> Mount count: =A0 =A0 =A0 =A0 =A0 =A0 =A00
> Maximum mount count: =A0 =A0 =A030
> Last checked: =A0 =A0 =A0 =A0 =A0 =A0 Sat Feb 14 10:46:41 2009
> Check interval: =A0 =A0 =A0 =A0 =A0 15552000 (6 months)
> Next check after: =A0 =A0 =A0 =A0 Thu Aug 13 11:46:41 2009
>
> Note the difference in the "last write time" and the "last mount
> time". =A0That's because normally we avoid touching the backup
> superblocks.
>
> Now let's take a look at your dumpe2fs output. =A0In your case, we se=
e
> the following:
>
> Filesystem created: =A0 =A0 =A0 Thu Jan 22 19:33:20 2009
> Last mount time: =A0 =A0 =A0 =A0 =A0Fri Jan 23 16:23:58 2009
> Last write time: =A0 =A0 =A0 =A0 =A0Sun Feb 22 02:31:02 2009
> Mount count: =A0 =A0 =A0 =A0 =A0 =A0 =A01
> Maximum mount count: =A0 =A0 =A024
> Last checked: =A0 =A0 =A0 =A0 =A0 =A0 Fri Jan 23 16:19:49 2009
> Check interval: =A0 =A0 =A0 =A0 =A0 15552000 (6 months)
> Next check after: =A0 =A0 =A0 =A0 Wed Jul 22 17:19:49 2009
>
> and it's the same on both the primary and backup (dumpe2fs -o
> superblock=3D32768). =A0The question is how the heck did *that* happe=
n?
> As I mentioned, the kernel doesn't even have code to touch the backup
> superblock. =A0That would tend to implicate one of the e2fsprogs tool=
s,
> or sometihng using the e2fsprogs libraries --- but the recent
> libraries (and you're using e2fsprogs 1.41.x) also avoid touching the
> backup superblocks. =A0The only tools that could have done it from
> e2fsprogs userland are e2fsck, tune2fs, and resize2fs, and that
> doesn't explain how the values turned out to be pure garbage.
>
> Does that the "last write" timestamp suggest anything to you? =A0What
> was happening on the system at or around Sun Feb 22 02:31:02 2009?
> Maybe if we can localize this down to what userspace program caused
> the problem, it'll be a hint.
>
> (This is why I didn't want you to run e2fsck just yet; if you had, it
> would have overwritten the last write time, which could be a value
> clue as to what is causing this problem.)
>
> As far as how to recover your data, what I would recommend doing is
> creating a writeable LVM snapshot, with a pretty good amount of space=
=2E
> Then try running the command "mke2fs -S " on the snapshot, with
> *precisely* the same mke2fs arguments and /etc/mke2fs.conf that you
> used to create the filesystem in the first place. =A0Then cross your
> fingers, and e2fsck on the snapshot, and see how much of the data you
> can recover; some of it may end up in lost+found, but hopefully you'l=
l
> get most of the data back. =A0If it works on snapshot, only then try =
it
> on the real LVM. =A0If it doesn't work out on the snapshot, you can
> always discard it and try again without further corrupting any of you=
r
> original filesystem.
>
> Good luck, and thanks in advance for anything information you can giv=
e
> us to help track down this problem. =A0And this point I'm going to gu=
ess
> that it's a nasty e2fsprogs bug, where somehow the internal in-memory
> version of the block group descriptors got corrupted, and then gotten
> writen out to disk. =A0But this is just a guess at this point --- and
> I'm still left wondering why I haven't seen it on my systems and on m=
y
> regression testing.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0- Ted
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
