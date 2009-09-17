From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: git svn clone freezes the pc on ext4
Date: Thu, 17 Sep 2009 09:27:25 -0500
Message-ID: <4AB2474D.2000908@redhat.com>
References: <20090917131356.GG9393@kubieziel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jens Kubieziel <maillist@kubieziel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbZIQO1y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Sep 2009 10:27:54 -0400
In-Reply-To: <20090917131356.GG9393@kubieziel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jens Kubieziel wrote:
> Hi,
> 
> I recently changed my /home-partition to ext4 and wanted to clone a SVN
> repository. After calling "git svn clone https://...", git began
> fetching old revisions and at every try the complete pc freezes. It
> doesn't respond to any keyboard presses nor to SysRq. I tried the same
> command on different filesystems (ext3, reiser) and with different git
> versions. Only git on ext4 causes this freeze.
> 
> The system logs have no uncommon messages. I found only:
> EXT4 FS on sda3, internal journal on sda3:8
> EXT4-fs: deleayed allocation enabled
> EXT4-fs: file extents enabled
> EXT4-fs: mballoc enabled
> EXT4-fs: mounted filesystem with ordered data mode
> Linux version is 2.6.28-15 (default installation from Ubuntu jaunty).
> 
> How can I find out more about this freeze? Is maybe something known what
> causes this? Thanks for any hints.

I'd try doing the test on the main console (not X), turn dmesg up (dmesg
-n 8) and make sure sysrq is enabled; I'd try sysrq-t or sysrq-w to get
stack traces for processes.  If really and truly none of that works and
you get no messages, that sounds like a tough one to sort out.

.28 is getting a bit old, I'd probably try a newer upstream kernel as well.

-Eric
