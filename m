From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: compilebench numbers for ext4
Date: Tue, 23 Oct 2007 19:12:53 +0530
Message-ID: <471DFA5D.1080603@linux.vnet.ibm.com>
References: <20071022193104.0beafeca@think.oraclecorp.com> <471DEC89.2050906@linux.vnet.ibm.com> <20071023090830.1630556a@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:34541 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbXJWNn3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2007 09:43:29 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9NDhQeQ023002
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 23:43:26 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9NDl0tD209498
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 23:47:02 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9NDhAnV002618
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 23:43:10 +1000
In-Reply-To: <20071023090830.1630556a@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Chris Mason wrote:
> On Tue, 23 Oct 2007 18:13:53 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
>> I get this error while running compilebench  
>>
>> http://oss.oracle.com/~mason/compilebench/compilebench-0.4.tar.bz2
> 
> I've uploaded compilebench-0.6.tar.bz2 and updated the docs on the
> compilebench page.  This includes the --makej option that I used for
> the numbers I have posted (sorry, I thought that was pushed out
> already).
> 
> For consistency with seekwatcher, I changed the -d working_dir option
> into -D working_dir.  The actual run I used was:
> 
> ./compilebench -D /mnt --makej -i 20 -d /dev/xxxx -t trace-ext4
> 
> -d and -t make compilebench start blktrace for you at the start of each
> phase, which allows easy creation of the graphs, but this isn't
> required.
> 
>>
>> elm3b138:~/compilebench-0.4# ./compilebench  -d /ext4/
>> Traceback (most recent call last):
>>   File "./compilebench", line 541, in ?
>>     total_runs += func(dset, rnd)
>>   File "./compilebench", line 431, in create_one_dir
>>     mbs = run_directory(dset.unpatched, dirname, "create dir")
>>   File "./compilebench", line 217, in run_directory
>>     fp = file(fname, 'a+')
>> IOError: [Errno 2] No such file or directory:
>> '/ext4/kernel-75618/fs/smbfs/symlink.c' elm3b138:~/compilebench-0.4#
> 
> I'm not sure, did you run out of space?
> 
> 

yes.

 Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb1             9.1G  9.1G     0 100% /mnt




-aneesh
