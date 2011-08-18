From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: Re: a (documented) way to get the Ext2+ filesystem size?
Date: Thu, 18 Aug 2011 10:49:38 +0700
Message-ID: <86ei0jxtt9.fsf@gray.siamics.net>
References: <86aab94mfg.fsf@gray.siamics.net>
	<20110817183101.GC6901@thunk.org> <86mxf7yirb.fsf@gray.siamics.net>
	<20110817220953.GD6901@thunk.org>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39342 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab1HRDtx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 23:49:53 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Qttc8-0002As-KF
	for linux-ext4@vger.kernel.org; Thu, 18 Aug 2011 05:49:52 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2011 05:49:52 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2011 05:49:52 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> Ted Ts'o <tytso@mit.edu> writes:
>>>>> On Thu, Aug 18, 2011 at 01:50:48AM +0700, Ivan Shmakov wrote:

[=E2=80=A6]

 >> The intent is to process a filesystem image, not a mounted
 >> filesystem.  It's my understanding that I cannot use neither
 >> statfs(2) nor POSIX' statvfs(2) in this case.

 >> The code I've posted earlier is used in my e2dis [1=E2=80=933] proj=
ect.

 > For this, I'd suggest that you use the ext2fs library.  That will
 > take care of byte swapping, etc.  It also means that you don't have
 > to worry about parsing the extent trees.  If you had used the ext2fs
 > library before ext4 had shipped, you wouldn't have had to make any
 > changes to support extents, since the ext2fs library wraps and
 > provides abstract interfaces for most of what you would need for
 > e2dis project.

	I don't seem to understand.  I've scanned through the
	(libext2fs.info) Function Index section (as per the Debian's
	e2fslibs-dev package, 1.41.12-2), and I see no mention of a
	function that I can use for that.

	Thus, I've ended up writing my own one, which takes an
	ext2_filsys handle, and references, via its =E2=80=98super=E2=80=99 me=
mber, the
	=E2=80=98s_blocks_count=E2=80=99 and =E2=80=98s_blocks_count_hi=E2=80=99=
 members of the
	superblock structure.

	However, I was concerned that I don't seem to find the
	documentation for these structures' contents anywhere.  (Sans
	the source, of course), and wondered, if the interface I use is
	at least stable?

	TIA.

--=20
=46SF associate member #7257	Coming soon: Software Freedom Day
http://mail.sf-day.org/lists/listinfo/ planning-ru (ru), sfd-discuss (e=
n)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
