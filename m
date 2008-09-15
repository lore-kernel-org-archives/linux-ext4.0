From: "Rohit Sharma" <imreckless@gmail.com>
Subject: reading superblock
Date: Mon, 15 Sep 2008 22:11:02 +0530
Message-ID: <2d08ef090809150941j3dbed8fah700aa5c9e886366@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Kernelnewbies <kernelnewbies@nl.linux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:18835 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbYIOQlD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2008 12:41:03 -0400
Received: by yw-out-2324.google.com with SMTP id 9so662960ywe.1
        for <linux-ext4@vger.kernel.org>; Mon, 15 Sep 2008 09:41:02 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I want to read ext2 superblock and display the structure.

which function do i need to call for that.
is it ext2_get_sb() or ext2_fill_super() or both ??

this is the function prototype:
static int ext2_fill_super(struct super_block *sb, void *data, int silent)

what are the parameters data and silent used for.
