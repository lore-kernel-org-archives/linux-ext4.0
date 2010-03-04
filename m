From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: dump/restore not supported for ext4
Date: Thu, 4 Mar 2010 17:05:56 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:42462 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab0CDWF5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Mar 2010 17:05:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I should have researched it more:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=511651
https://lists.ubuntu.com/archives/universe-bugs/2009-June/098729.html

Looks like it's broken, I agree with the reporters, dump should abort if 
it is dealing with an ext4 filesystem, since you cannot restore data from 
an ext4 dump.

Justin.
