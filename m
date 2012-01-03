From: Sushil Mantri <sushilmantri@gmail.com>
Subject: A stackable filesystem to trace low level filesystem operations
Date: Tue, 3 Jan 2012 16:20:21 -0500
Message-ID: <CAFFtA8429YabMVLp-f15GXBknK+W2oMpqYkZT42zLFaSJ-RBVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44229 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2ACVUX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jan 2012 16:20:23 -0500
Received: by wibhm6 with SMTP id hm6so9446628wib.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jan 2012 13:20:22 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

Sorry but this isn't a ext4 specific question but a general filesystem question.

I am looking for a way to track filesystem level operation like
operation(read/write), filename, offset, size of read/write, pid of
the requesting process. The goal of my project is to collect such
traces and understand access usage of directories and more. I would
like to filter other operation like open,close, etc and requests to
procfs, etc. There was a stackable file system earlier called Tracefs.
It isn't supported anymore though. The original paper can be found
here: filesystems.org/docs/tracefs-fast04/tracefs.ps

Can you please suggest me what is the best option i have. I am
currently looking at SystemTap.

Thanks,
Sushil
