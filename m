From: "George Spelvin" <linux@horizon.com>
Subject: Re: 64bit + resize2fs... this is Not Good.
Date: 14 Nov 2012 02:12:48 -0500
Message-ID: <20121114071248.27831.qmail@science.horizon.com>
References: <20121114054347.GA20380@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:34254 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751434Ab2KNHMt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Nov 2012 02:12:49 -0500
In-Reply-To: <20121114054347.GA20380@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> # mke2fs -F -t ext4 -O 64bit /mnt/foo.img

I can't find the mkfs command in my history logs, but
I'm pretty sure it was:

mke2fs -F -t ext4 -i 1048576 -O 64bit,metadata_csum,^huge_file -E stride=32,stripe_width=352,resize=17179869184 -L data /mnt/foo.img

... since some of those options affect layout.
