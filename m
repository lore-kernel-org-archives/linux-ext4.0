From: sftf <sftf-misc@mail.ru>
Subject: Re: Performance testing results
Date: Thu, 28 Jun 2007 10:46:52 +0600
Message-ID: <1692756695.20070628104652@mail.ru>
Reply-To: sftf <sftf-misc@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: valerie.clement@bull.net, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx28.mail.ru ([194.67.23.67]:5830 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762536AbXF1Drl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2007 23:47:41 -0400
Received: from mx33.mail.ru (mx33.mail.ru [194.67.23.194])
	by mx28.mail.ru (mPOP.Fallback_MX) with ESMTP id E1185B3A51
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jun 2007 07:47:39 +0400 (MSD)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!
  IMHO this test is not 100% correct.
  ext3 | data=writeback
  ext4 | data=writeback,extents,delalloc
  xfs  | defaults is ordered !

 So you have compared ext's in writeback (which fastest mode) vs xfs in ordered.
