From: Dave Chinner <david@fromorbit.com>
Subject: 2.6.35-r5 ext3 corruptions
Date: Thu, 15 Jul 2010 20:57:45 +1000
Message-ID: <20100715105745.GI30737@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:56380 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933032Ab0GOK5t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Jul 2010 06:57:49 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Upgrading my test vms from 2.6.35-rc3 to 2.6.35-rc5 is resulting in
repeated errors on the root drive of a test VM:

{ 1532.368808] EXT3-fs error (device sda1): ext3_lookup: deleted inode =
referenced: 211043
[ 1532.370859] Aborting journal on device sda1.
[ 1532.376957] EXT3-fs (sda1):=20
[ 1532.376976] EXT3-fs (sda1): error: ext3_journal_start_sb: Detected a=
borted journal
[ 1532.376980] EXT3-fs (sda1): error: remounting filesystem read-only
[ 1532.420361] error: remounting filesystem read-only
[ 1532.621209] EXT3-fs error (device sda1): ext3_lookup: deleted inode =
referenced: 211043

The filesysetm is a mess when checked on reboot - lots of illegal
references to blocks, multiply linked blocks, etc, but repairs.
=46iles are lots, truncated, etc, so there is visible filesystem
damage.

I did lots of testing on 2.6.35-rc3 and came across no problems;
problems only seemed to start with 2.6.35-rc5, and I've rep=E3=82=8Dodu=
ced
the problem on a vanilla 2.6.35-rc4.

The problem seems to occur randomly - sometimes during boot or when
idle after boot, sometimes a while after boot. I haven't done any
digging at all for the cause - all I've done so far is confirm that
it is reproducable and it's not my code causing the problem.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
