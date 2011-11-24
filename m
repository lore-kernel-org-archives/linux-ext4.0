From: Amir Goldstein <amir73il@gmail.com>
Subject: wifi issues workaround
Date: Thu, 24 Nov 2011 12:24:36 +0200
Message-ID: <CAOQ4uxi1+yUAkqriUhKMMgnjLvBN1xW7RwpO+h8E1+MesfkFkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Alex Van't Hof" <alexvh@cs.columbia.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51762 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1KXKYh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Nov 2011 05:24:37 -0500
Received: by wwp14 with SMTP id 14so1493081wwp.1
        for <linux-ext4@vger.kernel.org>; Thu, 24 Nov 2011 02:24:36 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Alex,

After 2 days of no wifi issues on my beta device, Ziv has configured a
gmail account on my device
and that has changes everything.

>From that point, like QA has repeatedly reported, device has woke up
from sleep mode
in endless scanning... or obtaining IP.. states and to get out of this
loop required either:
1. switch persona
2. connect USB
3. enable/disable wifi

I concluded that the issue was created by gmail changing the default
wifi sleep policy
and verified that by applying a workaround - setting wifi sleep policy
on both personas
to never.

Since I did that (and Ziv too), I have no more wifi issues.

I've instructed Dror to resolve the "agent always connected" issue by taking
a wifilock on both personas and that should also resolve the wifi
connectivity issues.

The remaining question is:
Given that your wifi sharing code doesn't work well when the 2
personas are using
a different "state machine" (i.e. never sleep or sleep when screen is
off), do you see
any clear and immediate bug in your code that should be fixed as well?

Thanks,
Amir.
