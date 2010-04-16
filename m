From: Jiri Slaby <jirislaby@gmail.com>
Subject: busy inodes -> ext3 umount crash
Date: Fri, 16 Apr 2010 20:09:05 +0200
Message-ID: <4BC8A7C1.20102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: adilger@sun.com, linux-ext4@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:63756 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0DPSJQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Apr 2010 14:09:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

with mmotm 2010-04-05-16-09 and much older (I hadn't camera to take a
picture) I sometimes get a BUG() trace in ext3 umount code:
http://www.fi.muni.cz/~xslaby/sklad/panics/ext3_1.png
http://www.fi.muni.cz/~xslaby/sklad/panics/ext3_2.png

I have no idea how to reproduce it :(, but it usually happens when I do
shutdown/kexec.

Those busy inodes are pretty common in current kernels, I don't know if
that's related -- I doubt it since it is for different bdevs.

Do you have any clue what to test, how to debug that?

@Honza: this is the one we talked about earlier, you wanted to see
details, but I thought it disappeared. (Just in case you are interested.)

Thanks.
