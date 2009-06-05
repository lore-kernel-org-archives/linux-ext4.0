From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Fri, 5 Jun 2009 14:42:18 -0700
Message-ID: <6601abe90906051442t294c2e79i3c6dc38c1d53e5e0@mail.gmail.com>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com>
	 <20090605180125.GB6442@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>, Aioanei Rares <krnl.list@gmail.com>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:37292 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZFEVmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 17:42:19 -0400
In-Reply-To: <20090605180125.GB6442@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 5, 2009 at 11:01 AM, Theodore Tso<tytso@mit.edu> wrote:
> On Fri, Jun 05, 2009 at 05:40:33PM +0300, Aioanei Rares wrote:
>>> When I upgrade libc from 2.7 (debian stable) to 2.9 (debian unstabl=
e),
>>> the locale breaks every reboot, and I have to repair it by running
>>> locale-gen. =A0This happened now when I only upgraded libc, in orde=
r to
>>> play with signalfd(). =A0It also happened before, when I upgraded t=
he
>>> entire machine to debian unstable (which I later reverted).
>>>
>>> The problem is that /usr/lib/locale/locale-archive gets corrupted w=
hen
>>> I reboot. =A0The exact corruption differs with each reboot (i.e. th=
e
>>> md5sum differs). =A0Last time, the first ~70K was overwritten with =
data
>>> from xorg.log and my web browsing history. =A0I have copies of the
>>> original and corrupted state which I can send, the full file is 1.3
>>> megs, but I can limit it to the first 70K, since that's all that wa=
s
>>> corrupted.
>
>> I suspect, although I might be wrong, that this is not a kernel-rela=
ted
>> problem.
>
> Actually, I suspect it is indeed a kernel-related problem. =A0The
> problem has been reported before, with a repeatable test case:
>
> =A0 =A0 =A0 =A0http://bugzilla.kernel.org/show_bug.cgi?id=3D13292
>
> The problem shows up after you unmount and remount the filesystem.
> Before you the filesystem is unmounted, the locale-archive file has
> the correct md5sum. =A0After you unmount and remount the filesystem, =
the
> filesystem is corrupted. =A0I'm guessing that some data blocks aren't
> getting marked as needing writeback, so the previous contents on disk
> aren't written back. =A0I was able to show that even though the mount=
ed
> filesystem had the correct information, direct access to the disk
> using debugfs showed the blocks on disk had the contents that would b=
e
> revealed after the filesystem was unmounted and remounted.
>
> The problem only shows up when using ext4 without a journal, and I wa=
s
> never able to create a simpler reproduction case. =A0The last time I
> tried to work on this bug was approximately a month ago. =A0About two
> weeks ago Frank from Google tried reproducing it, but he wasn't able
> to do so using his 2.6.26-based kernel plus an updated ext4.
> Unfortunately, I haven't had time to look at it since then, or to
> check to see if some of the more recent patches scheduled for the
> 2.6.31 merge window might have changed the behaviour of this bug.

Just FYI: Frank Mayhar has recreated this issue in a recent kernel
(though we're not seeing it with our 2.6.26 kernel + ext4 patches),
and is actively working on it.

Curt

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 - Ted
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
