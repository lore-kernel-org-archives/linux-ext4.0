From: Don Porter <porterde@cs.utexas.edu>
Subject: ext3 leaking buffer_heads
Date: Mon, 23 Mar 2009 14:56:09 -0500
Message-ID: <49C7E959.4010000@cs.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.cs.utexas.edu ([128.83.139.10]:38757 "EHLO
	mail.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbZCWUpz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Mar 2009 16:45:55 -0400
Received: from [128.83.122.94] (habals.csres.utexas.edu [128.83.122.94])
	(authenticated bits=0)
	by mail.cs.utexas.edu (8.14.3/8.14.3) with ESMTP id n2NJu9Qw011006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2009 14:56:10 -0500 (CDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

It appears that the ext3 journal code has a slow leak of buffer_head 
structs.  Try this simple script:

perl -e 'while(1){ `sync`; }'

and monitor the count of allocated buffer_head structs in 
/proc/slabinfo, and it seems to increase without bound.  Even after this 
script is killed and the machine is left idle for several minutes, the 
count of buffer heads doesn't substantially decrease.

Looking around at various machines I have access to, the count of 
allocated buffer_heads roughly correlates with uptime when using ext3.  
This is a slow leak - one would likely have to run this script for a day 
or more to drain enough lowmem to cause problems.

Other info:  I have only tried this on x86 machines, but I have tried 
both 2.6.22.6 and 2.6.28.8, and both have the problem.  I am running 
Ubuntu 7.10 on top of these kernels, but the kernels were built directly 
from kernel.org tarballs.

Any advice or help with this issue is greatly appreciated. 

Thanks,
Don
