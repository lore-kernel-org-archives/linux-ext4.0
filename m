From: Jiaying Zhang <jiayingz@google.com>
Subject: [RFC PATCH 0/4] ext4: implement DIO read nolocking
Date: Tue, 15 Dec 2009 17:36:23 -0800
Message-ID: <5df78e1d0912151736xa1107afrdc5a343ee0f5e0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michael Rubin <mrubin@google.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:43473 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934381AbZLPBg3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2009 20:36:29 -0500
Received: from kpbe14.cbf.corp.google.com (kpbe14.cbf.corp.google.com [172.25.105.78])
	by smtp-out.google.com with ESMTP id nBG1aP19007531
	for <linux-ext4@vger.kernel.org>; Wed, 16 Dec 2009 01:36:26 GMT
Received: from pwi18 (pwi18.prod.google.com [10.241.219.18])
	by kpbe14.cbf.corp.google.com with ESMTP id nBG1a5Ki019119
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:36:25 -0800
Received: by pwi18 with SMTP id 18so933007pwi.32
        for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 17:36:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Several weeks ago, we proposed the idea of always allocating uninitialized
extent during ext4 DIO write and/or buffer write and convert the extent into
initialized after IO complete. This allows us to drop the i_mutex lock during
ext4 DIO read, which would help improve ext4 DIO read performance with
multiple threads or AIOs running on high-speed SSDs. FYI, here is the email
thread referred to: http://marc.info/?l=linux-ext4&m=125513220225086&w=2

Following this email are our RFC patches to implement the proposed idea.
We haven't tested these patches much so they are probably very buggy.

Any feedback would be greatly appreciated!

Regards,

Jiaying
