From: Santiago Garcia Mantinan <manty@manty.net>
Subject: flex_bg with tune2fs posible?
Date: Sat, 9 Apr 2011 23:50:17 +0200
Message-ID: <20110409215017.GA17008@vip.manty.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hercules.aytolacoruna.es ([212.51.63.15]:34526 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1DIV6x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Apr 2011 17:58:53 -0400
Received: from vip.manty.net (unknown [85.52.197.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx.aytolacoruna.es (Postfix) with ESMTPSA id 9D7881BC3D3
	for <linux-ext4@vger.kernel.org>; Sat,  9 Apr 2011 23:50:18 +0200 (CEST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

I had converted an ext3 filesystem to ext4 long ago but comparing it's
features with the ones found on a newly formatted ext4 filesystem I found
that I had these features missing:
flex_bg huge_file dir_nlink extra_isize


Current doc at ext4.wiki.kernel.org says: "There are additional ext4
features, such as flex_bg and > 16TB filesystem support that can only
be enabled at format time via mke2fs."

I did activate all these 4 without any problem (2.6.38 with 1.41.12
e2fsprogs) is the doc old and doesn't reflect that this is now possible?

Or have I done something I'll regret?

So far the filesystem seems ok (e2fsck doesn't detect any problems) and
files seem ok as well.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
