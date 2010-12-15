From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: 20TB ext4
Date: Wed, 15 Dec 2010 02:21:54 -0700
Message-ID: <A7DF8999-362B-459B-9D8A-007F257C9135@dilger.ca>
References: <s6nzks9y74l.fsf@falbala.ieap.uni-kiel.de> <D46B0853-722D-4337-9561-42CECF7DAF47@dilger.ca> <s6nr5dkviez.fsf@falbala.ieap.uni-kiel.de> <s6noc8oxelk.fsf@blaulicht.switch.brux>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Stephan Boettcher <boettcher@physik.uni-kiel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:38667 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab0LOJV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Dec 2010 04:21:56 -0500
In-Reply-To: <s6noc8oxelk.fsf@blaulicht.switch.brux>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-12-14, at 13:51, Stephan Boettcher wrote:
> Stephan Boettcher <boettcher@physik.uni-kiel.de> writes:
>> Andreas Dilger <adilger@dilger.ca> writes:
>>> If you have dedicated server nodes, and you want to be able to use
>>> these 20TB from multiple clients, you might consider using Lustre,
>>> which uses ext4 as the back-end storage, and can scale to many PB
>>> filesystems (largest known filesystem is 20PB, from 1344 * 8TB
>>> separate ext4 filesystems).
>> 
>> I like thinks to be as simple and transparent as possible :-) The plan
>> is to export the fs via NFS.  I will hit the 16 TB limit again, will I?
>> I did not test that part yet.  The NFS clients will then probably be
>> required to run 64-bit kernels as well.
> 
> Excuse me for not knowing all that much about how linux filesystems
> work. I was surprised that I could export the 20TB filesystem via NFS
> and mount it on a 32-bit (2.6.31) system.  Do I need to expect failures
> when I try to actually use it that way, or does the nfs filesystem not
> use the page cache or something, so that the 16TB limit does not apply?

The 16TB limit is related to the 32-bit page index * PAGE_SIZE (4kB), so 2^32 * 2^12 = 2^44 = 16 * 2^40 = 16TB.

Because NFS is not exporting the whole block device, just file access, the filesystem size is not limited by the 32-bit page index.  However, individual file access would be limited to 16TB, and it may be there are lower limits on the file size.

With Lustre, we had filesystems of hundreds of TB in size with 32-bit clients and servers.  The individual Lustre backing filesystems are still under 16TB, so there is not a problem to serve them from 32-bit nodes.  In any case, nobody buys 32-bit systems today so we don't test this much anymore.

Cheers, Andreas





