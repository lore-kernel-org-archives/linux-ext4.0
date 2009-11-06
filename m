From: Jesper Jensen <linux-ext4_mailinglist@elector.dk>
Subject: Formatted/repartitioned wrong disk, arrgh!
Date: Fri, 06 Nov 2009 11:19:25 +0100
Message-ID: <4AF3F82D.50105@elector.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sonosmtp1.cybercity.dk ([212.242.41.60]:54618 "EHLO
	sonosmtp1.cybercity.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbZKFK3r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 05:29:47 -0500
Received: from [192.168.100.10] (unknown [85.82.22.90])
	by sonosmtp1.cybercity.dk (Postfix) with ESMTP id E376FB8AB
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2009 11:20:27 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

First of all I know this isn't a development or bug related question, 
but I'm running out of ideas on how to rescue my files, so I hope you 
guys can bare with me.

Yesterday I accidentally did a repartition ad and mkfs.ext4 on the wrong 
data disk, ARRGH! I thought it was an empty disk, but nooo it was one 
containing a lot of data that I don't really have a backup of anywhere. :-(

I've tried various fsck -f -b <backup superblocks> but it looks like I 
might have made a royal fuckup and overwritten/erased every single 
backup superblock. :-(

As far as I recall the first time I ran fsck it said something about the 
blocks being empty and asked me to accept a bunch of times (eventually 
ended up using the -p option).

I have also tried tools like magicrescue and foremost to recover my 
files, but no such luck.

Can you guys recommend a good way to recover the files?


Regards
Jesper
