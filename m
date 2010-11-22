From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_alloc_context occupies 150 GiB of memory and makes the system
 unusable
Date: Mon, 22 Nov 2010 09:45:51 -0600
Message-ID: <4CEA902F.9040706@redhat.com>
References: <201011221323.25342.bartoschek@or.uni-bonn.de> <4CEA8B4A.3030608@redhat.com> <201011221637.58275.bartoschek@or.uni-bonn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christoph Bartoschek <bartoschek@or.uni-bonn.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab0KVPpy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Nov 2010 10:45:54 -0500
In-Reply-To: <201011221637.58275.bartoschek@or.uni-bonn.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/22/10 9:37 AM, Christoph Bartoschek wrote:

...

> I see the problem for the first time and I do not know whether it is 
> reproducable. We have several similar machines with similar workloads but none 
> has shown such a problem till now.
> 
> I'm going to reboot the machine. If it shows the problem again I will try a 
> newer kernel and then the patch.
> 
> Some workload will be lost, but the machine did not do anything useful for 
> three days now :)

at some point somebody needs to look at the slab cache management, I think;
even if ext4 is (ab)using this cache, having that much memory unreclaimable
in inactive caches is clearly a bug somewhere...!

-Eric
