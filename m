From: Anders Lind <anderslindgaard@yahoo.com>
Subject: Tune2fs metadata_csum
Date: Sun, 16 Dec 2012 20:04:01 -0800 (PST)
Message-ID: <1355717041.99349.YahooMailNeo@web164606.mail.gq1.yahoo.com>
Reply-To: Anders Lind <anderslindgaard@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm9-vm4.bullet.mail.gq1.yahoo.com ([98.136.218.243]:24903 "EHLO
	nm9-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915Ab2LQEKK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Dec 2012 23:10:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi ext4 developers,


I tired to use tune2fs metadata_csum feature on my ext4 filesystem.
I got message like:
~$ sudo tune2fs -O metadata_csum /dev/sda5
tune2fs 1.42 (29-Nov-2011)
Setting filesystem feature 'metadata_csum' not supported.


Is this tool supposed been used on unmounted device or it could be mounted?


BTW. I googled this problem on internet. Seems no clear answer yet.

Thank you!
Best,

Anders

