From: Arthur Jones <ajones@riverbed.com>
Subject: Re: ext3: kernel BUG at fs/jbd/journal.c:412!
Date: Thu, 6 Nov 2008 08:12:27 -0800
Message-ID: <20081106161227.GA9254@ajones-laptop.nbttech.com>
References: <20081106155025.GE25194@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.riverbed.com ([206.169.144.12]:54675 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYKFQM2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 11:12:28 -0500
Content-Disposition: inline
In-Reply-To: <20081106155025.GE25194@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Aneesh, ...

On Thu, Nov 06, 2008 at 07:50:25AM -0800, Aneesh Kumar K.V wrote:
> I get this with ext4-patchqueue. I guess we have some ext3 patches queued there.

This could be related to a patch I just posted.

I'd like to try to reproduce this.  What is the
ext4-patchqueue?  What were you running that caused
this to pop up?

See the thread on linux-ext4 called "ext3: slow symlink corruption
on umount" for details on how this patch came about...

Thanks...

Arthur
