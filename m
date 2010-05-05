From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: status of MMP?
Date: Wed, 5 May 2010 23:30:49 +0200
Message-ID: <201005052330.49491.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bschubert@ddn.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39264 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758630Ab0EEVbV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 17:31:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,

what is the status of MMP for ext4? While MMP is not particularly useful for 
desktop systems, it is a very useful feature for HA servers. While HA software 
such a pacemaker is supposed to prevent starting resources (e.g. mounts) 
several times, there can come situations where this does not work perfectly.

Lustres ldiskfs already has MMP support for several years and I would like to 
know what is the blocker for ext4? Updating the MMP patches for ext4-git 
should be fairly simple.


Thanks,
Bernd 


-- 
Bernd Schubert
DataDirect Networks
