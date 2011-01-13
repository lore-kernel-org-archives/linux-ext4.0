From: "Bojan Smojver" <bojan@rexursive.com>
Subject: Re: [linux-pm] Oops while going into hibernate
Date: Thu, 13 Jan 2011 23:11:45 +1100
Message-ID: <6009472527.979427505@rexursive.com>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6> <20110112162655.GA13496@thunk.org> <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6> <20110112172646.GB13496@thunk.org> <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6> <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu> <alpine.LFD.2.02.1101131238480.1899@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Cc: tytso@mit.edu, linux-pm@lists.linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: sebott@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from beauty.rexursive.com ([150.101.121.179]:51977 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab1AMMLx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 07:11:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Yes. I basically did a
> echo reboot > /sys/power/disk
> for i in {1..5} ;do echo disk > /sys/power/state ;done
> and it crashed very early in the second suspend.

Was compression on or off?

--
Bojan 
