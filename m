From: "Duane Griffin" <duaneg@dghda.com>
Subject: Correct EXT3_TOPDIR_FL behaviour
Date: Tue, 3 Jun 2008 01:27:10 +0100
Message-ID: <e9e943910806021727h111b0e57qeea0032d164e0ffb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.239]:37909 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYFCA1M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 20:27:12 -0400
Received: by wx-out-0506.google.com with SMTP id h29so855770wxd.4
        for <linux-ext4@vger.kernel.org>; Mon, 02 Jun 2008 17:27:11 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

I'm looking at http://bugzilla.kernel.org/show_bug.cgi?id=9866, where
the reporter is claiming that EXT3_TOPDIR_FL (chattr +T) is behaving
incorrectly by being inherited from the parent. As mentioned in the
bug, it also only seems to only make sense for directories but
ext{2,3,4} is happy to set it on anything. It seems to me that the
reporter is correct and the behaviour should be changed to prevent the
flag being inherited and to limit it to directories only. If there is
no disagreement I'll follow-up with patches accordingly.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
