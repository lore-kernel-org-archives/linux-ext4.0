From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: ext2fs_test_block_bitmap (): Unknown code ext2 47 #0, etc.
Date: Thu, 18 Aug 2011 23:27:30 +0700
Message-ID: <867h6awuq5.fsf_-_@gray.siamics.net>
References: <86ei0p8ve2.fsf@gray.siamics.net>
	<alpine.LFD.2.00.1108151125470.3695@dhcp-27-109.brq.redhat.com>
	<86zkjb3p7f.fsf@gray.siamics.net>
	<alpine.LFD.2.00.1108151759040.3695@dhcp-27-109.brq.redhat.com>
	<86ei0k1tbc.fsf@gray.siamics.net>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47494 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044Ab1HRQ1p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Aug 2011 12:27:45 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Qu5RX-0007tq-1N
	for linux-ext4@vger.kernel.org; Thu, 18 Aug 2011 18:27:43 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2011 18:27:43 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2011 18:27:43 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> Ivan Shmakov <ivan@gray.siamics.net> writes:

[=E2=80=A6]

 > (The support for the whole-image and metadata message digests is not
 > yet committed.)

	The code is now ready to be committed.  However, I'm getting the
	following message on stderr upon a call (only the first one?) to
	ext2fs_test_block_bitmap ():

--cut--
Unknown code ext2 47 #0 for block bitmap for /dev/stdin
--cut--

	Otherwise, e2dis seems to behave sanely.

	Also, do I understand it correctly that I need to call
	ext2fs_read_block_bitmap () before accessing the block_map
	member of the ext2_filsys structure?

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
