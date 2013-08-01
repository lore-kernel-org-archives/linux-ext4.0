From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: File permissions in ext4
Date: Thu, 1 Aug 2013 14:02:05 +0200
Message-ID: <CACyNnZM5iCC+A_RPM90jr-UUNP5VVnm=+59w6ip0oABqNbFXvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57306 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3HAMCH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 08:02:07 -0400
Received: by mail-pd0-f174.google.com with SMTP id 10so1953401pdc.33
        for <linux-ext4@vger.kernel.org>; Thu, 01 Aug 2013 05:02:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I am attempting to read the file permissions from a file in EXT4, but
I'm not sure where it is stored? Any ideas?

I thought this would be the ACL, and I read both
ext4_inode.i_file_acl_lo and ext4_inode.l_i_file_acl_high and they are
both zero, despite the fact that the file has 644 permission set. Is
the ACL actually used for anything?

thanks in advance =)
-- 
Felipe Monteiro de Carvalho
