From: Eric Sandeen <sandeen@redhat.com>
Subject: __set_bit for BH flags in ext4_ext_get_blocks?
Date: Mon, 09 Jun 2008 15:42:55 -0500
Message-ID: <484D95CF.9020801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@sun.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbYFIUm5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2008 16:42:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was wondering why ext4_ext_get_blocks calls things like:

__set_bit(BH_Unwritten, &bh_result->b_state);
__set_bit(BH_New, &bh_result->b_state);
__set_bit(BH_Mapped, &bh_result->b_state);

instead of set_buffer_unwritten, etc.

Is there any reason it's calling __set_bit instead of set_bit (via the
BUFFER_FNS macros)?

Thanks,
-Eric
