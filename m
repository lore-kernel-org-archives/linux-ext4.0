From: Shiquan Yang <shiquany@gmail.com>
Subject: Can anyone kindly tell me disadvantage of data=writeback if I save
 file length myself
Date: Thu, 12 Feb 2015 10:14:15 +0800
Message-ID: <CAM3LPOYJXNtCqtbTyfwDAZT25MsmNU7Hrxv=tk-ybdwuVBVJzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49264 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbbBLCOR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Feb 2015 21:14:17 -0500
Received: by mail-wi0-f173.google.com with SMTP id bs8so886236wib.0
        for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2015 18:14:16 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

I have a case,
1. SATA disk + buffered write
2. one node with N disks, and the first disk is meta disk, and the left 1.N
is data disk
3. I will write data in disk 1-N, and record the chunk file length in meta
disk (disk0).

in such case, can I safely set data=writeback without any possible problem,
maybe include data corrupt, slow recovery when node restart, ... ?

thanks very much.
-- 
Raymond
Attitude is Everything.
