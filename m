From: Akshay Nehe <akshaynehe785@gmail.com>
Subject: Required help for understanding ext4 block allocation
Date: Thu, 15 Mar 2012 18:48:56 +0530
Message-ID: <CA+tw96DSaJH50o1F4sW9XMnmPD8dFO9VCyvK4tbsLFqfgK9CWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54839 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761920Ab2CONS6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Mar 2012 09:18:58 -0400
Received: by lbbgm6 with SMTP id gm6so1404787lbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Mar 2012 06:18:56 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I am trying to understand the block allocation in ext4 file sytem, I
have gone through all basic theory and browsing code to do it.

I am writing a module in which i got ext4 on disk inode, now according
to theory first 12 bytes of i_block points to ext4_extent_header, so
can i use this array of i_block[EXT4_N_BLOCKS].

Means how to fill objects of  struct ext4_extent_header (using first
12 byte of i_block) and  struct ext4_extent (using reminder bytes of
i_block).


-- 
Regards,
Akshay Nehe.
