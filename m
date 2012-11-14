From: "Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>
Subject: ext4 settings in an embedded system
Date: Wed, 14 Nov 2012 11:41:59 +0100
Message-ID: <C0489DC3A08C21449F8FE865472DC75204834F08@BUDMLVEM03.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:58850 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab2KNKmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Nov 2012 05:42:52 -0500
Content-class: urn:content-classes:message
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I would like to have advice regarding features and options.
I am working with an embedded system equipped with an IDE Flash Disk an=
d the ext4 filesystem. I have identified 3 problems that I would like t=
o solve in our product. The power is abruptly turned off from time to t=
ime, this has sometimes resulted in broken Superblock (inode8) and empt=
y files with size 0 bytes. It also happens that file changes is not com=
mitted to disk even if minutes pass before a power loss. This is very u=
ndesirable and expensive in our case, we are searching for a solution o=
r a workaround to the problems.
List with my problems I like to solve:
1. Broken Superblock (inode8).
2. Empty files, size 0.
3. Very long auto commit times, several minutes with default settings.


Is ext4 a bad choice for an embedded system with I 1Gb IDE Flash Disk a=
nd Debian 2.6.32-5-686? =A0Should we change filesystem?

I am planning to set the mount flags: barrier=3D1, commit=3D1 and data=3D=
journal, is this the way to go with an embedded system and ext4?=20

Is there more ext4 options/settings I can use to get an embedded system=
 reliable when a power loss occurs?

Best Regards

=46redrik Ohlsson
Software Engineer



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
