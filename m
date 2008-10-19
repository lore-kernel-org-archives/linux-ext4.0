From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: GRUB support status?
Date: Sat, 18 Oct 2008 23:11:45 -0500
Message-ID: <48FAB381.4070500@redhat.com>
References: <20081018184821.4fea2215@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48841 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYJSELt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Oct 2008 00:11:49 -0400
In-Reply-To: <20081018184821.4fea2215@diego-desktop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Diego Calleja wrote:
> What's the status of GRUB ext4 support? SVN says[1] that GRUB2 -which is
> a development project with no stable version- has ext4 support, but the
> only commit I could find[2] only seems to add extent support. Will that
> be enought?
> 
> There's also a parallel GSoC project[3] from opensuse that seems to have
> added[4] ext4 support to Grub (the Grub "legacy" versions which most of
> the distros are using).
> 
> Which one is prefered? Or it's better to keep using ext3 on /boot until
> grub support improves? (PD: I've modified the ext4 HOWTO wiki page adding
> some information about all this)

For now I'd probably keep /boot on ext3.

Fedora will probably eventually merge the GSoC patch for our "legacy"
grub at some point, but TBH I've not even tested it yet, much less
looked  over the patch ...

-Eric

> 
> [1]: http://svn.savannah.gnu.org/viewvc/trunk/grub2/NEWS?root=grub&view=diff&r1=1794&r2=1795
> [2]: http://svn.savannah.gnu.org/viewvc?view=rev&root=grub&revision=1699
> [3]: http://code.google.com/soc/2008/suse/appinfo.html?csaid=91DC4C762E7EE6D7
> [4]: http://code.google.com/p/grub4ext4/

