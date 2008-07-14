From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: ext4 64bit (disk >16TB) question
Date: Mon, 14 Jul 2008 21:50:56 +0200
Message-ID: <87bq10w8gv.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:32829 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbYGNTu7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 15:50:59 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate02.web.de (Postfix) with ESMTP id F2276E5C06CC
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 21:50:57 +0200 (CEST)
Received: from [85.216.73.182] (helo=frosties.localdomain)
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226)
	id 1KIU4X-0006gm-00
	for linux-ext4@vger.kernel.org; Mon, 14 Jul 2008 21:50:57 +0200
Received: from mrvn by frosties.localdomain with local (Exim 4.69)
	(envelope-from <goswin-v-b@web.de>)
	id 1KIU4W-000644-UM
	for linux-ext4@vger.kernel.org; Mon, 14 Jul 2008 21:50:56 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

we are using lustre on a cluster of servers and raid boxes. Currently
lustre is based on the ext3 code and has a limit of 8TiB for each
filesystem. For us that results on having to split a servers storage
into up to 4 chunks and run one fs on each which I would rather avoid.
The solution for this would be to rebase the lustre patches to use
ext4 instead, which should also reduce the patch set considerably.
Lustre already patches a lot of ext4 features into the ext3 base.


But before I start rebasing lustre I though I would first test out
plain ext4 so I know any bugs I find will be from my rebasing and not
already existing in ext4 itself. And there I run into a big problem:
Current e2fsprogs (1.41) seem to be totaly unable to handle the ext4 64BIT
feature, i.e. filesystems larger than 16TiB. The mkfs.ext4 always
stops saying the disk exceeds the 32bit block count. And looking at
the code I see a lot of blk_t (instead of blk64_t) and unsigned long
(instead of unsigned long long [or even better blk64_t]) usage.

I found ext4 64bit patches for e2fsprogs 1.39 that fix at least
mkfs. Does anyone know if there is an updated patch set for 1.41
anywhere? And when will that be added to e2fsprogs upstream?

MfG
        Goswin

