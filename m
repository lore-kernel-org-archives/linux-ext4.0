From: Gui Xiaohua <guixh@cn.fujitsu.com>
Subject: [BUG]:resize2fs /dev/sda6 -M
Date: Wed, 24 Dec 2008 10:12:18 +0800
Message-ID: <49519A82.7090208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56533 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYLXCNu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Dec 2008 21:13:50 -0500
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id 6590917013C
	for <linux-ext4@vger.kernel.org>; Wed, 24 Dec 2008 10:22:00 +0800 (CST)
Received: from fnst.cn.fujitsu.com (localhost.localdomain [127.0.0.1])
	by tang.cn.fujitsu.com (8.13.1/8.13.1) with ESMTP id mBO2Lxvq019037
	for <linux-ext4@vger.kernel.org>; Wed, 24 Dec 2008 10:22:00 +0800
Received: from [10.167.141.161] (unknown [10.167.141.161])
	by fnst.cn.fujitsu.com (Postfix) with ESMTPA id DF0ECD439F
	for <linux-ext4@vger.kernel.org>; Wed, 24 Dec 2008 10:19:53 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While resizing a partition, if its filesystem is ext4dev,
it will be fail.

Steps to reproduce:

#mkfs.ext4dev /dev/sda6
#resize2fs /dev/sda6 -M

resize2fs: No space left on device while trying to resize /dev/sda6
