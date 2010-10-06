From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [BUG] ext3/ext4 migration problem with dir_nlink feature flag
Date: Wed, 06 Oct 2010 11:44:53 +0900
Message-ID: <4CABE2A5.3000103@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:36039 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0JFCpX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Oct 2010 22:45:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I found a bug which returns EIO by file access on ext3 (was ext4) whose
dir_nlink feature flag is removed and has more than 64000 directories.
Kernel: 2.6.36-rc6, e2fsprogs: 1.41.2
Steps to reproduce are as follows:

1. Create ext4 which does not have extent and flex_bg feature flags
    (Because this fs will be mounted as ext3 in step 3),
    then create more than 64000 directories.
    Therefore dir_nlink feature flag is set and link count becomes 1.
2. Remove dir_nlink feature flag with tune2fs command
    (e.g. tune2fs -O ^dir_nlink /dev/sdx).
3. Mount ext4 as ext3, then remove subdir (Link: 1->0).
    We cannot access parent directory, because link count goes wrong.

We should disallow tune2fs command to remove dir_nlink feature flag.

Regards,
Akira Fujita

