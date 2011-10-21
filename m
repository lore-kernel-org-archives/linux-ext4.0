From: Andrew Lutomirski <andy@luto.us>
Subject: How do I clear the append-only flag on symlinks?
Date: Fri, 21 Oct 2011 11:07:51 -0700
Message-ID: <CAObL_7FLTio3+X3iQ3sdHw156OvmjT92_AD0vKTSagNTkaF9fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60826 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab1JUSIM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Oct 2011 14:08:12 -0400
Received: by gyb13 with SMTP id 13so4097303gyb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Oct 2011 11:08:11 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

By means that are best not admitted to, I managed to mark a large
chunk of my filesystem append-only, including symlinks.  I cleared the
flag from all the normal files and directories, but chattr and lsattr
don't want to operate on symlinks.  They say things like:

$ sudo lsattr /boot/vmlinuz
lsattr: Operation not supported While reading flags on /boot/vmlinuz

and I can't delete them, because

$ sudo rm /boot/vmlinuz
rm: cannot remove `/boot/vmlinuz': Operation not permitted

Any ideas on how to clear the append-only flags?  debug2fs is a little
scary, and hacking e2fsprogs to allow operation on symlinks seems to
affect symlink targets and not the symlinks themselves.

--Andy
