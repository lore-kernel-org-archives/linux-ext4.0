From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks root filesystem
Date: Sat, 20 Feb 2016 02:28:03 +0000
Message-ID: <bug-112631-13602-f2pCFB0vFw@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37153 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427384AbcBTC2H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 21:28:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A737420588
	for <linux-ext4@vger.kernel.org>; Sat, 20 Feb 2016 02:28:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E47D920584
	for <linux-ext4@vger.kernel.org>; Sat, 20 Feb 2016 02:28:03 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

Andreas Amann <andreas.amann@gmx.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |andreas.amann@gmx.de

--- Comment #3 from Andreas Amann <andreas.amann@gmx.de> ---
I have the same problem. Bisection leads to the following commit:

commit 0571ba52a19e18a1c20469454231eef681cb1310
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Dec 30 11:47:53 2015 +0800

    crypto: af_alg - Disallow bind/setkey/... after accept(2)

    [ Upstream commit c840ac6af3f8713a71b4d2363419145760bd6044 ]

    Each af_alg parent socket obtained by socket(2) corresponds to a
    tfm object once bind(2) has succeeded.  An accept(2) call on that
    parent socket creates a context which then uses the tfm object.

    Therefore as long as any child sockets created by accept(2) exist
    the parent socket must not be modified or freed.

    This patch guarantees this by using locks and a reference count
    on the parent socket.  Any attempt to modify the parent socket will
    fail with EBUSY.

    Cc: stable@vger.kernel.org
    Reported-by: Dmitry Vyukov <dvyukov@google.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
