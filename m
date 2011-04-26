From: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Subject: Need of revoke mechanism in JBD
Date: Tue, 26 Apr 2011 13:59:11 +0530
Message-ID: <4DB68257.4070407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61465 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1DZIck (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 04:32:40 -0400
Received: by pzk9 with SMTP id 9so136933pzk.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 01:32:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,
       I am new to fs development. I am trying to modify the journal 
structure of JBD. While analyzing the code, I could understand most of 
the things, but I am not able to understand the need of revoke 
mechanism. Can anybody enlighten me on this issue?

Regards
Niraj
