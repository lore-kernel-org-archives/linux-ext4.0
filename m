From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/6] xfstests-bld: Fixes and improvements v1
Date: Fri, 19 Aug 2016 00:54:05 +0400
Message-ID: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:22349 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754574AbcHSBKc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Aug 2016 21:10:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Please review and pull my patch-queue for xfstests-bld
# Fix build (currently xfstests-bld is broken)
xfstests-bld: build update xfstests repo
fix build typos

# Minor improvements
kvm-xfstests: update command line help
xfstest-bld: use parallel gzip if possible
kvm-xfstests: add initrd support

# Dockerize xfstests-bld build enviroment
# github has integration with hub.docker so each commit update
# trigger auto build so we have CI for free.
build: Add dockerfile


https://github.com/dmonakhov/xfstests-bld to_pull-v1
