From: "Rohit Sharma" <imreckless@gmail.com>
Subject: vfsmount
Date: Mon, 22 Sep 2008 22:27:33 +0530
Message-ID: <2d08ef090809220957tc397ac5j6cdf110e7cd13f5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Kernelnewbies <kernelnewbies@nl.linux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:51342 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYIVQ5e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 12:57:34 -0400
Received: by yx-out-2324.google.com with SMTP id 8so243547yxm.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 Sep 2008 09:57:33 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am interested in getting the vfsmount structure of the mounted file
system from my module.
I used filp = get_empty_filp() (filp is file pointer)
function to create an empty file object (as this contains pointer to
vfsmount structure)
file object has a field f_vfsmnt which points to the vfsmount structure
i am storing this in my own my_vfsmnt structure of type vfsmount.
my_vfsmnt = filp->f_vfsmnt
but i am getting my_vfsmnt as NULL ??

is there any other way of getting the vfsmount structure ??
