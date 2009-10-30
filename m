From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad
 corruption with  2.6.32-rc1 and upwards]
Date: Fri, 30 Oct 2009 16:47:38 +0100
Message-ID: <1256917658.3145.20.camel@mini>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ted Augustine <taugustine@techpathways.com>,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59702 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932517AbZJ3Prh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Oct 2009 11:47:37 -0400
In-Reply-To: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Freitag, den 30.10.2009, 10:20 -0400 schrieb Greg Freemyer:
> On Fri, Oct 30, 2009 at 4:22 AM,  <bugzilla-daemon@bugzilla.kernel.org> wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=14354
> >
> > --- Comment #152 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-30 08:22:10 ---
> > Ted,
> > Thank you for explanation :)
> > Notice: i learning computer forensic, and was trained to mount all evidence
> > systems with "-o ro" to not contaminate it. It seems like ext4 break this
> > tradition, so many forensics will surprised  why md5sum do not match.
> 
> Ted,  (Alexey there is a response to further down).
> 
> I have not followed this thread ultra-closely but Alexey's comment got
> my attention.
> 
> Ignoring computer forensics, with LVM snapshots, hardware raid array
> snapshots, etc. even in the presence of a dirty log, we need to be
> able to mount a drive in true read-only fashion fro many backup
> operations to function correctly.
> 
> XFS added an extra mount flag for that 5 or so years ago.
> 
> I hope ext4 either has or will add a true read-only mount option.
> Maybe Eric Sandeen remembers the actual drivers for adding that
> feature to XFS.
> 
> Alexey,
> 
> I do computer forensics as part of my job (see my signature). Never
> trust the -o ro flag with any filesystem type to keep evidence from
> being modified.  It is not designed for forensic use.  And it is hard
> to test because it may work in most scenarios, but then under certain
> situations, the journal gets applied, or cleared, etc.
> 
> fyi: Yes I have read where doing so is advised, but I think that
> technique was developed back before Journaled filesystems were common.
>  With a modern FS, it is just not a reliable technique in all
> situations.
> 
> If you must mount a filesystem readonly to perform an exam, then use a
> hardware write-blocker to prevent modification.  If the filesystem
> cannot be mounted readonly because a writeblocker is in use, then you
> know you have issues.
> 
> The reality is that in more complex exams, we clone the original
> evidence, then perform part of the exam in a live environment.  This
> clearly modifies the clone, but not the original.  But the process
> should be repeatable by simply making more clones, etc.
> 
> Greg

Greg,
thank you for the comment,
as a student i do not own a hardware write-blocker. But even for normal
admin work, this can cause some frustration. With your comment i
realized that i probably screwed up some raid1 array. I used "-o ro" to
open one of disks. :( need to check it now.

