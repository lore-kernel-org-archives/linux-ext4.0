From: Prashant Shah <pshah.me@gmail.com>
Subject: Max size of data in a bio
Date: Fri, 20 Sep 2013 15:27:25 +0530
Message-ID: <CAFd8dNswTyL=7VDRfZy2o0ALFJH+8iA5d4SaY4+Ap87u-JjE1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f194.google.com ([209.85.223.194]:47334 "EHLO
	mail-ie0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3ITJ5Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Sep 2013 05:57:25 -0400
Received: by mail-ie0-f194.google.com with SMTP id qd12so79095ieb.1
        for <linux-ext4@vger.kernel.org>; Fri, 20 Sep 2013 02:57:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

What is the maximum size of the data that can be read/written in a
single bio ? I could locate two possible locations where I can
calculate that :

1.
#define BIO_MAX_PAGES        256
#define BIO_MAX_SIZE        (BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
#define BIO_MAX_SECTORS        (BIO_MAX_SIZE >> 9)

Max = 1048576

2.
#define UIO_MAXIOV      1024

Max = 4194304

Is there any other way that the bio could have been created that is
reading/writing data in a larger size than any of the above ?

Regards.
