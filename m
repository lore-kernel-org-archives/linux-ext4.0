From: Shehjar Tikoo <shehjart@cse.unsw.edu.au>
Subject: Crash and stack trace for jbd2 under ext4
Date: Mon, 21 Jul 2008 14:28:39 +1000
Message-ID: <48841077.500@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:34638 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756778AbYGUEtX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jul 2008 00:49:23 -0400
Received: From
	[203.143.160.170] ([203.143.160.170] == chaos.ken.nicta.com.au) (auth-user shehjart) (cse-authentic-sender shehjart)
	(for <linux-ext4@vger.kernel.org>) By note With Smtp ;
	Mon, 21 Jul 2008 14:43:16 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all

Please see the contents of the file
for details of two similar crashes observed
on two different commits. Both crashes were
observed while using ext4 on the server while
accessing the export through NFSv3. The link
has more details.

http://www.gelato.unsw.edu.au/~shehjart/docs/jbd_ext4_crash.txt

Shehjar
