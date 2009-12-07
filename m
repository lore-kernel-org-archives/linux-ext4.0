From: root <jeremy.cochoy@gmail.com>
Subject: [PATCH] fix ext2 parse_options printk
Date: Mon,  7 Dec 2009 15:01:00 +0100
Message-ID: <1260194461-8937-1-git-send-email-jeremy.cochoy@gmail.com>
Cc: linux-ext4@vger.kernel.org, Manish Katiyar <mkatiyar@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Corentin Chary <corentin.chary@gmail.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:10148 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935088AbZLGNyR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 08:54:17 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello,

I added KERN_* prexif in some log message. I choose KERN_NOTICE for message who looks something the user might be warned, because it isn't really a warning but it's something he should know.
I chose KERN_INFO for 2 elements which are what the user asked to be.

Tell me if there is any problem with my choices (or i make any mistake while sending you this patch) or anything else :)

Best regars,
