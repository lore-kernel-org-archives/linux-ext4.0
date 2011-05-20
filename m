From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Page allocation error during mount with 2.6.39
Date: Fri, 20 May 2011 08:56:18 -0400
Message-ID: <18683DA2-44FC-4417-9BBB-9627B54D8F8A@mit.edu>
References: <20110520111728@it-loops.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Michael Guntsche <mike@it-loops.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:43497 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932176Ab1ETM4W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 08:56:22 -0400
In-Reply-To: <20110520111728@it-loops.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On May 20, 2011, at 5:22 AM, Michael Guntsche wrote:

> Hello list,
> 
> After upgrading to 2.6.39 I reformatted one of my partitions to ext4 to
> do some testing. During a simple mount I got the following page
> allocation failure, the mount succeeded though.
> The problem is not really reproducible (I tried mounting several times
> afterwards) but I thought I might mention it nevertheless.

The mount failure is harmless; if we can't allocate that much space via kmalloc(), we fall back to vmalloc().  In newer versions of the kernel we suppress the warning so as to avoid people thinking something serious had gone wrong.

Regards,

-- Ted

