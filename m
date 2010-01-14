From: Mike Mestnik <cheako911@gmail.com>
Subject: How to use mkfs.ext4 "stride=" on RAID correctly?
Date: Wed, 13 Jan 2010 18:12:13 -0600
Message-ID: <fa7b26051001131612h482845dalf3446e5fce5f3639@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:43499 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab0ANAMQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2010 19:12:16 -0500
Received: by ewy1 with SMTP id 1so269197ewy.28
        for <linux-ext4@vger.kernel.org>; Wed, 13 Jan 2010 16:12:14 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

What should this value be?  From what I gather it should be the length
of data stored on a single disk for each RAID level block.  If that's
the case how is it that two given data blocks are calculated to be on
separate drives?  It seams to me that the stripe-width is also
essential in this regard, but the man page does not reflect this.

For example let's say that stride=1, then which of the following
blocks are not on the same drive as 1: 8 9 10?
The answer is dependent on the number data disks, like so.
Where x = n - 1 or n depending on the RAID type.
if x = 2 then 9
if x = 3 then 8 and 10
if x = 5 then 8 and 9

There is no way to make this calculation with out knowing x, further
more calculating x based of of both stride and stripe-width is round
about...  Why not simply ask for x, the number of data disks and have
stripe-width be the value that is calculated, as stride might not go
into stripe-width evenly leaving you with a headache.

Did I locate a bug?

Is there a better forum for this discussion?
