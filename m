From: Chris Puttick <cputtick@gmail.com>
Subject: Practical partition/volume size limitation
Date: Tue, 9 Feb 2010 18:32:12 +0000
Message-ID: <388f7e1a1002091032p633a7db4of269cccd4a8142bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f193.google.com ([209.85.210.193]:63132 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0BIScO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 13:32:14 -0500
Received: by yxe31 with SMTP id 31so7074730yxe.21
        for <linux-ext4@vger.kernel.org>; Tue, 09 Feb 2010 10:32:14 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all

Sorry to intrude and please feel free to redirect me to another more
appropriate list or alternative source (which I have been unable to
find). We're considering a large-scale filestore deployment (starting
with 32TB, single volume) and some team members have concerns about
the practical scalability of ext4 e.g. time to run fsck.

So some questions :)

Are there any examples of organisations running ext4 with large-scale
filestores? What sort of sizes? What issues, if any, have been
encountered? And if not ext4, what else (assuming a Linux preference)?

Thanks in advance.

Chris Puttick

-- 
My employers website: http://thehumanjourney.net - opinions in this
email are however very much my own and may not reflect that of my
current employer, past employers, associates, friends, family, pets etc..

Documents attached to this email may be in ISO 26300 format:
http://iso26300.info
