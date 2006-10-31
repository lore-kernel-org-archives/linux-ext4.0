From: Samuel Tardieu <sam@rfc1149.net>
Subject: Shred mount option for ext4?
Date: 31 Oct 2006 11:36:11 +0100
Message-ID: <87hcxkpyas.fsf@willow.rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:22437 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S1423093AbWJaKpG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Oct 2006 05:45:06 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Ger78-0004va-Ek
	for linux-ext4@vger.kernel.org; Tue, 31 Oct 2006 11:45:02 +0100
Received: from zaphod.rfc1149.net ([88.191.14.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 31 Oct 2006 11:45:02 +0100
Received: from sam by zaphod.rfc1149.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 31 Oct 2006 11:45:02 +0100
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Sorry if this has been discussed already, I couldn't find anything in
the list archive about it. What about adding the possibility of
shredding or erasing free blocks on an ext4 filesystem?

I value my privacy and the privacy of the people I host, and I often
use shred(1) when erasing files from my server. The goal is to avoid
that either a hacker or a post-mortem analysis gets ancien data from
my disk. There are three problems with this approach:

  - I may forget to use shred sometimes

  - some files are automatically created and then removed (mails in
    spool)

  - data may be replicated in the journal and thus still present on
    disk

I could use an encrypted filesystem everywhere, but in many countries,
one is required to reveal her encryption key to authorities if they
have a court order (UK for example).

I think it would be quite easy to add a mount time option to ext4
filesystems asking that freed blocks are cleared or erased with random
data? We could have for example:

  - free=clear|zero|shred (default "clear", do nothing, "zero" means
    writing zeroes over the block, useful against attackers trying to
    recover data from a file system without physical access to it, and
    "shred" useful against post-mortem analysis of the physical
    surface)

  - shred-passes=N (number of passes when using the "free=shred"
    option, a negative number meaning writing values from 0 to -N onto
    the block)

Some people (me included) would most likely accept the time penalty of
using this option on selected filesystems (as well as the reduced
lifetime of the disks because of the extra writes).

I would contribute a proof-of-concept code, but I'm going to leave for
a one-month vacation and will have a very bad connection until
December. However, if noone jumps on that, I will likely code that
when I go back unless someone beats me on it. In the meantime, I'd
like to get people thoughts about it.

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/
