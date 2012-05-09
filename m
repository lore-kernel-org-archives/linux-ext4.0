From: Martin Steigerwald <ms@teamix.de>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Wed, 9 May 2012 11:34:00 +0200
Message-ID: <201205091134.00281.ms@teamix.de>
References: <4FA7A83E.6010801@pocock.com.au> <4FA93BB2.9050509@pocock.com.au> <201205090930.02731.ms@teamix.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:34793 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758929Ab2EIJeD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2012 05:34:03 -0400
In-Reply-To: <201205090930.02731.ms@teamix.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Mittwoch, 9. Mai 2012 schrieb Martin Steigerwald:
> You could adapt to /usr/share/doc/fio/examples/iometer-file-access-server
> to  benchmark such a scenario. Also fsmark simulates such a heavy fsync()
> based quite well. I have packaged it for Debian, but its still in NEW
> queue. You can grab it from
> 
> http://people.teamix.net/~ms/debian/sid/
> 
> (32-Bit build, but easily buildable for amd64 as well)

I have uploaded 64-bit builds of both fsmark and newer fio 2.0.7 as I needed 
them for my own use. They are build for Wheezy/Sid, but according to 
dependencies should work on Squeeze as well.

-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
