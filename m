From: Amir Goldstein <amir73il@gmail.com>
Subject: recursive mtime patches
Date: Mon, 11 Apr 2011 16:37:57 +0300
Message-ID: <BANLkTim6NYYnr+m4mqawSD4-Mbbzj699hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49866 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1DKNh6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Apr 2011 09:37:58 -0400
Received: by qyk7 with SMTP id 7so1253111qyk.19
        for <linux-ext4@vger.kernel.org>; Mon, 11 Apr 2011 06:37:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

Do you have an uptodate version of your recursive mtime patches?
The only version I can find online is the original series from 2007.

I am interested in the patches for indexdb-like application,
so persistence after crash is also important for my use case.
Your patches would require the application to perform a full
directory scan after crash, right?

Thanks,
Amir.
