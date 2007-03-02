From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 01 Mar 2007 22:03:55 -0800
Message-ID: <45E7BE4B.5070602@us.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60701 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422936AbXCBGED (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2007 01:04:03 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Amit K. Arora wrote:

>This is to give a heads up on few patches that we will be soon coming up
>with. These patches implement a new system call sys_fallocate() and a
>new inode operation "fallocate", for persistent preallocation. The new
>system call, as Andrew suggested, will look like:
>
>  asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
>
I am wondering about return values from this syscall ? Is it supposed to 
return the
number of bytes allocated ? What about partial allocations ? What about 
if the
blocks already exists ? What would be return values in those cases ?

Just curious .. What does posix_fallocate() return ?

Thanks,
Badari

>
