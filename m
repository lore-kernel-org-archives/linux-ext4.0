From: Gui Xiaohua <guixh@cn.fujitsu.com>
Subject: [BUG] e2fsprogs: resize2fs failed when "mkfs.ext4dev -O flex_bg"
Date: Mon, 05 Jan 2009 16:06:22 +0800
Message-ID: <4961BF7E.6050203@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZAEIIO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 03:08:14 -0500
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id EB1E0170080
	for <linux-ext4@vger.kernel.org>; Mon,  5 Jan 2009 16:25:43 +0800 (CST)
Received: from fnst.cn.fujitsu.com (localhost.localdomain [127.0.0.1])
	by tang.cn.fujitsu.com (8.13.1/8.13.1) with ESMTP id n058PhCH003882
	for <linux-ext4@vger.kernel.org>; Mon, 5 Jan 2009 16:25:43 +0800
Received: from [10.167.141.161] (unknown [10.167.141.161])
	by fnst.cn.fujitsu.com (Postfix) with ESMTPA id 0197ED43B4
	for <linux-ext4@vger.kernel.org>; Mon,  5 Jan 2009 16:15:40 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When mkfs.ext4dev with flex_bg option, resize2fs with -M option will fail.
While calculate how many blocks need to move, the result is wrong. Because 
some block groups have no meta_data if mkfs.ext4dev with flex_bg option, 
all meta_data are stored in the flex group.

Steps to reproduce:

# mkfs.ext4dev -O flex_bg /dev/sda6
# resize2fs /dev/sda6 -M

resize2fs: No space left on device while trying to resize /dev/sda6
