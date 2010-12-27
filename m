From: Filipe David Manana <fdmanana@apache.org>
Subject: question about file space preallocation with fallocate
Date: Mon, 27 Dec 2010 14:47:50 +0000
Message-ID: <AANLkTinRcYrMrOUYqqCM3Lkpnhinm4NXqzDg1p2p0+68@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46578 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab0L0Orx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 09:47:53 -0500
Received: by fxm20 with SMTP id 20so9150647fxm.19
        for <linux-ext4@vger.kernel.org>; Mon, 27 Dec 2010 06:47:52 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have been playing around with fallocate to preallocate space for a
file with the mode FALLOC_FL_KEEP_SIZE.
I'm running with Linux kernel 2.6.35-24 and ext4 as the fs.

I'm allocating 1Gb for a newly created file and then in a loop I write
1Gb of data into that file in chunks of 1Kb.
fallocate is returning me 0, therefore it was successful.
However I don't see any performance gains compared to a version of
that same code that doesn't call fallocate.

The test code which does this is:  http://friendpaste.com/2UR0n2U851u4I=
XmubeLZh0

Am I doing something wrong?

best regards,

--=20
=46ilipe David Manana,
fdmanana@gmail.com, fdmanana@apache.org

"Reasonable men adapt themselves to the world.
=C2=A0Unreasonable men adapt the world to themselves.
=C2=A0That's why all progress depends on unreasonable men."
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
