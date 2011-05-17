From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: xfstests: device busy when umount
Date: Tue, 17 May 2011 17:03:37 +0800
Message-ID: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Amir Goldstein <amir73il@gmail.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49761 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1EQJDh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 05:03:37 -0400
Received: by vxi39 with SMTP id 39so176499vxi.19
        for <linux-ext4@vger.kernel.org>; Tue, 17 May 2011 02:03:37 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I noticed that all tests which contain 'device busy' errors have
falloc operations.  Does the error have something to do with falloc?

-- 
Best Wishes
Yongqiang Yang
