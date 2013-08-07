From: Chris Puttick <cputtick@gmail.com>
Subject: Make check fails (Ubuntu 12.04)
Date: Wed, 7 Aug 2013 11:22:18 +0100
Message-ID: <CALh+aRhF1We_VrDywFLQEYx3SWTa=GLVgacnNR55jyFpfFoVWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52628 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab3HGKWU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Aug 2013 06:22:20 -0400
Received: by mail-wg0-f48.google.com with SMTP id f12so909060wgh.15
        for <linux-ext4@vger.kernel.org>; Wed, 07 Aug 2013 03:22:18 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

In an escalating process of attempting to recover a large backup
volume (historic archaeological data) I tried to compile the latest
release of e2fsprogs.

This fails on make check with:

f_extent_oobounds: failed

(i) can I still safely use the compiled tools and progress to make
install? If not can I fix something so that test will pass?

(ii) given the reason for trying to compile updated tools was to get
past the mke2fs -n /dev/xxx output error of "size of device too big to
be expressed", is it even worth me trying the updated tools?

My thanks in advance for any insights.

Regards

Chris

-- 
@putt1ck
putt1ck.blogspot.com
http://twoten.is
skype: putt1ck

Opinions in this email are my own and may not reflect that of my
clients, past employers, associates, friends, family, pets etc..

Documents attached to this email may be in ISO 26300 format:
http://iso26300.info
