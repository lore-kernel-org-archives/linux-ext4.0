From: jon ernst <jonernst07@gmail.com>
Subject: e2fsprog pu branch build fail due to missing QUOTA_LIB
Date: Sun, 16 Feb 2014 04:54:44 +0000
Message-ID: <CAGW2f1Fyvn4h1jX7jHUz3T6ggRbC=gRuGo7HeEYNvoF_G0Coug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58441 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaBPEyp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Feb 2014 23:54:45 -0500
Received: by mail-qa0-f46.google.com with SMTP id k15so6864093qaq.19
        for <linux-ext4@vger.kernel.org>; Sat, 15 Feb 2014 20:54:44 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

e2fsprog pu branch build fail due to missing "QUOTA_LIB_SUBDIR=
lib/quota" in Makefile.in file.

I checked  this has been fixed in other branches, such as debian branch.
But in this branch, it is still missing.

Thank you,
Best,
jon
