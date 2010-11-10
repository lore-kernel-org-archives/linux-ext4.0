From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: ext3/ext4 and waiting in do_get_write_access
Date: Wed, 10 Nov 2010 13:34:30 +0300
Message-ID: <AANLkTimgPmkcvexhhQQEXTjtwEDsqq+d_gXbQjnx_70D@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63649 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab0KJKeb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Nov 2010 05:34:31 -0500
Received: by iwn10 with SMTP id 10so622997iwn.19
        for <linux-ext4@vger.kernel.org>; Wed, 10 Nov 2010 02:34:30 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I've two types of process: 15 RT small writers (2 page writers) and 3
hard writers. When I start hard writers RT processes start thrashing
in do_get_write_access (waiting can be about 3-6s, but in normal
situation it's expected to make writes in 50-100ms).
I see the place, where we wait in do_get_write_access(). Are there
anything to do with this problem, so I don't get problems with
realtime processes? At least theoretically (I'm unfamiliar with
journaling)?

-- 
Evgeniy Ivanov
