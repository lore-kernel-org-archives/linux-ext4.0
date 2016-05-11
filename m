From: "Craske, Mark" <Mark_Craske@mentor.com>
Subject: ext4: what are possible causes of "zero length extent" ?
Date: Wed, 11 May 2016 10:22:28 +0000
Message-ID: <FE37120F1498264DADC12DBE984882149659843D@EU-MBX-01.mgc.mentorg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:35902 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbcEKKWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 May 2016 06:22:30 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello ext4 maintainers,

This is somewhat of a follow-on from the "ext4 filesystem bad extent error review"
thread from 2014.

Embedded system with main SoC Freescale i.MX6(ARM cortex A9), dual CPU, running
kernel 3.8.13.28, storage device is eMMC.
This still suffers from "zero length extent" ext4 file system corruptions.

I looked for upstream patches, but did not find any that explicitly fix "zero length extent"
problems apart from "2f97486 ext4: check for zero length extent explicitly".
That patch prevents the kernel panics but makes the affected file unreadable and
unremovable, which can be fixed by running fsck.

What are possible causes of "zero length extent", and are there upstream patches that
actually deal with some of those?

Regards,
Mark Craske
Mentor Graphics (UK) Ltd.
