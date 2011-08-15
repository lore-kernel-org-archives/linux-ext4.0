From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: Re: e2dis: a Jigdo-like tool for Ext2+ FS
Date: Mon, 15 Aug 2011 18:10:28 +0700
Message-ID: <86zkjb3p7f.fsf@gray.siamics.net>
References: <86ei0p8ve2.fsf@gray.siamics.net>
	<alpine.LFD.2.00.1108151125470.3695@dhcp-27-109.brq.redhat.com>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39021 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1HOLKs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 07:10:48 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Qsv48-0000Qr-Dq
	for linux-ext4@vger.kernel.org; Mon, 15 Aug 2011 13:10:44 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 15 Aug 2011 13:10:44 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 15 Aug 2011 13:10:44 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> Lukas Czerner <lczerner@redhat.com> writes:
>>>>> On Sat, 13 Aug 2011, Ivan Shmakov wrote:

 >> A couple of weeks ago I've started working on a tool (tentantively
 >> named =E2=80=9CExt2 disassembler=E2=80=9D) to walk through an Ext2+=
 filesystem (or
 >> an image of) and produce the mapping of files' (inodes') relative
 >> block numbers to the image's (or =E2=80=9Cphysical=E2=80=9D) block =
numbers.

 > I have not seen your code, but that sounds like something that
 > debugfs (part of e2fsprogs) is already doing very well (and a lot
 > more).  This is exactly the "extN disassembler" you're talking about

	Not quite.  The meaning of =E2=80=9Cdisassembler=E2=80=9D here is that=
 the image
	is torn in parts, which could later be assembled together to
	form exactly the same image (by an =E2=80=9Cimage assembler=E2=80=9D t=
ool.)

	It's not implied that e2dis will ever produce some sort of
	human-readable output (as its primary result.)  For that,
	debugfs(8) should indeed suffice.

 > and with a little bit of scripting around it you should be able dig
 > any information you desire from the file system so I do not think
 > that new application is needed.  But I might be wrong, just take a
 > look at it.

	Indeed, my first try was to use debugfs(8).  However, there're
	several issues with it:

	=E2=80=A2 I see no way to obtain the list of used inodes in debugfs(8)
	  (as of 1.41.12 debian 2); therefore, I have had to resort to
	  trying the =E2=80=98stat=E2=80=99 command on every possible inode nu=
mber;

	=E2=80=A2 also, the (binary) filesystem data is serialized into ASCII =
by
	  debugfs(8) and is parsed afterwards by the invoking tool,
	  which is computationally-inefficient; (especially if applied
	  to a filesystem with size in the order of several GiB's, and
	  the number of used inodes in the order of tens of thousands,
	  or more);

	=E2=80=A2 moreover, I see no claims that the output of the debugfs(8)
	  =E2=80=98stat=E2=80=99 command won't ever change (neither I see the =
formal
	  description of the aforementioned output =E2=80=94 its source is the
	  only form of specification I could rely); my guess is that the
	  C API, being documented, is going to be much more stable;

	That being said, the most of the code I've written so far is
	concerned /not/ with the filesystems per se (i. e., libext2fs
	calls), but with data recording: representing the data in a
	compact way, interfacing SQLite, etc.  (The SHA-1 computation
	and GNU-style CLI will require some coding as well, thus making
	the Ext2+ FS-specific parts even smaller when compared to the
	overall code size.)

[=E2=80=A6]

--=20
=46SF associate member #7257

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
