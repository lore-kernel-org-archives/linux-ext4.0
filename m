From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Checking of NULL with __GFP_NOFAIL in kzalloc()
Date: Sun, 1 Mar 2009 11:35:32 +0530
Message-ID: <ea11fea30902282205y14062e72v37780481e93802a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:21630 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZCAGFg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Mar 2009 01:05:36 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2475359tib.23
        for <linux-ext4@vger.kernel.org>; Sat, 28 Feb 2009 22:05:33 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

While going through jbd code, I was wondering why do we need to check
new_transaction for NULL, if we are passing __GFP_NOFAIL ?
Last code change around this code was when Ted converted kmalloc to
kzalloc, but since he also didn't remove it I am guessing there would
be some good reason for it. Can someone enlighten me ?

start_this_handle() {
..........
	..........
	new_transaction = kzalloc(sizeof(*new_transaction),
			GFP_NOFS|__GFP_NOFAIL);
        if (!new_transaction) {
        	ret = -ENOMEM;
        	goto out;
        }
	..........
}
		

Thanks -
Manish
