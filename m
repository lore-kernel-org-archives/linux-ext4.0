From: Thomas King <kingttx@tomslinux.homelinux.org>
Subject: Block size limited to Linux page size?
Date: Tue, 3 Jun 2008 12:00:40 -0500 (CDT)
Message-ID: <46221.143.166.255.40.1212512440.squirrel@tomslinux.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbYFCRAx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 13:00:53 -0400
Received: from tomslinux.homelinux.org ([24.28.24.180])
          by hrndva-omta02.mail.rr.com with ESMTP
          id <20080603170052.NOIO25858.hrndva-omta02.mail.rr.com@tomslinux.homelinux.org>
          for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 17:00:52 +0000
Received: from tomslinux.homelinux.org (localhost [127.0.0.1])
	by tomslinux.homelinux.org (8.13.7/8.13.7) with ESMTP id m53H0f5T027555
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 12:00:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To fill in one piece of information, I'm reading the maximum block size can be
limited by the Linux page size, 4K on x86. Is this true in ext4?

I know this is a basic question, so thanks for humoring me.
Tom King
