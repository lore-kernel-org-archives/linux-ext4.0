From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: Punch hole patch causes a regression on 1k file systems
Date: Mon, 25 Jul 2011 08:24:54 -0700
Message-ID: <4E2D8AC6.80900@linux.vnet.ibm.com>
References: <20110725031858.GA32714@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50637 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1GYPY5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jul 2011 11:24:57 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6PFCDah005364
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jul 2011 11:12:13 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p6PFOulw139214
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jul 2011 11:24:56 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p6PFOtVi030454
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jul 2011 12:24:56 -0300
In-Reply-To: <20110725031858.GA32714@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/24/2011 08:18 PM, Ted Ts'o wrote:
> Apparently commit a4bb6b64e39a: "ext4: enable "punch hole"
> functionality" causes a regression on 1k block file systems.  It
> causes failures for xfstests #75, #112, #127.  This shows when using
> file systems with a 1k block file system.  (I assume this means it
> will also show up on Power systems with 16k pages and 4k file system
> blocks...)
>
> Enclosed please find the log of the xfstests run for commit a4bb6b6
> and e861304 (where e861304 is the parent commit for a4bb6b6).
>
> Allison, could you take a look into this, please?  Many thanks!!
>
> 	       	   	       	    	  	   - Ted
>
Alrighty, I will look into it.  Thx Ted!

Allison Henderson
