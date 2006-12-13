From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Wed, 13 Dec 2006 08:40:14 -0600
Message-ID: <458010CE.6020402@redhat.com>
References: <m3vekwtqnp.fsf@bzzz.home.net> <45800965.2080005@bull.net> <m3wt4vzxje.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964956AbWLMOsK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Dec 2006 09:48:10 -0500
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3wt4vzxje.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
>>>>>> Valerie Clement (VC) writes:
> 
>  VC> Hi Alex,
>  VC> I did the following test:
>  VC> # mkfs /dev/sdc1
>  VC> # mount -t ext4dev -o extents,mballoc,delalloc /dev/sdc1 /test
>  VC> # dumpe2fs -h /dev/sdc1
>  VC> # cp linux.tar /test
>  VC> # tar xf /test/linux.tar
>  VC> # dumpe2fs -h /dev/sdc1
> 
>  VC> The "Free blocks" and "Free inodes" counters in the dumpe2fs output
>  VC> did not change after running the cp and tar commands.
> 
> sync should help, I think.

This is probably a discrepancy that comes from reading the block device 
directly, right?  Which is not necessarily in sync with the address 
space for the filesystem.

-Eric
