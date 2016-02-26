From: Jakob Lagerstedt <jakob.lagerstedt@slu.se>
Subject: resize2fs unresponsive
Date: Fri, 26 Feb 2016 14:33:38 +0100
Message-ID: <1531dc8e596.f715a7bd144008.4814276246115556854@slu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:25498 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbcBZNdj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Feb 2016 08:33:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear developers,

We started a resize2fs (version 1.42.9) on Ubuntu 14.04 against a unmounted raid. 

It has taken a long time and not much seems to be happening. We have not found any answers to these questions in the documentation and conflicting answers from forums.

What are the risks asociated with killing the process?

Can the resize be restarted if we kill it?

Best regards
Swedish University of Agricultural Sciences
Phone +46-18-673177

