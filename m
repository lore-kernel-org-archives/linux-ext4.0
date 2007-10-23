From: Chris Mason <chris.mason@oracle.com>
Subject: Re: compilebench numbers for ext4
Date: Tue, 23 Oct 2007 09:08:30 -0400
Message-ID: <20071023090830.1630556a@think.oraclecorp.com>
References: <20071022193104.0beafeca@think.oraclecorp.com>
	<471DEC89.2050906@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:15848 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbXJWNKZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2007 09:10:25 -0400
In-Reply-To: <471DEC89.2050906@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 23 Oct 2007 18:13:53 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> 
> I get this error while running compilebench  
> 
> http://oss.oracle.com/~mason/compilebench/compilebench-0.4.tar.bz2

I've uploaded compilebench-0.6.tar.bz2 and updated the docs on the
compilebench page.  This includes the --makej option that I used for
the numbers I have posted (sorry, I thought that was pushed out
already).

For consistency with seekwatcher, I changed the -d working_dir option
into -D working_dir.  The actual run I used was:

./compilebench -D /mnt --makej -i 20 -d /dev/xxxx -t trace-ext4

-d and -t make compilebench start blktrace for you at the start of each
phase, which allows easy creation of the graphs, but this isn't
required.

> 
> 
> elm3b138:~/compilebench-0.4# ./compilebench  -d /ext4/
> Traceback (most recent call last):
>   File "./compilebench", line 541, in ?
>     total_runs += func(dset, rnd)
>   File "./compilebench", line 431, in create_one_dir
>     mbs = run_directory(dset.unpatched, dirname, "create dir")
>   File "./compilebench", line 217, in run_directory
>     fp = file(fname, 'a+')
> IOError: [Errno 2] No such file or directory:
> '/ext4/kernel-75618/fs/smbfs/symlink.c' elm3b138:~/compilebench-0.4#

I'm not sure, did you run out of space?

-chris
