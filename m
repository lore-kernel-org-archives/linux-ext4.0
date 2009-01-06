From: "Rohit Sharma" <imreckless@gmail.com>
Subject: Copying Data Blocks
Date: Tue, 6 Jan 2009 16:06:59 +0530
Message-ID: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:24177 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZAFKhB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 05:37:01 -0500
Received: by rv-out-0506.google.com with SMTP id k40so7289647rvb.1
        for <linux-ext4@vger.kernel.org>; Tue, 06 Jan 2009 02:37:00 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I want to read data blocks from one inode
and copy it to other inode.

I mean to copy data from data blocks associated with one inode
to the data blocks associated with other inode.

Is that possible in kernel space.?
