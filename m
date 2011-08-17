From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: Re: e2dis: a Jigdo-like tool for Ext2+ FS
Date: Wed, 17 Aug 2011 12:49:11 +0700
Message-ID: <86ei0k1tbc.fsf@gray.siamics.net>
References: <86ei0p8ve2.fsf@gray.siamics.net>
	<alpine.LFD.2.00.1108151125470.3695@dhcp-27-109.brq.redhat.com>
	<86zkjb3p7f.fsf@gray.siamics.net>
	<alpine.LFD.2.00.1108151759040.3695@dhcp-27-109.brq.redhat.com>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50777 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab1HQFt0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 01:49:26 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QtZ0H-0004vn-6M
	for linux-ext4@vger.kernel.org; Wed, 17 Aug 2011 07:49:25 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 07:49:25 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 07:49:25 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> Lukas Czerner <lczerner@redhat.com> writes:
>>>>> On Mon, 15 Aug 2011, Ivan Shmakov wrote:

	BTW, the primary Git repository for the project is now located
	at Gitorious:

git://gitorious.org/e2dis/e2dis-devel.git
http://gitorious.org/e2dis/e2dis-devel.git
https://gitorious.org/e2dis/e2dis-devel

	The most notable improvement that I made recently is that the
	payload message digests are now recorded.  (The support for the
	whole-image and metadata message digests is not yet committed.)

[=E2=80=A6]

 >> =E2=80=A2 moreover, I see no claims that the output of the debugfs(=
8) =E2=80=98stat=E2=80=99
 >> command won't ever change (neither I see the formal description of
 >> the aforementioned output =E2=80=94 its source is the only form of
 >> specification I could rely); my guess is that the C API, being
 >> documented, is going to be much more stable;

 > Well, you can probably say that about every tool,

	Why, there're plenty of tools that support either some sort of a
	standardized output, or output that's user-defined (based on
	some standardized items.)  E. g., the output of ls(1) and
	date(1) is defined by POSIX (IEEE Std 1003.1-2008), etc.

 > but that is not good enough reason to duplicate the code for
 > everything.  Although I am not saying that you're doing so.

	I believe that there's very little, if any, code duplication
	between e2dis and debugfs.

[=E2=80=A6]

--=20
=46SF associate member #7257	Coming soon: Software Freedom Day
http://mail.sf-day.org/lists/listinfo/ planning-ru (ru), sfd-discuss (e=
n)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
