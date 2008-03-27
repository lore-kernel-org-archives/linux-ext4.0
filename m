From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: Entries in feature_list[]
Date: Thu, 27 Mar 2008 13:10:34 +0530
Message-ID: <1206603634.3379.4.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:35570 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbYC0Haz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Mar 2008 03:30:55 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m2R7VCfs009743
	for <linux-ext4@vger.kernel.org>; Thu, 27 Mar 2008 07:31:15 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0JYD00001OHM9S00@mail-apac.sun.com>
 (original mail from Girish.Shilamkar@Sun.COM) for linux-ext4@vger.kernel.org;
 Thu, 27 Mar 2008 15:30:31 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
In e2fsprogs/lib/e2p/feature.c 
struct feature feature_list[] contains:
        ... 
	{       E2P_FEATURE_INCOMPAT, EXT3_FEATURE_INCOMPAT_EXTENTS,
                        "extents" },
        {       E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_META_BG,
                        "meta_bg" }
        {       E2P_FEATURE_INCOMPAT, EXT3_FEATURE_INCOMPAT_EXTENTS,
                        "extent" },
        ...

Is the { E2P_*, EXT3_*, "extent"} entry correct one, if yes, what is the purpose behind having two
{E2P_FEATURE_INCOMPAT, EXT3_FEATURE_INCOMPAT_EXTENTS, *} entries, unless we want "extent" to be 
correct feature ?


Thanks,
Girish

