From: elanTea <elanTea@emailn.de>
Subject: Mount option "nouser_xattr" will be removed by 3.5
Date: Fri, 17 Nov 2017 16:55:22 +0100
Message-ID: <TGfF7VK3OWYxx6BtJw5zngrrIZF1T9cC@mail.emailn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.emailn.de ([46.182.20.28]:50127 "EHLO mail.emailn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759090AbdKQQKg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 17 Nov 2017 11:10:36 -0500
Received: from linux (p4FCE5E50.dip0.t-ipconnect.de [79.206.94.80])
        by mail.emailn.de (b1gMailServer) with ESMTP id 0FD58C6D
        for <linux-ext4@vger.kernel.org>; Fri, 17 Nov 2017 16:55:31 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi
please do not remove this option. I need a filesystem without the
posibility to hide information and files from the User. You can remove
the funktion of write user_xattr but not the posibility to switch it of.
Greetings Alex
