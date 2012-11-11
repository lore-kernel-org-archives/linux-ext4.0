From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ext4 file corruption using cp
Date: Sun, 11 Nov 2012 10:50:10 -0700
Message-ID: <61093A2B-5AEA-4ED8-B43D-AB6217B405AC@dilger.ca>
References: <CAH3VSLyZvtHC5G_Hx6oHr_jR43+vYz46nXLkifuD3gXGLd21yQ@mail.gmail.com> <CAH3VSLw_spHkb27VbRUG-81Rc=hwPDnhfGOe9LqExs0bFveujQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Roger Niva <rogerniva@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail119c7-2520.megamailservers.com ([69.49.98.26]:50030 "EHLO
	mail119c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752794Ab2KKRuB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Nov 2012 12:50:01 -0500
In-Reply-To: <CAH3VSLw_spHkb27VbRUG-81Rc=hwPDnhfGOe9LqExs0bFveujQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-11-11, at 4:37, Roger Niva <rogerniva@gmail.com> wrote:
> 
> We are trying to pin down a file corruption issue we have on 5
> productionservers and would like some suggestions about how to proceed
> to find the culprit. It may or may not be ext4-related, but as that is
> the only clue we have so far, we're trying here first.
> 
> The productionservers are running Slackware 13.37 with a selfcompiled
> kernel (no patches or external modules).
> We have a script running daily that copies files from one folder to
> another using cp.

there was a bug in ext4 FIEMAP ioctl code in the past that interacted badly with fileutils for copying files that were just written and still in cache.  That was around 2.6.26 or so.

You should probably try a new version of fileutils to see if that solves the problem. Alternately, if you run "sync" before "cp" this should also avoid the problem. 

Cheers, Andreas

> On occasion (once or twice a week) the
> destinationfile will not match the original file. The first bytes of
> the files will be ok, but the rest of the file will be filled with
> nullbytes (the file size matches, though). We had to create a loop in
> the script that uses cmp to check if the cp failed and retry if it
> did. After 20-25 attempts (sleep 1 between the cps), the cp normally
> succeeds.
> 
> If we copy the files from ext3 to ext3, the problem goes away. If we
> copy it from ext3 to ext4 or from ext4 to ext4, the files will
> sometimes be corrupt.
> 
> The servers are not being rebooted and the filesystems are not being
> remounted, so it's probably not linked to the recent ext4 corruption.
> 
> The kernel is x86_64, but the OS is 32-bit. The filesystems reside on
> an aacraid controller (hw RAID-5) with batterybackup and an SSD cache
> (we tried to remove the SSD, but it still failed). ext4 is mounted
> with noatime,data=writeback. There are no kernel errormessages and
> there does not appear to be any hardwareissues.
> 
> We have verified the corruption on 3.2.9 and 3.5.3. 2.6.35.6 seems to
> not be affected.
> 
> Since these are productionservers (we haven't been able to reproduce
> it inhouse), there is only so much testing we can do, but we're
> currently trying to figure out what we can do to narrow it down. I am
> aware that I'm not neccessary providing much information, but as this
> point we're just looking for suggestions about how to proceed to
> figure out what may be the issue.
> 
> Any help would be much appreciated.
> 
> 
> --
> Vennlig hilsen,
> Roger Niva
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
