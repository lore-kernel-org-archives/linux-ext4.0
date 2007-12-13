From: Andrew Morton <akpm@linux-foundation.org>
Subject: ext4 still broken on multiple architectures
Date: Wed, 12 Dec 2007 19:55:47 -0800
Message-ID: <20071212195547.3e4d50b8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbXLMDzt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2007 22:55:49 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id lBD3tlHq026074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2007 19:55:48 -0800
Received: from box (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id lBD3tlLd012282
	for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2007 19:55:47 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fs/ext4/mballoc.c: In function 'ext4_mb_generate_buddy':
fs/ext4/mballoc.c:836: error: implicit declaration of function 'ext2_find_next_bit'

Can someone please get this fixed?
