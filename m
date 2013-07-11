From: Subranshu Patel <spatel.ml@gmail.com>
Subject: Bad sectors in metadata area
Date: Thu, 11 Jul 2013 21:32:43 +0530
Message-ID: <CAEUQcehgmcsCStLG6XinU+9G6E7eWGko26A_QEwGvTrefuwjhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:62492 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab3GKQCo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jul 2013 12:02:44 -0400
Received: by mail-qa0-f51.google.com with SMTP id f11so4264955qae.3
        for <linux-ext4@vger.kernel.org>; Thu, 11 Jul 2013 09:02:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 I have a query related to the e2fsck (EXT4). Consider the case where
the sector corresponding to the filesystem metadata (may be inode
bitmap) got bad.

1. What will happen when fsck is run on the filesystem (since it is a
case of bad sectors, not corruption)?

2. Will fsck help in remapping of the bad sectors?
