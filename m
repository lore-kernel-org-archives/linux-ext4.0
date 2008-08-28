From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Online resize with flex bg
Date: Thu, 28 Aug 2008 16:38:00 +0200
Message-ID: <1219934280.3591.121.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57696 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYH1Mg3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 08:36:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id DB04C19D9F7
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 14:36:20 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 19764-02 for <linux-ext4@vger.kernel.org>;
 Thu, 28 Aug 2008 14:36:17 +0200 (CEST)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id EA1A619D9F1
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 14:35:51 +0200 (CEST)
Received: from [129.183.101.220] (dhcp129183101220.frec.bull.fr [129.183.101.220])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id 6AABB2728D
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 14:35:49 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am a bit confused on how to fix the online resize on filesystems using
flex bg.

First, this is roughly how resize currently works (correct me if I am
wrong):

without flexbg :
	resize2fs extends the last group until its full size with an ioctl
called GROUP_EXTEND. Then it "prepares" a new group. That is to say, it
computes which blocks will contains the meta-datas for the new group,
then it issue a GROUP_ADD ioctl with those block numbers.
	This works both for online and offline resize because new groups
meta-datas are created outside the working filesystem.

with flexbg :
	It works the same way but this time, meta-datas blocks for new groups
are created inside the working filesystem (in a group containing
meta-datas for the whole flex group). resize2fs scans from the end of
the last flex_group meta-datas until it finds enough space to put the
new meta-datas. This is not a problem when resizing offline, but when
online, the blocks found for the meta-datas may be allocated by someone
else before the GROUP_ADD ioctl occurs.

I am not sure how to handle this. I guess that resize2fs should be able
to find and allocate the meta-datas blocks without being disturbed by
other process. But it could mean a long time blocking all processes
accessing the filesystem while it searchs for free blocks. That said,
resizing is not done very often so it could be acceptable. Moreover I
guess that using this way of doing things means leaving the kernel side
compute the meta-datas blocks instead of let the userland resize2fs
manage it.
Another approach I think of could be to deliberately write new groups'
meta-datas outside the working filesystems (just like non flex_bg
groups). But this will break the "grouped meta-datas" logic of flex_bg.
We could limit this breakage to the last flex_group of the resized fs if
we add some sort of FLEXGROUP_ADD ioctl which allow to add whole clean
flex_groups to the filesystem.

Any comments/suggestions are welcome.

Fred



