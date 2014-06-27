From: Ross Burton <ross.burton@intel.com>
Subject: [PATCH] misc: copy extended attributes in populate_fs
Date: Fri, 27 Jun 2014 22:02:16 +0100
Message-ID: <1403902937-2781-1-git-send-email-ross.burton@intel.com>
Cc: dvhart@linux.intel.com, tytso@mit.edu, darrick.wong@oracle.com,
	liezhi.yang@windriver.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:58755 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaF0VC2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2014 17:02:28 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so5771881wes.31
        for <linux-ext4@vger.kernel.org>; Fri, 27 Jun 2014 14:02:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When using mkefs with -d to create a file system image from a pre-constructed
root filesystem directory, any extended attributes set are not copied into the
filesystem.

This is a problem when the file system needs them, for example it uses SELinux.
Following is a patch to copy any extended attributes to the target file system
in populate_fs().

Regards,
Ross
