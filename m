From: Josef Bacik <josef@redhat.com>
Subject: Re: 2.6.35-r5 ext3 corruptions
Date: Thu, 15 Jul 2010 14:23:18 -0400
Message-ID: <20100715182318.GE21645@dhcp231-156.rdu.redhat.com>
References: <20100715105745.GI30737@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933979Ab0GOSRy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Jul 2010 14:17:54 -0400
Content-Disposition: inline
In-Reply-To: <20100715105745.GI30737@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 15, 2010 at 08:57:45PM +1000, Dave Chinner wrote:
> Upgrading my test vms from 2.6.35-rc3 to 2.6.35-rc5 is resulting in
> repeated errors on the root drive of a test VM:
>=20
> { 1532.368808] EXT3-fs error (device sda1): ext3_lookup: deleted inod=
e referenced: 211043
> [ 1532.370859] Aborting journal on device sda1.
> [ 1532.376957] EXT3-fs (sda1):=20
> [ 1532.376976] EXT3-fs (sda1): error: ext3_journal_start_sb: Detected=
 aborted journal
> [ 1532.376980] EXT3-fs (sda1): error: remounting filesystem read-only
> [ 1532.420361] error: remounting filesystem read-only
> [ 1532.621209] EXT3-fs error (device sda1): ext3_lookup: deleted inod=
e referenced: 211043
>=20
> The filesysetm is a mess when checked on reboot - lots of illegal
> references to blocks, multiply linked blocks, etc, but repairs.
> Files are lots, truncated, etc, so there is visible filesystem
> damage.
>=20
> I did lots of testing on 2.6.35-rc3 and came across no problems;
> problems only seemed to start with 2.6.35-rc5, and I've rep=E3=82=8Do=
duced
> the problem on a vanilla 2.6.35-rc4.
>=20
> The problem seems to occur randomly - sometimes during boot or when
> idle after boot, sometimes a while after boot. I haven't done any
> digging at all for the cause - all I've done so far is confirm that
> it is reproducable and it's not my code causing the problem.
>=20

All I see from 2.6.35-rc4 thats changed is some writeback cleanups, not=
hing that
jumps out at me as being horribly broken.  Could you drop a dump_stack(=
) in that
"deleted inode referenced" message so I can see how we're getting here?=
  The
other stack trace is just because writeback started on a readonly fs, s=
o it
doesn't necessarily have anything to do with the original problem.  Tha=
nks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
