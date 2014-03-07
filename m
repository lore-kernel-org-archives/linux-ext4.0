From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Bug 71641] New: Unreasonable performance degradation in ext4
 with full data journaling
Date: Fri, 7 Mar 2014 11:20:26 -0500
Message-ID: <20140307162026.GA18863@thunk.org>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38447 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbaCGQUc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2014 11:20:32 -0500
Content-Disposition: inline
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2014 at 11:39:40AM +0000, bugzilla-daemon@bugzilla.kern=
el.org wrote:
> JFS provides three modes, journal, ordered and writeback.
> The first mode is denoted as =E2=80=98journal mode=E2=80=99in the fol=
lowing context.
> In the journal mode, data should be written twice, one for the journa=
l area and
> the other for the client file system. If the journal area and the cli=
ent file
> system are both located in the disk, it has at least 50% performance
> degradation compared to ordered mode.
> But what if we put the journal area in a ramdisk?

How big was the ramdisk?  Since all of the blocks are going through
the journal, even if it is on the journal, it requires more commits
and thus more checkpoint operations, which means more updates to the
disk.  A bigger journal will help minimize this issue.

Would you be willing to grab block traces for both the disk and the
external journal device?

I will add that the workload of "dd if=3D/dev/zero of=3Dfile" is probab=
ly
the worst case for data=3Djournal, and if that's really what you are
doing, it's a case of "doctor, doctor, it hurts when I do that".  All
file systems modes will have strengths and weaknesses, and your use
case one where I would simply tell people, "don't use that mode".

If you want to work on improving it, that's great.  Gather data, and
if we can figure out an easy way to improve things, great.  But I'll
warn you ahead of time this is not necessarily something I view as
"unreasonable", nor is it something that I would consider a high
priority thing to fix.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
