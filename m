From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: To the Gentoo user who recently e-mailed me...
Date: Thu, 05 Jun 2008 16:32:04 -0400
Message-ID: <E1K4M7w-0008In-Mk@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39334 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbYFEUcI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 16:32:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there,

This is a bit embarassing, but due to a mail accident I lost an e-mail
message that was sent by a Gentoo user who was having trouble building
2.6.26-rc4 with a "fairly recent" ext4 patch queue.  I read the note on
my Blackberry, and deleted locally there, and then when I went to deal
with it on my PC mailbox, the mail message seems to have disappeared.
So I don't have the e-mail address of the person who sent the note, but
to whoever was having problems, as far as I know it was building on
2.6.26-rc4, and the current most recent version of the patch queue just
built without problems on 2.6.26-rc5.

There was one version that had problems in balloc.c, which is what I
think I remember you were having problems with, but that was rectified
fairly quickly.  So please try again.

Also, in the future, please CC the linux-ext4 mailing list.  That way
other people can help you out, if I happen to be away from my e-mail for
whatever reason.

Regards,

						- Ted
