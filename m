From: Karl Beldan <karl.beldan@gmail.com>
Subject: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory traversal
Date: Wed, 24 Jun 2009 19:16:59 +0200
Message-ID: <4A425F8B.2000907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, bdonlan@gmail.com,
	linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:44822 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbZFXRRB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jun 2009 13:17:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

e6f009b for ext4,
de18f3b for ext3.

It seems that ext2 didn't get it.

