From: Spelic <spelic@shiftmail.org>
Subject: On the 16TiB max file size limit (not filesystem limit)
Date: Sun, 18 Aug 2013 23:00:29 +0200
Message-ID: <521135ED.6010101@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:3280 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3HRVWR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Aug 2013 17:22:17 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id 15D8031329
	for <linux-ext4@vger.kernel.org>; Sun, 18 Aug 2013 17:02:22 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear ext4 developers
are there any plans to overcome the 16TiB maximum file size limit for ext4?

Now that resize works across 16TiB boundary, many people could be 
interested in using ext4 as a slower but safer alternative to a 
distributed filesystem for large storages. However 16TiB filesize limit 
might be a problem if one wants to do big virtualization or anyway 
somehow nesting storage systems one into the other. Is the limit hard to 
fix?

Thank you
S.

