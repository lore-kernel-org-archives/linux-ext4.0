From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Add a norecovery option to ext3/4?
Date: Mon, 09 Apr 2007 11:43:15 -0400
Message-ID: <461A5F13.7040705@cfl.rr.com>
References: <20070409000556.GA13980@implementation>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from iriserv.iradimed.com ([72.242.190.170]:49663 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965589AbXDIPzk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Apr 2007 11:55:40 -0400
In-Reply-To: <20070409000556.GA13980@implementation>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Samuel Thibault wrote:
> Hi,
> 
> Distribution installers usually try to probe OSes for building a suited
> grub menu.  Unfortunately, mounting an ext3 partition, even in read-only
> mode, does perform some operations on the filesystem (log recovery).
> This is not a good idea since it may silently garbage data.  XFS has a
> norecovery option that allows to disable that, I'd say ext3/4 should
> have it too.

When the filesystem is told to mount the disk read only, that means it 
should not write to it.  The fact that ext3 goes ahead and does anyway 
is a bug and should be fixed.  There is no need for a norecovery option, 
because read only is a sufficient directive to tell the filesystem not 
to write to the disk.

As someone else pointed out, this behavior causes havoc if you hibernate 
a system and then boot up another system which mounts the disk of the 
hibernated system.  Under all conditions it should be safe to mount a 
disk read only, but here it is not because the journal playback trashes 
the disk out from under the hibernated system.
