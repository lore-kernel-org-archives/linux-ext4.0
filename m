From: =?EUC-KR?B?yKu9xSBzaGluIGhvbmc=?= <hongshin@gmail.com>
Subject: a suggestion for ext2_release_file()
Date: Fri, 15 May 2009 12:16:43 +0900
Message-ID: <2014bcab0905142016k7626acd1m187afb71f9ecc440@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:12182 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZEODQn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 23:16:43 -0400
Received: by yw-out-2324.google.com with SMTP id 5so969748ywb.1
        for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 20:16:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi. I have a suggestion while I read ext2 code in recent Linux.

mark_files_ro() function in fs/super.c turns off FMODE_WRITE
of every file in a super block for the case of remounting.

However, an inode whose file's mode is FMODE_WRITE may hold
reservations. I think these reservations lost their chance to be discarded
since FMODE_WRITE is off.

So, I think ext2_release_file rather check
EXT2_I(inode)->i_block_alloc_info->rsv_window_node.

Could you check my suggestion is valid or not please?

Sincerely
Shin Hong
