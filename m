From: Steve Bergman <sbergman27@gmail.com>
Subject: What does commit=5 really mean?
Date: Wed, 12 Jun 2013 16:23:44 -0500
Message-ID: <CAO9HMNE=orzyjaH09X4Vp1rzmsu9A2b53YY_-zV_ZQ4=sz0TQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:41628 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3FLVXp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jun 2013 17:23:45 -0400
Received: by mail-qa0-f41.google.com with SMTP id f14so653049qak.0
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jun 2013 14:23:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm trying to understand the "commit=nrsec" mount option. I had
thought that it controlled the time between commits of journaled
metadata to its permanent location in disk. However, the kernel
documentation says:

"""
Ext4 can be told to sync all its data and metadata
every 'nrsec' seconds. The default value is 5 seconds.
This means that if you lose your power, you will lose
as much as the latest 5 seconds of work (your
filesystem will not be damaged though, thanks to the
journaling).
"""

This suggests that both metadata and data get committed every nrsec
seconds. But my understanding was that in the default
"data=ordered,delalloc" mode, metadata gets commited every 5s, and
data every 30s. Could someone please clarify?

Thanks,
Steve Bergman
