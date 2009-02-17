From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 ENOSPC Bug
Date: Tue, 17 Feb 2009 16:56:23 -0600
Message-ID: <499B4097.90808@redhat.com>
References: <20090216162028.3032666a@lithium.local.net>	<200811291418.24672.andres@anarazel.de>	<200812100108.04163.andres@anarazel.de>	<49994FEF.2020908@anarazel.de>	<20090216150156.GD22619@mini-me.lan>	<499985C7.8010302@anarazel.de>	<20090216190001.GB11788@mini-me.lan>	<499AFE32.7070003@redhat.com>	<499B1935.10906@redhat.com> <20090217223017.3a86a045@lithium.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andres Freund <andres@anarazel.de>,
	adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Jonathan Bastien-Filiatrault <joe@x2a.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Alex Buell <alex.buell@munted.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZBQW4q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 17:56:46 -0500
In-Reply-To: <20090217223017.3a86a045@lithium.local.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Alex Buell wrote:
> On Tue, 17 Feb 2009 14:08:21 -0600, I waved a wand and this message
> magically appears in front of Eric Sandeen:
> 
>> FWIW my problem seems to be different than others have encountered;
>> mine persists past reboot, while other reporters have said that a
>> reboot (remount) makes the problem go away.
>>
>> I seem to be encountering some silliness in find_group_flex when 2 out
>> of 3 groups are full (I "only" have 55k inodes left, all in the last
>> group).
> 
> I've discovered a forced fsck clears this. HTH.

Do you have the output of the fsck run?

-Eric
