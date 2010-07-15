From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: 2.6.35-r5 ext3 corruptions
Date: Thu, 15 Jul 2010 22:14:16 +0200
Message-ID: <201007152214.17898.johannes.hirte@fem.tu-ilmenau.de>
References: <20100715105745.GI30737@dastard>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100715105745.GI30737@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Donnerstag 15 Juli 2010, 12:57:45 schrieb Dave Chinner:
> Upgrading my test vms from 2.6.35-rc3 to 2.6.35-rc5 is resulting in
> repeated errors on the root drive of a test VM:
>=20
> { 1532.368808] EXT3-fs error (device sda1): ext3_lookup: deleted inod=
e
> referenced: 211043 [ 1532.370859] Aborting journal on device sda1.
> [ 1532.376957] EXT3-fs (sda1):
> [ 1532.376976] EXT3-fs (sda1): error: ext3_journal_start_sb: Detected
> aborted journal [ 1532.376980] EXT3-fs (sda1): error: remounting
> filesystem read-only [ 1532.420361] error: remounting filesystem read=
-only
> [ 1532.621209] EXT3-fs error (device sda1): ext3_lookup: deleted inod=
e
> referenced: 211043
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

This sounds like the errors I've encountered with btrfs and XFS:
http://lkml.org/lkml/2010/7/8/181

I'm not sure, but it's quite possible that this started with the change=
 from=20
2.6.35-rc3 to 2.6.35-rc4 .


regards,
  Johannes
