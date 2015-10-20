From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Tue, 20 Oct 2015 15:55:32 +0000
Message-ID: <bug-102731-13602-dQptu6u9S9@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56954 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbbJTPzi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2015 11:55:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4D68E2085A
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2015 15:55:34 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id AC4A520851
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2015 15:55:32 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #28 from John Hughes <john@calva.com> ---
I've just noticed that the system had pretty low memory -- only 1G.  I've upped
it to 2G.  Don't know whether that will make a difference.  I see some
allocation failures, mostly relating to apache and tcp.

Oct 17 05:26:10 olympic kernel: [53046.469494] apache2: page allocation
failure: order:1, mode:0x204020
Oct 17 05:26:10 olympic kernel: [53046.469812] apache2: page allocation
failure: order:1, mode:0x204020
Oct 17 05:26:10 olympic kernel: [53046.469985] apache2: page allocation
failure: order:1, mode:0x204020
Oct 17 05:26:10 olympic kernel: [53046.470154] apache2: page allocation
failure: order:1, mode:0x204020
Oct 19 22:43:46 olympic kernel: [288101.737120] apache2: page allocation
failure: order:1, mode:0x204020
Oct 19 22:43:46 olympic kernel: [288101.737833] kswapd0: page allocation
failure: order:1, mode:0x204020
Oct 20 06:12:46 olympic kernel: [315042.431636] apache2: page allocation
failure: order:1, mode:0x204020
Oct 20 06:12:46 olympic kernel: [315042.431952] apache2: page allocation
failure: order:1, mode:0x204020
Oct 20 06:12:46 olympic kernel: [315042.631774] swapper/0: page allocation
failure: order:1, mode:0x204020
Oct 20 06:12:46 olympic kernel: [315042.635743] swapper/0: page allocation
failure: order:1, mode:0x204020
Oct 20 07:03:32 olympic kernel: [318088.158197] apache2: page allocation
failure: order:1, mode:0x204020
Oct 20 07:03:32 olympic kernel: [318088.160930] apache2: page allocation
failure: order:1, mode:0x204020
Oct 20 07:03:32 olympic kernel: [318088.163835] apache2: page allocation
failure: order:1, mode:0x204020
Oct 20 10:44:54 olympic kernel: [331369.850853] apache2: page allocation
failure: order:1, mode:0x204020
Oct 20 10:44:54 olympic kernel: [331369.851186] apache2: page allocation
failure: order:1, mode:0x204020
Oct 20 10:44:54 olympic kernel: [331369.851357] apache2: page allocation
failure: order:1, mode:0x204020
Oct 20 10:54:04 olympic kernel: [331920.651891] apache2: page allocation
failure: order:1, mode:0x204020

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
