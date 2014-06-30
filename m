From: "Burton, Ross" <ross.burton@intel.com>
Subject: Generated files in e2fsprogs git repo
Date: Mon, 30 Jun 2014 17:52:29 +0100
Message-ID: <CAJTo0LYeerPnHpaxAw36N7BiWH4PKUMAX=1j+Szc7J9zvB7jjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:55117 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaF3Qwu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jun 2014 12:52:50 -0400
Received: by mail-qc0-f175.google.com with SMTP id i8so7331531qcq.34
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jun 2014 09:52:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Would anyone object to a patch set to remove all generated files
(aclocal.m4, configure, intl/*, po/Makefile.in.in, etc) from the
e2fsprogs git repository?  They'll still exist in tarballs, but anyone
building from git would need to run autoreconf to regenerate them -
the plus side being that the shipped aclocal.m4 won't be forcing
archaic macros onto users.

Ross
