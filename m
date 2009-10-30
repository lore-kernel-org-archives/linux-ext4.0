From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad
 corruption with 	2.6.32-rc1 and upwards]
Date: Fri, 30 Oct 2009 16:31:21 +0100
Message-ID: <1256916681.3145.8.camel@mini>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>
	 <4AEB02F0.5040309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Ted Augustine <taugustine@techpathways.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932449AbZJ3PbU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Oct 2009 11:31:20 -0400
In-Reply-To: <4AEB02F0.5040309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Freitag, den 30.10.2009, 10:14 -0500 schrieb Eric Sandeen:
> Greg Freemyer wrote:
> > On Fri, Oct 30, 2009 at 4:22 AM,  <bugzilla-daemon@bugzilla.kernel.org> wrote:
> >> http://bugzilla.kernel.org/show_bug.cgi?id=14354
> >>
> >> --- Comment #152 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-30 08:22:10 ---
> >> Ted,
> >> Thank you for explanation :)
> >> Notice: i learning computer forensic, and was trained to mount all evidence
> >> systems with "-o ro" to not contaminate it. It seems like ext4 break this
> >> tradition, so many forensics will surprised  why md5sum do not match.
> > 
> > Ted,  (Alexey there is a response to further down).
> > 
> > I have not followed this thread ultra-closely but Alexey's comment got
> > my attention.
> > 
> > Ignoring computer forensics, with LVM snapshots, hardware raid array
> > snapshots, etc. even in the presence of a dirty log, we need to be
> > able to mount a drive in true read-only fashion fro many backup
> > operations to function correctly.
> > 
> > XFS added an extra mount flag for that 5 or so years ago.
> > I hope ext4 either has or will add a true read-only mount option.
> > Maybe Eric Sandeen remembers the actual drivers for adding that
> > feature to XFS.
> > 
> 
> After a little brief digging I'm not sure when the xfs mount option went 
> in or why...
> 
> But for both
> 
> xfs: mount -o ro,norecovery
> 
> and
> 
> ext[34]: mount -o ro,noload
> 
> I don't think either one should touch the disk.
> 
> Also, both should skip journal replay if you set the block device 
> readonly prior to mount (hdparm -r can do this).

Interesting tip, thank you.
But there is some problems:
1. "hdparm -r" will set complete drive to ro mode. This is bad if i
use /dev/sda1 for root and /dev/sda5 need to be forced readonly.
2. the fact xfs and ext[3,4] use different options for true_ro make
things complicated.
3. the definition of ro is broken.
4. many frustrated admins who mounted part of raid1 only with "-o ro"

Regards,
Alexey

