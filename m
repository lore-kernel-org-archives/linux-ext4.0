From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: LTTng 0.89 for Linux 2.6.29-rc3
Date: Fri, 30 Jan 2009 15:07:57 -0500
Message-ID: <20090130200757.GA14999@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:53920 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbZA3UIB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Jan 2009 15:08:01 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I just ported LTTng to the 2.6.29-rc3 kernel. It includes the following
changes :

- Tree RCU instrumentation
- Updated ext4 and jbd2 instrumentation

Please feel free to try it and report any success/problem you may have.
Note that cross-build has been slightly less tested this time because
I'll have to upgrade many of my compilers to a version compatible with
kernel 2.6.29-rc.

It also includes the recently added kprobes support through a simple

echo symbol_name > /mnt/debugfs/ltt/kprobes/enable

It's available at the new LTTng website :

http://www.lttng.org/

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
