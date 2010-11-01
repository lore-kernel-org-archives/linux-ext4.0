From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: ext4_lazyinit_thread: 'ret' may be used uninitialized in this
 function
Date: Mon, 01 Nov 2010 20:04:24 +0100
Message-ID: <4CCF0F38.3030106@s5r6.in-berlin.de>
References: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de> <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:44371 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab0KATEn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Nov 2010 15:04:43 -0400
In-Reply-To: <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lukas Czerner wrote:
> thank you for noticing this, because I actually do not see the warning
> (I wonder why...),

Probably because of different gcc versions.  Here: 4.3.4
-- 
Stefan Richter
-=====-==-=- =-== ----=
http://arcgraph.de/sr/
