From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: Re: a (documented) way to get the Ext2+ filesystem size?
Date: Thu, 18 Aug 2011 01:50:48 +0700
Message-ID: <86mxf7yirb.fsf@gray.siamics.net>
References: <86aab94mfg.fsf@gray.siamics.net>
	<20110817183101.GC6901@thunk.org>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59034 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab1HQSvF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 14:51:05 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QtlCh-0007PW-Ed
	for linux-ext4@vger.kernel.org; Wed, 17 Aug 2011 20:51:03 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 20:51:03 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 20:51:03 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> Ted Ts'o <tytso@mit.edu> writes:
>>>>> On Tue, Aug 16, 2011 at 06:37:23PM +0700, Ivan Shmakov wrote:

 >> How do I get the Ext2+ filesystem size (in blocks)?

 > I assume you need the exact numbers, so you can't use statfs(2)?
 > What are you using it for?

	The intent is to process a filesystem image, not a mounted
	filesystem.  It's my understanding that I cannot use neither
	statfs(2) nor POSIX' statvfs(2) in this case.

	The code I've posted earlier is used in my e2dis [1=E2=80=933] project=
=2E

[1] http://article.gmane.org/gmane.linux.debian.devel.general/164488
[2] http://article.gmane.org/gmane.comp.file-systems.ext4/27269
[3] https://gitorious.org/e2dis/

--=20
=46SF associate member #7257	Coming soon: Software Freedom Day
http://mail.sf-day.org/lists/listinfo/ planning-ru (ru), sfd-discuss (e=
n)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
