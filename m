From: Andi Kleen <ak@suse.de>
Subject: [PATCH] [0/7] Drop BKL in ext[234] ioctls
Date: Mon, 28 Jan 2008 11:16:09 +0100 (CET)
Message-ID: <200801281116.315497000@suse.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:33303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYA1KQK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 05:16:10 -0500
Received: from Relay1.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 7FEA4270B9
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2008 11:16:09 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Remove the BKL from the ext* ioctls.

This is a slightly updated version of the ext[2-4] patches that hit
linux-fsdevel earlier.

-Andi
