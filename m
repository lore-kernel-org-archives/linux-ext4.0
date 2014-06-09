From: Mahesh Khanwalkar <maheshkhanwalkar@gmail.com>
Subject: Ext4 Size Restrictions
Date: Mon, 9 Jun 2014 14:03:58 -0400
Message-ID: <CAF8aoe0Ho8GozZ_jTk90n9jbVqcBaVzr3-P6twbsfAs2jNKYDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:50760 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaFISET (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jun 2014 14:04:19 -0400
Received: by mail-vc0-f171.google.com with SMTP id id10so4924589vcb.2
        for <linux-ext4@vger.kernel.org>; Mon, 09 Jun 2014 11:04:18 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,
Ext4 supports max file size of 16TiB and max volume of 1EiB. What
exactly in the implementation causes this restriction? Also is there
any plans (as of now) to make it max sizes larger?

Thanks,
Mahesh Khanwalkar
