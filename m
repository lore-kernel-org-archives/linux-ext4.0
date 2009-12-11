From: Oleg Drokin <green@linuxhacker.ru>
Subject: Potential data consistency issue with ASYNC_COMMIT feature
Date: Fri, 11 Dec 2009 01:45:09 -0500
Message-ID: <FA695DF7-1D78-471A-A527-0079C045AF09@linuxhacker.ru>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>,
	Andreas Dilger <adilger@Sun.COM>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from linuxhacker.ru ([217.76.32.60]:38782 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757738AbZLKIGL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Dec 2009 03:06:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello!

   I think ext4 ASYNC_COMMIT feature is potentially pretty unsafe 
   when write-back cache is enabled on the device.
   Since no barriers are ever done with this feature even if
   the barriers are enabled, we might end up in the situation
   where we write the journal blocks, then commit block, they 
   hit the device write-back cache, after that actual metadata
   blocks would be allowed to go to disk and eventually they will.

   In the end the device might decide to reorder some of the
   actual metadata updates in front of journal updates and
   if metadata updates will hit the disk and a power or other
   failure occurs after that, we have inconsistent filesystem
   as a result.

   I do not see an easy way to remedy the problem in this case
   other than to insert empty barrier after the commit block
   and wait for it completion, but I think that would negate
   the entire gain from this feature. I wish we actually had
   real ordered writes implemented, not just barrier/FUA
   sent to the device before every ordered buffer.

   Am I missing something?

   Thanks.

Bye,
    Oleg
