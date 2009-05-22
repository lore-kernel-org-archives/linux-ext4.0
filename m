From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4-fs error in ext4_reserve_inode_write: Journal has aborted
Date: Fri, 22 May 2009 10:11:02 -0500
Message-ID: <4A16C086.4070903@redhat.com>
References: <40101cc30905201635t6af2586bne1acbc77216628ee@mail.gmail.com> 	<4A14AC12.4000108@redhat.com> <40101cc30905220131t48d3de40y89beafb15d9e2201@mail.gmail.com> 	<20090522111039.GB11742@mit.edu> <40101cc30905220523y47c07f12yb6621095fbf0769c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Matteo Croce <matteo@openwrt.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34140 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578AbZEVPLP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2009 11:11:15 -0400
In-Reply-To: <40101cc30905220523y47c07f12yb6621095fbf0769c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Matteo Croce wrote:
> SCSI error, status {DRDY}
> 
> sort of

That's what I was looking for; looks like drive or controller problems.

This could cause the IO errors which caused the journal to abort and the
filesystem to shut down.

-Eric
