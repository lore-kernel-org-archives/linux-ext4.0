From: jon ernst <jonernst07@gmail.com>
Subject: difference between xip and o_direct.
Date: Thu, 5 Dec 2013 17:47:52 -0500
Message-ID: <CAGW2f1EiXM5Rp=9uUjwNEs0Ws0VR0kzpPYi6=xfWc7FV=bkfDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:40012 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3LEWrx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Dec 2013 17:47:53 -0500
Received: by mail-qc0-f176.google.com with SMTP id i8so5539514qcq.35
        for <linux-ext4@vger.kernel.org>; Thu, 05 Dec 2013 14:47:53 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I am trying to understand difference between xip and o_direct.

For XIP, document xip.txt says
"instead of keeping
data in the page cache, the need to have a page cache copy is eliminated
completely. With execute-in-place, read&write type operations are performed
directly from/to the memory backed storage device."

For O_Direct,

" File I/O is done directly to/from user-
space buffers.  " from manual of open(2)

So, are those 2 trying to do the same thing ? The difference I can
tell is, XIP option can be used when mounting fs. O_Direct is used in
open system-call.
Can anybody kindly teach me what are other differences?

thank you!

Jon
