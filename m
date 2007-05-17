From: sftf <sftf-misc@mail.ru>
Subject: Checksuming metadata+data
Date: Thu, 17 May 2007 10:12:37 +0600
Message-ID: <488612090.20070517101237@mail.ru>
Reply-To: sftf <sftf-misc@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx28.mail.ru ([194.67.23.67]:33233 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758501AbXEQDPq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 May 2007 23:15:46 -0400
Received: from mx33.mail.ru (mx33.mail.ru [194.67.23.194])
	by mx28.mail.ru (mPOP.Fallback_MX) with ESMTP id B58FB704A54
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2007 07:13:01 +0400 (MSD)
Received: from [195.162.52.178] (port=56349 helo=[192.168.2.1])
	by mx33.mail.ru with asmtp
	id 1HoWPv-000Djh-00
	for linux-ext4@vger.kernel.org; Thu, 17 May 2007 07:12:39 +0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Why to not implement two modes (via create/mount options):
1. Checksuming metadata only
2. Checksuming metadata+data (i.e. checksuming ALL)
