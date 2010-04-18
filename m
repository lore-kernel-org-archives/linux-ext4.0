From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Introducing Next3 - built-in snapshots support for Ext3
Date: Sun, 18 Apr 2010 18:41:21 +0300
Message-ID: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:52000 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0DRPlZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Apr 2010 11:41:25 -0400
Received: by bwz25 with SMTP id 25so4611822bwz.28
        for <linux-ext4@vger.kernel.org>; Sun, 18 Apr 2010 08:41:21 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

For over a year, Next3 has been developed in-house by CTERA networks,
as part of its NAS appliances.
Now that the appliances are out in the market, Next3 project can
finally be shared with the world.

Main Next3 features:
- Backward and forward compatible with Ext3
- Incremental, volume level, read-only snapshots
- Snapshots use available file system disk space
- Snapshot deletion frees up disk space
- Retains Ext3 stability including journaling and fsck
- Minimal performance overhead (in average usage scenarios)
- No upper limit on number or size of snapshots

Please visit Next3 wiki page:
http://sourceforge.net/apps/mediawiki/next3/

Next3 project is looking for code reviewers, beta testers and public attention.

Would love to read your comments on Next3-users mailing list:
https://lists.sourceforge.net/lists/listinfo/next3-users

Amir.
