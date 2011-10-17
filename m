From: Bas van Schaik <bas@tuxes.nl>
Subject: Used dd to copy an ext4 filesystem, but target contained an old (mounted!)
 filesystem
Date: Mon, 17 Oct 2011 12:52:36 +0100
Message-ID: <4E9C1704.5000304@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hermes.tetra.nl ([87.251.57.141]:37204 "EHLO hermes.tetra.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab1JQMUF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Oct 2011 08:20:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by hermes.tetra.nl (Postfix) with ESMTP id 1E3AE5E2769
	for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 13:52:54 +0200 (CEST)
Received: from hermes.tetra.nl ([127.0.0.1])
	by localhost (hermes.tetra.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gspVM8nEXfLm for <linux-ext4@vger.kernel.org>;
	Mon, 17 Oct 2011 13:52:47 +0200 (CEST)
Received: from guust.tuxes.nl (guust.localdomain.tetra.nl [172.26.5.63])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by hermes.tetra.nl (Postfix) with ESMTP id 7FABF658006
	for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 13:52:44 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by guust.tuxes.nl (Postfix) with ESMTP id 8D2942DC002
	for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 12:49:05 +0100 (BST)
Received: from guust.tuxes.nl ([127.0.0.1])
	by localhost (guust.tuxes.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4d-nRY6Tawd3 for <linux-ext4@vger.kernel.org>;
	Mon, 17 Oct 2011 12:49:01 +0100 (BST)
Received: from [129.67.194.130] (bilby.oerc.ox.ac.uk [129.67.194.130])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: bas@guust)
	by guust.tuxes.nl (Postfix) with ESMTP id 1E4152DC001
	for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 12:49:01 +0100 (BST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Long story short: I dd'ed 1.5TB of data to an LVM volume 'newdata' that 
already contained a filesystem (which I wanted to get rid of). 
Unfortunately, the old filesystem turned out to be mounted during the 
dd. After noticing this, I quickly created LVM snapshots of the 
'newdata' volume before unmounting the old filesystem (hoping that it 
didn't write out it fs data structures to 'newdata' yet, as I didn't 
access it) and tried mounting the snapshot. Unfortunately, it showed the 
old directory listing.

The actual data is definitely sitting on the 'newdata' volume, but the 
filesystem datastructures simply don't know about it. The source of the 
data is definitely gone, I can't simply dd it again.

Is there any other location where ext4 stores a copy of its data 
structures? Or any other tips & tricks?

Many thanks,

   Bas
