From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH] e2fsck: Improve consistency check of uninit block	group
 and some cleanup
Date: Mon, 06 Jul 2009 17:12:55 +0900
Message-ID: <4A51B207.8050901@sx.jp.nec.com>
References: <4A4C450C.6060808@sx.jp.nec.com> <20090703151724.GE15038@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58056 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbZGFIRl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jul 2009 04:17:41 -0400
In-Reply-To: <20090703151724.GE15038@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
Thanks for your helpful advice.

> 1) Please send clean-up patches separately.  The "remove unnecessary
> continue statement" I could easily separate out, but it wasn't
> immediately obvious what "fix loop counter properly" was all about.
I see.  I'll send clean-up patches now.

> Do you think you could make these changes and resend the patch?
OK, I'll try it.

Regards,
Kazuya Mio
