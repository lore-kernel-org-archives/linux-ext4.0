From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: one question about xfstests for ext4?
Date: Thu, 26 Jul 2012 10:27:28 +0800
Message-ID: <5010AB10.9050701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33402 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2GZC1j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jul 2012 22:27:39 -0400
Received: by pbbrp8 with SMTP id rp8so2407481pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2012 19:27:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear all,

I want to run xfstests on ext4. 
I have tried the official xfstests git tree, but in my test, I got many 
	"[not run] not suitable for this filesystem type: ext4".
-------------------------------------------------------------
001	 6s
002	 0s
003	 [not run] not suitable for this filesystem type: ext4
004	 [not run] not suitable for this filesystem type: ext4
005	 0s
006	 2s
007	 3s
008	 [not run] not suitable for this filesystem type: ext4
009	 [not run] not suitable for this filesystem type: ext4
010	 [not run] dbtest was not built for this platform
011	 2s
012	 [not run] not suitable for this filesystem type: ext4
......


Is this expected? Or do I need to make some config changes?
I wonder if there is any xfstests for ex4 specific git tree?

Regards,
