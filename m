From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Sat, 21 Apr 2012 14:26:43 -0400
Message-ID: <4F92FBE3.50709@garzik.org>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu> <4F912880.70708@panasas.com> <alpine.LFD.2.00.1204201120060.27750@dhcp-27-109.brq.redhat.com> <1334919662.5879.23.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-mm@kvack.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59885 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2DUS0q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Apr 2012 14:26:46 -0400
In-Reply-To: <1334919662.5879.23.camel@dabdike>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/20/2012 07:01 AM, James Bottomley wrote:
> The concern I have is that the notion of hot and cold files *isn't*
> propagated to the page cache, it's just shared between the fs and the
> disk.

Bingo -- full-file hint is too coarse-grained for some workloads.  Page 
granularity would propagate to the VM as well as block layer, and give 
the required flexibility to all workloads.  As well as covering the 
full-file case.

	Jeff


