From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad corruption with
	2.6.32-rc1 and upwards]
Date: Fri, 30 Oct 2009 10:20:35 -0400
Message-ID: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Ted Augustine <taugustine@techpathways.com>,
	Alexey Fisher <bug-track@fisher-privat.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:64991 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbZJ3OUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 10:20:32 -0400
Received: by iwn10 with SMTP id 10so2146737iwn.4
        for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 07:20:37 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 30, 2009 at 4:22 AM,  <bugzilla-daemon@bugzilla.kernel.org>=
 wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D14354
>
> --- Comment #152 from Alexey Fisher <bug-track@fisher-privat.net> =A0=
2009-10-30 08:22:10 ---
> Ted,
> Thank you for explanation :)
> Notice: i learning computer forensic, and was trained to mount all ev=
idence
> systems with "-o ro" to not contaminate it. It seems like ext4 break =
this
> tradition, so many forensics will surprised =A0why md5sum do not matc=
h.

Ted,  (Alexey there is a response to further down).

I have not followed this thread ultra-closely but Alexey's comment got
my attention.

Ignoring computer forensics, with LVM snapshots, hardware raid array
snapshots, etc. even in the presence of a dirty log, we need to be
able to mount a drive in true read-only fashion fro many backup
operations to function correctly.

XFS added an extra mount flag for that 5 or so years ago.

I hope ext4 either has or will add a true read-only mount option.
Maybe Eric Sandeen remembers the actual drivers for adding that
feature to XFS.

Alexey,

I do computer forensics as part of my job (see my signature). Never
trust the -o ro flag with any filesystem type to keep evidence from
being modified.  It is not designed for forensic use.  And it is hard
to test because it may work in most scenarios, but then under certain
situations, the journal gets applied, or cleared, etc.

fyi: Yes I have read where doing so is advised, but I think that
technique was developed back before Journaled filesystems were common.
 With a modern FS, it is just not a reliable technique in all
situations.

If you must mount a filesystem readonly to perform an exam, then use a
hardware write-blocker to prevent modification.  If the filesystem
cannot be mounted readonly because a writeblocker is in use, then you
know you have issues.

The reality is that in more complex exams, we clone the original
evidence, then perform part of the exam in a live environment.  This
clearly modifies the clone, but not the original.  But the process
should be repeatable by simply making more clones, etc.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Pap=
er -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html=
>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
