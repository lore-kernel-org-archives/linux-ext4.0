From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Feature request: e2fsck -z
Date: Tue, 09 Aug 2011 12:52:20 -0500
Message-ID: <4E4173D4.9010104@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:40756 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450Ab1HIRwZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Aug 2011 13:52:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is something I've wanted to see for a very long time, and it
finally occurred to me that perhaps I should say something about it!

It would be a very nice thing to have a flag to e2fsck, presumably -z,
to zero out any unused data blocks, inodes and so on.  The goal is to
minimize the amount of space required after compressing a virtual disk
image or similar, and to make sure any non-data isn't lying around.

	-hpa
