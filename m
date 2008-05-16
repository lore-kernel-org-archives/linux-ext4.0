From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Fri, 16 May 2008 14:02:46 -0500
Message-ID: <482DDA56.6000301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jamie Lokier <jamie@shareable.org>
To: ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488AbYEPTD2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2008 15:03:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry, that last send was totally stuffed up w.r.t. mail headers.

So for the benefit of proper cc:'s here it comes again...

A collection of patches to make ext3 & 4 use barriers by
default, and to call blkdev_issue_flush on fsync if they
are enabled.

