From: "Yan Zheng" <yanzheng@21cn.com>
Subject: How to insure ext4_alloc_blocks always returns blocks below 0xffffffff when using indirect index.
Date: Fri, 3 Aug 2007 10:22:31 +0800
Message-ID: <3d0408630708021922h7f382cdfk1d67f5f25029c2d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:61838 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXHCCWd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2007 22:22:33 -0400
Received: by fk-out-0910.google.com with SMTP id z23so573191fkz
        for <linux-ext4@vger.kernel.org>; Thu, 02 Aug 2007 19:22:31 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all.

Druing reading the source codes of indirect index,  there is a doubt
in my mind. When using indirect index, physical block number must not
exceed 0xffffffff, but I cann' t find any clue  about how
ext4_alloc_blocks insure that.  Codes that check 64bit_feature is only
in ext4_fill_super and they do nothing affects block allocation
algorithm.  Maybe ext4_alloc_blocks should  check whether inode has
EXT4_EXTENTS_FL flags and only search block groups that have blocks
below 0xffffffff when not.

The source codes I read is 2.6.22.

Thanks in advance.
YZ
