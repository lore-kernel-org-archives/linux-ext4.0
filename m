From: Ric Wheeler <ricwheeler@gmail.com>
Subject: transaction batching performance & multi-threaded synchronous writers
Date: Mon, 14 Jul 2008 12:15:23 -0400
Message-ID: <487B7B9B.3020001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:52235 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYGNQP0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 12:15:26 -0400
Received: by wx-out-0506.google.com with SMTP id h29so2358296wxd.4
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 09:15:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Here is a pointer to the older patch & some results:

http://www.spinics.net/lists/linux-fsdevel/msg13121.html

I will retry this on some updated kernels, but would not expect to see a 
difference since the code has not been changed ;-)

ric

