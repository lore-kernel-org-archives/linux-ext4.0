From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: How to resize to an bigger then 16TB ext4 filesysteem on Debian
Date: Thu, 10 Apr 2014 13:28:21 +0200
Message-ID: <53468055.4070700@powercraft.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay02.cambriumhosting.nl ([217.19.16.174]:52358 "EHLO
	relay02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935480AbaDJLhz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 07:37:55 -0400
Received: from relay02.cambriumhosting.nl (localhost [127.0.0.1])
	by relay02.cambriumhosting.nl (Postfix) with ESMTP id 35D8A6000100
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2014 13:28:25 +0200 (CEST)
Received: from yessica.powercraft.nl (ebony.powercraft.nl [84.245.20.130])
	by relay02.cambriumhosting.nl (Postfix) with ESMTP id 2872760000BA
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2014 13:28:25 +0200 (CEST)
Received: from [IPv6:2a02:58:5:2e00:a9e:1ff:fe32:7cf4] (unknown [IPv6:2a02:58:5:2e00:a9e:1ff:fe32:7cf4])
	by yessica.powercraft.nl (Postfix) with ESMTPSA id EF2A720259
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2014 13:28:24 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello everyone,

https://packages.debian.org/wheezy/e2fsprogs

# resize2fs /dev/lvm0-vol/storage
resize2fs 1.42.5 (29-Jul-2012)
resize2fs: New size too large to be expressed in 32 bits

(will the command work with e2fsprogs 1.42.9-3?)

# tune2fs -l /dev/lvm0-vol/storage
http://paste.debian.net/92889/

Suggestions has to be stable enough for production systems.

I now did a lvreduce -L 16TB /dev/lvm0-vol/storage and resize2fs
/dev/lvm0-vol/storage (its running now)

# resize2fs /dev/lvm0-vol/storage
resize2fs 1.42.5 (29-Jul-2012)
Filesystem at /dev/lvm0-vol/storage is mounted on /srv/storage;
on-line resizing required
old_desc_blocks = 464, new_desc_blocks = 1024
Performing an on-line resize of /dev/lvm0-vol/storage to 4294967295
(4k) blocks.

Kind regards,

Jelle de Jong
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iJwEAQECAAYFAlNGgFAACgkQ1WclBW9j5HnDbQP/YRQvZq0HPJ4brpBas+95xeP3
lOnN0OzEOEpjC9pY7J9ppWfkvOkBx7ayjt8MqmJgluwVBNQIRUU3ctftaI7cUPTH
abgj0JHLICCjSIs3nVzQo9pq8URnhTbDXDcXLBemglT5wa+Potlz4YYFA+9Cd/ty
G2jfKBiaNCN17Nmikjo=
=bwbX
-----END PGP SIGNATURE-----
