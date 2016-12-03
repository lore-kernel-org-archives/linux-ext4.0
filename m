From: Ponomarenko Andrey <andrewponomarenko@yandex.ru>
Subject: ABI tracker for e2fsprogs
Date: Sat, 03 Dec 2016 22:18:25 +0300
Message-ID: <2900051480792705@web22j.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward15j.cmail.yandex.net ([5.255.227.179]:59842 "EHLO
        forward15j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751260AbcLCTZP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Dec 2016 14:25:15 -0500
Received: from mxback6j.mail.yandex.net (mxback6j.mail.yandex.net [5.45.198.20])
        by forward15j.cmail.yandex.net (Yandex) with ESMTP id 7AC84218DF
        for <linux-ext4@vger.kernel.org>; Sat,  3 Dec 2016 22:18:25 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

The latest releases of the e2fsprogs base libraries are now checked for backward binary compatibility here: https://abi-laboratory.pro/tracker/timeline/e2fsprogs/

The tracker is based on the open-source tools:

https://github.com/lvc/abi-tracker
https://github.com/lvc/abi-compliance-checker

Hope the report will be helpful for users and maintainers of the library.

Thank you.
