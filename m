From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Subject: GRUB and the risk of block list corruption in extX
Date: Thu, 07 Feb 2013 11:18:30 +0100
Message-ID: <51137F76.8070705@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dgate20.ts.fujitsu.com ([80.70.172.51]:50818 "EHLO
	dgate20.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab3BGK3I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2013 05:29:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

you may have seen the following warning that is displayed when
someone tries to install GRUB2 on in a extX partition:

  "/sbin/grub-setup: warn: Embedding is not possible. GRUB can only be
  installed in this setup by using blocklists. However, blocklists are
  UNRELIABLE and their use is discouraged."

Recently I have been involved in discussions about this on
https://bugzilla.redhat.com/show_bug.cgi?id=872826.

The Grub manual says "installing to a filesystem means that GRUB is
vulnerable to its blocks being moved around by filesystem features such
as tail packing, or even by aggressive fsck implementations".

My question to the extX experts: Under what circumstances (except
modifying, overwriting, deleting the bootloader image "core.img" itself)
can a block list referencing "core.img" be corrupted? In particular:

 1) could it happen during ordinary operation, filesystem code silently
   moving blocks around?
 2) could it happen in an e2fsck run?
 3) could it be caused by e4defrag?
 4) could it happen with resize2fs even if the blocks occupied by the
file fit in the size that the FS is resized to (otherwise obviously "yes")?
 5) Anything else?
 6) if the file was protected with the IMMUTABLE flag, would any of 1-5
still be able to corrupt the file?

Regards
Martin

-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

FUJITSU
Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany
Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck@ts.fujitsu.com
Internet:		http://ts.fujitsu.com
Company Details:	http://ts.fujitsu.com/imprint
