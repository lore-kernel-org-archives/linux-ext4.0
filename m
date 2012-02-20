From: =?ISO-8859-15?Q?=22Martin_v=2E_L=F6wis=22?= <martin@v.loewis.de>
Subject: utf8only option
Date: Mon, 20 Feb 2012 23:02:16 +0100
Message-ID: <4F42C2E8.6000303@v.loewis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.31.103]:40385 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2BTWHZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2012 17:07:25 -0500
Received: from [92.206.67.66] (helo=[192.168.178.23])
	by smtprelay06.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <martin@v.loewis.de>)
	id 1RzbJI-0003uX-FA
	for linux-ext4@vger.kernel.org; Mon, 20 Feb 2012 23:02:16 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Many systems use UTF-8 locales these days, resulting in file names
encoded in UTF-8. On such systems, file names not encoded in UTF-8
can cause problems, making it desirable to detect these problems when
the file is created, not when someone attempts to open the file or
display the directory contents.

In order to support this better on Linux, I implemented an utf8only
file system option for ext4. It is an RO_COMPAT option: systems not
supporting it will still be able to mount the volume read-only, but
cannot create new files. Systems supporting the option will refuse
creation of new files with names that are invalid UTF-8 with an
EILSEQ errno code.

This feature was inspired by the ZFS utf8only property.

Unlike the ZFS feature, I propose that the option cannot just
be specified when the file system is created, but also later on
using tune2fs. The kernel will reject creation of new non-UTF-8
names; existing non-UTF-8 names can still be accessed. This will
allow users to run convmv on the volume to convert any remaining
non-UTF-8 names.

I'm uncertain how fsck should deal with non-UTF-8 files when it
sees that the option is turned on. I can imagine these alternatives:
- ignore the issue, letting the user use convmv
- convert the file names to UTF-8, assuming they are currently
  Latin-1. This assumption may be incorrect; it may also create
  conflicts with existing files in the same directory.
- convert the file names to UTF-8, assuming an encoding specified
  on the command line (essentially integrating convmv into fsck).
  This may still cause conflicts with existing files.
- convert non-UTF-8 bytes to private-use characters, encoded
  in UTF-8. This has a very low but non-zero chance of creating
  conflicts, and it is possible to locate the converted files
  afterwards by looking at those PUA characters.
- move the files to lost+found, renaming them uniquely
  (possibly in a way that still allows to recreate the original
   directory and file name, e.g.
  <dir-inum>-<inum>-nameWithPUAchars)

The patch makes no attempt to provide Unicode normalization.

I just noticed that the specific RO feature selected conflicts
with the one that was just reserved; I'll update the patches
shortly.

The patches are in the utf8only branches of

https://github.com/loewis/linux
https://github.com/loewis/e2fsprogs

Please let me know what you think.

Regards.
Martin
