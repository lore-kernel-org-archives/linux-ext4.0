From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 ENOSPC Bug
Date: Tue, 17 Feb 2009 14:08:21 -0600
Message-ID: <499B1935.10906__11977.2529499189$1234901505$gmane$org@redhat.com>
References: <20090216162028.3032666a@lithium.local.net> <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan> <499985C7.8010302@anarazel.de> <20090216190001.GB11788@mini-me.lan> <499AFE32.7070003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Andres Freund <andres@anarazel.de>,
	Alex Buell <alex.buell@munted.org.uk>, adilger@sun.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.or
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45369 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbZBQUJM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 15:09:12 -0500
In-Reply-To: <499AFE32.7070003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Theodore Tso wrote:
>> On Mon, Feb 16, 2009 at 04:27:03PM +0100, Andres Freund wrote:
>>> So, yes, seems to be an inode allocation problem.
>>>
>> Andres, Alex, others,
>>
>> I'm pretty sure the ENOSPC problem which you both found is an inode
>> allocation problem.  Some of you seem to have an easier time
>> reproducing it than others; could you try this patch, and periodically
>> scan your system logs for the message "ext4: find_group_flex failed,
>> fallback succeeded"?  If the problem goes away for you, and you find
>> the occasional aforemention message in your system log, that will
>> confirm what I suspect, which is the bug is in fs/ext4/inode.c's
>> find_group_flex() function.  (If I'm wrong, the fallback code will
>> activate only when the filesystem is genuinely out of inodes, which
>> should be very rare.)
>>
>> More comments are in the patch header.  My current long-term plan for
>> dealing with this is to enhance find_group_orlov() to and
>> find_group_other() to understand about flex_bg's.
> 
> Ok, I finally got to where I can reliably hit this.  Just as I was about
> to install an ext4 with this patch in place, and the bug was preventing
> the new initrd creation ;)  But worked around that, and:
> 
> ext4: find_group_flex failed, fallback succeeded dir 258402
> ext4: find_group_flex failed, fallback succeeded dir 258402
> ext4: find_group_flex failed, fallback succeeded dir 258402
> ext4: find_group_flex failed, fallback succeeded dir 258402
> ....
> 
> I'll see if I can dig a bit more as to why the find_group_flex failed,
> if you think it's worth it, Ted.

FWIW my problem seems to be different than others have encountered; mine
persists past reboot, while other reporters have said that a reboot
(remount) makes the problem go away.

I seem to be encountering some silliness in find_group_flex when 2 out
of 3 groups are full (I "only" have 55k inodes left, all in the last group).

-Eric
