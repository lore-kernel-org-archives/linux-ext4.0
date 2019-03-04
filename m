Return-Path: <SRS0=/gtt=RH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E09EC10F03
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 16:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6752C206B6
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 16:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfCDQC6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Mar 2019 11:02:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59800 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfCDQC6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Mar 2019 11:02:58 -0500
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 399CD805A5; Mon,  4 Mar 2019 17:02:49 +0100 (CET)
Date:   Mon, 4 Mar 2019 17:02:55 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Cc:     jack@suse.cz, linux-fsdevel@vger.kernel.org
Subject: 5.0.0-rc8-next-20190301+: kernel bug at fs/inode.c:513
Message-ID: <20190304160255.GA6914@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

This happened on trying to sync filesystems with unison:

Any ideas?

Should I be forcing fsck soon?
								Pavel

[12717.827444] ------------[ cut here ]------------
[12717.827465] kernel BUG at fs/inode.c:513!
[12717.827486] invalid opcode: 0000 [#1] SMP PTI
[12717.827495] CPU: 1 PID: 916 Comm: kswapd0 Not tainted
5.0.0-rc8-next-20190301+ #224
[12717.827501] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW
(2.19 ) 03/31/2011
[12717.827515] EIP: clear_inode+0x78/0xa0
[12717.827522] Code: 83 0c 01 00 00 8d 93 0c 01 00 00 39 c2 75 3b c7
83 9c 00 00 00 60 00 00 00 5b 5e 5d c3 90 8d 74 26 00 0f 0b 8d b6 00
00 00 00 <0f> 0b 8d b6 00 00 00 00 0f 0b 8d b6 00 00 00 00 0f 0b 8d b6
00 00
[12717.827529] EAX: c57b540c EBX: cea39720 ECX: 00000001 EDX: 00000000
[12717.827535] ESI: cea39860 EDI: cea39824 EBP: f1a61d38 ESP: f1a61d30
[12717.827541] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS:
00010086
[12717.827548] CR0: 80050033 CR2: 1d8e0000 CR3: 06dbc000 CR4: 000006b0
[12717.827553] Call Trace:
[12717.827566]  ext4_clear_inode+0x12/0x70
[12717.827575]  ext4_evict_inode+0x76/0x460
[12717.827582]  evict+0xa4/0x1b0
[12717.827589]  dispose_list+0x39/0x50
[12717.827597]  prune_icache_sb+0x42/0x60
[12717.827604]  ? iput+0x150/0x150
[12717.827613]  super_cache_scan+0x106/0x160
[12717.827621]  shrink_slab.constprop.82+0x172/0x280
[12717.827629]  shrink_node+0x831/0xa00
[12717.827638]  ? inactive_list_is_low.constprop.81+0x18a/0x1c0
[12717.827645]  kswapd+0x331/0x780
[12717.827651]  ? kswapd+0x331/0x780
[12717.827663]  kthread+0xe7/0x120
[12717.827669]  ? shrink_all_memory+0xd0/0xd0
[12717.827676]  ? kthread_park+0xa0/0xa0
[12717.827686]  ret_from_fork+0x2e/0x38
[12717.827692] Modules linked in:
[12717.827702] ---[ end trace e6eadf01587ff9cc ]---
[12717.827710] EIP: clear_inode+0x78/0xa0
[12717.827716] Code: 83 0c 01 00 00 8d 93 0c 01 00 00 39 c2 75 3b c7
83 9c 00 00 00 60 00 00 00 5b 5e 5d c3 90 8d 74 26 00 0f 0b 8d b6 00
00 00 00 <0f> 0b 8d b6 00 00 00 00 0f 0b 8d b6 00 00 00 00 0f 0b 8d b6
00 00
[12717.827723] EAX: c57b540c EBX: cea39720 ECX: 00000001 EDX: 00000000
[12717.827729] ESI: cea39860 EDI: cea39824 EBP: f1a61d38 ESP: c526947c
[12717.827735] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS:
00010086
[12717.827741] CR0: 80050033 CR2: 1d8e0000 CR3: 06dbc000 CR4: 000006b0
[12717.833838] wlan0: deauthenticated from 5c:f4:ab:10:d2:bb (Reason:
15=3D4WAY_HANDSHAKE_TIMEOUT)
[12734.494782] wlan0: authenticate with 5c:f4:ab:10:d2:bb
[12734.495011] wlan0: send auth to 5c:f4:ab:10:d2:bb (try 1/3)

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlx9TC8ACgkQMOfwapXb+vIwSwCdGevIhpWBXqx8dE1r3kIxDYWQ
EC4An1lGj0jYY8InuU5deV+96XePdaya
=fWCw
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
