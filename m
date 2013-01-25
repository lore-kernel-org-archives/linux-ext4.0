From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 6/9] fs/ext4/super.c:4039:1: warning: label
 'failed_mount8' defined but not used
Date: Thu, 24 Jan 2013 23:24:45 -0500
Message-ID: <20130125042445.GH28908@thunk.org>
References: <51020468.kToCHrt5WwL/Cp68%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45400 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab3AYEYr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 23:24:47 -0500
Content-Disposition: inline
In-Reply-To: <51020468.kToCHrt5WwL/Cp68%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2013 at 12:04:56PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> head:   a16d0247541d300a1a1027212725c86a16180a0a
> commit: 99d0e4f8d1d88b303219c50b3a2c1192eab6b3e2 [6/9] ext4: release sysfs kobject when failing to enable quotas on mount
> config: x86_64-randconfig-x988 (attached as .config)
> 
> All warnings:
> 
>    fs/ext4/super.c: In function 'ext4_fill_super':
> >> fs/ext4/super.c:4039:1: warning: label 'failed_mount8' defined but not used [-Wunused-label]

Sigh.... I'll add the following to make this go away.

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 96a3cc9..3ac3060 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4036,8 +4036,10 @@ cantfind_ext4:
 		ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
 	goto failed_mount;
 
+#ifdef CONFIG_QUOTA
 failed_mount8:
 	kobject_del(&sbi->s_kobj);
+#endif
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:

					- Ted
