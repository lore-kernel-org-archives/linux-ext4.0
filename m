From: "Rohit Sharma" <imreckless@gmail.com>
Subject: Request queues and bio structures
Date: Thu, 11 Sep 2008 00:19:16 +0530
Message-ID: <2d08ef090809101149o3c8365b5x74455bb56a9e89b8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:31036 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYIJStS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2008 14:49:18 -0400
Received: by wx-out-0506.google.com with SMTP id h27so938773wxd.4
        for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2008 11:49:16 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was going through Block device Drivers.
few things are not clear.
How requests for reading blocks from device is processed?
what is the role of mapping layer? what are the entries in device mapper.?
How request queues and bio structures work?
