Return-Path: <SRS0=tX6L=ML=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wm1-f44.google.com ([209.85.128.44]:38077 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbeI2UHk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Sep 2018 16:07:40 -0400
Received: by mail-wm1-f44.google.com with SMTP id 193-v6so3214697wme.3
        for <linux-ext4@vger.kernel.org>; Sat, 29 Sep 2018 06:39:09 -0700 (PDT)
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: uninit_bg removed from mke2fs.conf
Message-ID: <ac3c94bd-adf7-eb8a-f776-e6f3a31f9df9@gmail.com>
Date: Sat, 29 Sep 2018 15:39:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,


It was removed from misc/mke2fs.conf.in in d0b9e0a6aa7d6805338a43b4e372623352d8df09

Was it intentional?


Thanks.
