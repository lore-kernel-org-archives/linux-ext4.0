From: =?UTF-8?Q?Matthijs_M=c3=b6hlmann?= <matthijs@cacholong.nl>
Subject: storing a value larger than UINT_MAX
Date: Fri, 24 Feb 2017 11:38:40 +0100
Message-ID: <b7e4d5b8-cf1c-96df-a488-57660c36b7dd@cacholong.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.cacholong.nl ([46.182.221.98]:60274 "EHLO
        mail.cacholong.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdBXKsI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Feb 2017 05:48:08 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.cacholong.nl (Postfix) with ESMTP id E3244C0002CBB
        for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2017 11:38:41 +0100 (CET)
Received: from mail.cacholong.nl ([127.0.0.1])
        by localhost (ironhorse.hellinga-webservice.nl [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id uArU+gNFs9SS for <linux-ext4@vger.kernel.org>;
        Fri, 24 Feb 2017 11:38:41 +0100 (CET)
Received: from Matthijss-MacBook-Pro.local (83-162-219-163.ip.xs4all.nl [83.162.219.163])
        (Authenticated sender: matthijs@cacholong.nl)
        by mail.cacholong.nl (Postfix) with ESMTPSA id 01651C0006DF0
        for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2017 11:38:40 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello ext4 developers,

I am trying to run a kernel with grsecurity with the size overflow
protection and am getting the following warnings / errors:

dmesg: http://pastebin.com/wr3UGLS9
config: http://pastebin.com/sr8M9bP0
mballoc.* (make fs/ext4/mballoc.o EXTRA_CFLAGS="-fdump-tree-all
-fdump-ipa-all") http://filebin.ca/3DMIChVw9lQM/mballoc.tgz

According to the grsecurity developers it seems to be a bug in ext4:
https://forums.grsecurity.net/viewtopic.php?f=1&t=4678&p=16971

The response from ephox (PAX team / grsecurity developer):
--
Thanks for the report. I think this is an upstream bug. Based on the
runtime values provided by you, ext4_mb_new_group_pa() tries to store a
value into pa->pa_lstart which larger than UINT_MAX which comes from
ext4_group_first_block_no().
Could you please report it to the ext4 developers?
--

I'll try to answer all the questions but I'm not an expert in this area.

I am also not subscribed to this mailinglist so please keep me in the CC.

Regards,

Matthijs Möhlmann
