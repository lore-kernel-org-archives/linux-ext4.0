From: Gordan Bobic <gordan@bobich.net>
Subject: e2fsprogs alignment issues
Date: Wed, 11 Jul 2012 14:20:27 +0100
Message-ID: <4FFD7D9B.2080503@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 78-86-195-58.zone2.bethere.co.uk ([78.86.195.58]:48747 "EHLO
	external.sentinel2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754988Ab2GKN2S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2012 09:28:18 -0400
Received: from thinkpad.shatteredsilicon.net (5adfcbc1.bb.sky.com [90.223.203.193])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by external.sentinel2 (Postfix) with ESMTPSA id 456472A1E
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2012 14:20:30 +0100 (BST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I would like to bring the following bug report to people's attention:

https://bugzilla.redhat.com/show_bug.cgi?id=680090

The issue is that the code used in e2fsprogs WRT allocating unaligned 
buffers and then casting them into structs is non-portable and dangerous 
- eyewateringly dangerous in something like e2fsprogs where it can lead 
to thorough trashing of the file system.

Can something be done to improve the portability of the userspace code?

The issue has been discussed on the Fedora-ARM mailing list:
http://lists.fedoraproject.org/pipermail/arm/2012-July/003637.html
but the argument there was that the issue needs to be fixed upstream, 
hence why I am posting it here.

This is an issue on all ARMs up to ARMv5, possibly ARMv6, and likely 
other CPU architectures that don't have transparent alignment fixup in 
hardware (Itanium, SPARC, probably others).

Apart from being dangerous, using unaligned arrays also affects 
performance because it leads to data needlessly straddling cache lines 
in the CPU. But that doesn't really matter in this case.

Many thanks.

Gordan
