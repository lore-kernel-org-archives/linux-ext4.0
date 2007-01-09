From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: ext3 data=journal hangs
Date: Tue, 9 Jan 2007 15:11:23 -0800
Message-ID: <20070109151123.df6a3c40.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:16029 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbXAIXL4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jan 2007 18:11:56 -0500
Received: from rgmgw2.us.oracle.com (rgmgw2.us.oracle.com [138.1.186.111])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l09NBsmm028902
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jan 2007 17:11:55 -0600
Received: from rcsmt251.oracle.com (rcsmt251.oracle.com [148.87.90.196])
	by rgmgw2.us.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l09MwtM9007044
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jan 2007 16:11:54 -0700
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

(2.6.20-rc4, x86_64 1-proc on SMP kernel, 1 GB RAM)

I'm running fsx-linux (akpm ext3-tools version) on an ext3 fs
with data=journal and fs blocksize=2048.  I've been trying to
get some kind of kernel messages from it but I can't get any
debug IO done successfully.

It has hung on me 3 times in a row today.  I'm using this command:
fsx-linux -l 100M -N 50000 -S 0 fsxtestfile

This is run in a new partition on a IDE drive (/dev/hda7,
using legacy IDE drivers).

Any suggestions for debug output?  I can see SysRq output on-screen
(sometimes) but it doesn't make it to my serial console.

Any patches to test?  :)

Thanks,
---
~Randy
