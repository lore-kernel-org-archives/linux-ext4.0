From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Wed, 16 Jul 2008 12:10:31 +0200
Message-ID: <87r69u9m20.fsf@frosties.localdomain>
References: <87bq10w8gv.fsf@frosties.localdomain>
	<20080715132734.68c64000@ichigo>
	<20080715195116.GL6239@webber.adilger.int>
	<20080715162003.061c745a@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:42151 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbYGPKKe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 06:10:34 -0400
In-Reply-To: <20080715162003.061c745a@ichigo> (Jose R. Santos's message of
	"Tue, 15 Jul 2008 16:20:03 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Jose R. Santos" <jrs@us.ibm.com> writes:

> block boundary.  Dont have large disk to test on so Im playing with
> device mapper to see how I can fake one.  Our lab network is making
> thing difficult though.

Download

http://www.bullopensource.org/ext4/files/sparse_create

and for 32TiB use

dd if=/dev/zero of=/somewhere/SPACE bs=1 count=1 seek=100000000000
losetup /dev/loop0 /somewhere/SPACE
./sparse_create ext4dev /dev/loop0 68719476736

If you have a real block device to spare use that directly.

MfG
        Goswin
