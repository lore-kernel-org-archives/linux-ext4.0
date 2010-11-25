From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Thu, 25 Nov 2010 11:41:50 +0200
Message-ID: <4CEE2F5E.4070608@panasas.com>
References: <20101123100239.GA4232@amd>	<1290515274-sup-3895@think> <20101124144740.bffb2716.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>,
	Nick Piggin <npiggin@kernel.dk>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:17612 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0KYJly (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 04:41:54 -0500
In-Reply-To: <20101124144740.bffb2716.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/25/2010 12:47 AM, Andrew Morton wrote:
> On Tue, 23 Nov 2010 07:34:07 -0500
> Chris Mason <chris.mason@oracle.com> wrote:
> 
>> For btrfs there's only one bdi per SB, but for most everyone else a disk
>> with a bunch of partitions is going to have multiple filesystems on the
>> same bdi.
> 
> um, please explain why that wasn't idiotic?  The BDI is a
> representation of a backing device and it's *supposed* to provide
> visibility into what's happening against other partitions on the same
> device.  Creating a BDI per SB (it didn't even occur to me to think
> that a filesystem was even able to do this) breaks that.
> 

In btrfs an SB my span multiple partitions. How else can it be solved?

(I know... You didn't like that from the begging ;-))

Boaz
> 
