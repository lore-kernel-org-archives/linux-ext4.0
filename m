From: Chris Naunton <chris@naunton.name>
Subject: Re: Filesystem corrupted by offline resize
Date: Fri, 22 Feb 2013 10:55:23 +1100
Message-ID: <CACqGdtvvc_g-72_5dXJSQEirW2Qmyi6hki5p9_fcUYjDKZVJMw@mail.gmail.com>
References: <CACqGdtvfi9a9z4F7KpOQmcqNkptdfWXyTTwgxH66RHNqcTAPSQ@mail.gmail.com>
 <20130221195305.GC17322@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:58667 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3BUXzo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2013 18:55:44 -0500
Received: by mail-ea0-f180.google.com with SMTP id c1so32491eaa.25
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 15:55:43 -0800 (PST)
In-Reply-To: <20130221195305.GC17322@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks so much for the detailed reply, Ted. And no need to apologise -
no lost Ph.D. thesis or anything! I have a backup of the most
important data. But there was over 3T of data and my backup capacity
is only 500G, so there's still a lot that will be lost.

I'll give photorec a try. It's very lucky I have the backup - most of
the critical data is encrypted with eCryptfs, so photorec wouldn't
have been able to help there.

Really appreciate all the work you've put into Linux and the
filesystem over the course of your career. I've been using and
administering Linux systems for 13 yrs and this is the first time I've
experienced major ext2/3/4 corruption that hasn't been the fault of
hardware, so I'm still a happy customer, so to speak.

Chris
