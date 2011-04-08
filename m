From: Mark Busheman <markbusheman@gmail.com>
Subject: Does ext4 send FUA to flush disk cache
Date: Fri, 8 Apr 2011 15:02:27 -0700
Message-ID: <BANLkTikmryaO5r012VwsNzhcaaVQ_4QfzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f66.google.com ([209.85.210.66]:36450 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab1DHWC2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 18:02:28 -0400
Received: by pzk4 with SMTP id 4so544790pzk.1
        for <linux-ext4@vger.kernel.org>; Fri, 08 Apr 2011 15:02:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I plan to use data=journal option with ext4. Would like to know if
ext4 send FUA (Forced Unit Access)
to flush the disk cache?

Cheers
Mark
