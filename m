From: Diego Calleja <diegocg@gmail.com>
Subject: GRUB support status?
Date: Sat, 18 Oct 2008 18:48:21 +0200
Message-ID: <20081018184821.4fea2215@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:32975 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYJRQr6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Oct 2008 12:47:58 -0400
Received: by ey-out-2122.google.com with SMTP id 6so371259eyi.37
        for <linux-ext4@vger.kernel.org>; Sat, 18 Oct 2008 09:47:56 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

What's the status of GRUB ext4 support? SVN says[1] that GRUB2 -which is
a development project with no stable version- has ext4 support, but the
only commit I could find[2] only seems to add extent support. Will that
be enought?

There's also a parallel GSoC project[3] from opensuse that seems to have
added[4] ext4 support to Grub (the Grub "legacy" versions which most of
the distros are using).

Which one is prefered? Or it's better to keep using ext3 on /boot until
grub support improves? (PD: I've modified the ext4 HOWTO wiki page adding
some information about all this)


[1]: http://svn.savannah.gnu.org/viewvc/trunk/grub2/NEWS?root=grub&view=diff&r1=1794&r2=1795
[2]: http://svn.savannah.gnu.org/viewvc?view=rev&root=grub&revision=1699
[3]: http://code.google.com/soc/2008/suse/appinfo.html?csaid=91DC4C762E7EE6D7
[4]: http://code.google.com/p/grub4ext4/
