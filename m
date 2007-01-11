From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: ext3 data=journal hangs
Date: Wed, 10 Jan 2007 16:03:51 -0800
Message-ID: <20070110160351.90f860b9.randy.dunlap@oracle.com>
References: <20070109151123.df6a3c40.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet02.oracle.com ([148.87.113.119]:42856 "EHLO
	rgminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965263AbXAKALv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jan 2007 19:11:51 -0500
Received: from rgminet01.oracle.com (rgminet01.oracle.com [148.87.113.118])
	by rgminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l0B0BoKT023044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jan 2007 17:11:50 -0700
Received: from rgmgw3.us.oracle.com (rgmgw3.us.oracle.com [138.1.186.112])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id l0B05TGY015627
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jan 2007 17:05:29 -0700
Received: from rcsmt250.oracle.com (rcsmt250.oracle.com [148.87.90.195])
	by rgmgw3.us.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l0B012cZ021275
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jan 2007 17:05:29 -0700
To: linux-ext4@vger.kernel.org
In-Reply-To: <20070109151123.df6a3c40.randy.dunlap@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 9 Jan 2007 15:11:23 -0800 Randy Dunlap wrote:

> Hi,
> 
> (2.6.20-rc4, x86_64 1-proc on SMP kernel, 1 GB RAM)
> 
> I'm running fsx-linux (akpm ext3-tools version) on an ext3 fs
> with data=journal and fs blocksize=2048.  I've been trying to
> get some kind of kernel messages from it but I can't get any
> debug IO done successfully.
> 
> It has hung on me 3 times in a row today.  I'm using this command:
> fsx-linux -l 100M -N 50000 -S 0 fsxtestfile
> 
> This is run in a new partition on a IDE drive (/dev/hda7,
> using legacy IDE drivers).
> 
> Any suggestions for debug output?  I can see SysRq output on-screen
> (sometimes) but it doesn't make it to my serial console.
> 
> Any patches to test?  :)

More notes:
Fails (hangs) with fs blocksize of 1024, 2048, or 4096.
On data=journal mode hangs.  writeback and ordered run fine.

After several runs (hangs), I was able to get some sysrq output
to the serial console.

kernel config:  http://oss.oracle.com/~rdunlap/configs/config-2620-rc4-hangs
message log:    http://oss.oracle.com/~rdunlap/logs/fsx-capture.txt

Can anyone see what fsx-linux is waiting on there?

Thanks,
---
~Randy
