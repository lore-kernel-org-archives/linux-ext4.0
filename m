From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Add a norecovery option to ext3/4?
Date: Mon, 09 Apr 2007 08:29:10 +0400
Message-ID: <4619C116.1090702@wasp.net.au>
References: <20070409000556.GA13980@implementation> <4619B202.3050601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wasp.net.au ([203.190.192.17]:53876 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbXDIEeZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Apr 2007 00:34:25 -0400
In-Reply-To: <4619B202.3050601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> Samuel Thibault wrote:
>> Hi,
>>
>> Distribution installers usually try to probe OSes for building a suited
>> grub menu.  Unfortunately, mounting an ext3 partition, even in read-only
>> mode, does perform some operations on the filesystem (log recovery).
>> This is not a good idea since it may silently garbage data.  
> 
> Can you elaborate?  Under what circumstances is log replay going to harm 
> data?  Do you mean that the installer mounts partitions, looking for 
> what OS is installed?  How is that harmful?
> 

It'll wreak havoc on my hibernated system when I've suspended it to do a test OS install on one of 
my spare partitions. The log replay will go fine, but then when the system resumes it's idea of 
what's on the disk won't match what is really there and ugly, ugly things happen.


Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
