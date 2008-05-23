From: Andrew Morton <akpm@linux-foundation.org>
Subject: ext4 still busted on ext4
Date: Thu, 22 May 2008 23:54:41 -0700
Message-ID: <20080522235441.1d1a495b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178AbYEWGyy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 May 2008 02:54:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

/usr/src/devel/fs/ext4/mballoc.c: In function 'mb_find_next_bit':
/usr/src/devel/fs/ext4/mballoc.c:399: error: implicit declaration of function 'generic_find_next_le_bit'

This has been happening for months.
