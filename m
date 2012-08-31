From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: ext4 hung tasks in linux-stable 3.0.41
Date: Fri, 31 Aug 2012 09:43:37 +0200
Message-ID: <50406B29.1090403@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@MIT.EDU>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:55633 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2HaHuU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Aug 2012 03:50:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear list,
    dear ext4 maintainers,

i'm expected every night a hang of my rsync backup process, doing a 
backup to an ext4 filesystem. Always throwing Call traces.

The hung task messages are really long so i posted it to pastebin:
http://pastebin.com/raw.php?i=9v7HEvjA

Used kernel: vanilla 3.0.41

Is this problem known? Or is there a fix for 3.0.X available?

Greets,
Stefan
