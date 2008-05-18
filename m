From: Bas van Schaik <bas@tuxes.nl>
Subject: Scripting e2fsck: no errors, but still exit code 1 "FILE SYSTEM WAS
 MODIFIED"
Date: Sun, 18 May 2008 12:37:37 +0200
Message-ID: <483006F1.6080008@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pollux.sshunet.nl ([145.97.192.42]:37296 "EHLO
	pollux.sshunet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYERLHd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 May 2008 07:07:33 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by pollux.sshunet.nl (Postfix) with ESMTP id 41D6A580006
	for <linux-ext4@vger.kernel.org>; Sun, 18 May 2008 12:37:41 +0200 (CEST)
Received: from pollux.sshunet.nl ([127.0.0.1])
	by localhost (pollux.sshunet.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6P3YlZvxXbrl for <linux-ext4@vger.kernel.org>;
	Sun, 18 May 2008 12:37:41 +0200 (CEST)
Received: from guust.tuxes.nl (15pc197.sshunet.nl [145.97.197.15])
	by pollux.sshunet.nl (Postfix) with ESMTP
	for <linux-ext4@vger.kernel.org>; Sun, 18 May 2008 12:37:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by guust.tuxes.nl (Postfix) with ESMTP id E3CA0A80B3
	for <linux-ext4@vger.kernel.org>; Sun, 18 May 2008 12:37:40 +0200 (CEST)
Received: from guust.tuxes.nl ([127.0.0.1])
	by localhost (guust.tuxes.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GKTPn+Ms3cHw for <linux-ext4@vger.kernel.org>;
	Sun, 18 May 2008 12:37:38 +0200 (CEST)
Received: from [192.168.101.158] (15pc197.sshunet.nl [145.97.197.15])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by guust.tuxes.nl (Postfix) with ESMTP id B4FC2A8094
	for <linux-ext4@vger.kernel.org>; Sun, 18 May 2008 12:37:38 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Lately I encountered some vague corruptions on my filesystem which were
probably caused several weeks ago. My setup is quite extraordinary
(using ATA over Ethernet, RAID5, LVM, LUKS), a simple undetected network
failure did most probably cause these corruptions.

After I recovered the filesystem I decided to set up a weekly cron job
to perform an automatic e2fsck on a snapshot. This way, no
inconsistencies go undetected for longer than a week and problems can be
fixed before additional corruption occurs. However, there is a slight
problem with scripting e2fsck: it seems that e2fsck /always/ exits with
exit code 1 just because of the fact that the snapshot journal has been
replayed. Because of this, the script cannot tell whether there is a
real problem or not and keeps e-mailing me. This is a typical output of
such an e2fsck run:
> # e2fsck.static -f -y -v /dev/loop1
> e2fsck 1.40.8 (13-Mar-2008)
> /dev/loop1: recovering journal
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
>
> /dev/loop1: ***** FILE SYSTEM WAS MODIFIED *****
>
> 12609263 inodes used (4.58%)
>   258729 non-contiguous inodes (2.1%)
>          # of inodes with ind/dind/tind blocks: 1174647/20098/15
> 485401393 blocks used (88.17%)
>        0 bad blocks
>      108 large files
>
>  8730706 regular files
>  3867308 directories
>        0 character device files
>        3 block device files
>       12 fifos
> 95342096 links
>    11090 symbolic links (9640 fast symbolic links)
>      135 sockets
> --------
> 107951350 files

As you can see: no additional errors. Does anyone have any ideas on how
to work around this?

Cheers,

  Bas
