From: Josef Bacik <josef@redhat.com>
Subject: Re: [XFS Punch Hole 1/1] XFS Add Punch Hole Testing to FSX
Date: Tue, 03 May 2011 09:18:51 -0400
Message-ID: <4DC000BB.2090505@redhat.com>
References: <4DBF02FF.608@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab1ECNXC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 09:23:02 -0400
In-Reply-To: <4DBF02FF.608@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/02/2011 03:16 PM, Allison Henderson wrote:
> This patch adds punch hole tests to the fsx
> stress test.  The test is performed through
> the fallocate call by randomly choosing to
> use the punch hole flag when running the
> fallocate test.  Regions that have
> been punched out should contain zeros, so
> the expected file contents buffer is updated
> to contain zeros when a hole is punched out.
>

It doesn't look like you have anything to detect if the hole punching 
failed to disable it, how does this behave on say btrfs where we don't 
do hole punching yet?  Thanks,

Josef
