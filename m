From: vicentiu.neagoe@ni.com
Subject: resilience against power loss
Date: Tue, 22 Jul 2014 19:34:10 +0300
Message-ID: <53CE9282.11182.166B0034@vicentiu.neagoe.ni.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from skprod2.natinst.com ([130.164.80.23]:34347 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755978AbaGVRY2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 13:24:28 -0400
Received: from us-aus-mgwout2.amer.corp.natinst.com (nb-chan1-1338.natinst.com [130.164.19.134])
	by us-aus-skprod2.natinst.com (8.14.5/8.14.5) with ESMTP id s6MGYBHI029710
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2014 11:34:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I'm trying to configure ext4 to prevent data corruption in case of a 
power loss.

I test by doing a cold reset right after writing to a file.
I tried the nodelalloc option, but the file still becomes corrupted 
with trailing garbage.

Using ext3, I either get the old version of the file, or the new 
version, and there is no corruption.

Does nodelalloc not guarantee data integrity?

Are there any other options that provide complete resilience against 
power loss?

thanks

Vicentiu
