From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Subject: Re: Uneven load on my raid disks.
Date: Wed, 29 Dec 2010 17:40:12 +0100
Message-ID: <4D1B646C.8030100@uni-konstanz.de>
References: <20101228090749.GB1351@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pyrimidin.rz.uni-konstanz.de ([134.34.240.46]:26564 "EHLO
	pyrimidin.rz.uni-konstanz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069Ab0L2QuD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Dec 2010 11:50:03 -0500
In-Reply-To: <20101228090749.GB1351@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rogier Wolff wrote:
...
> 
> http://www.goplexian.com/2010/09/6-tips-for-improving-hard-drive.html
> 
> says: 
> dumpe2fs -h /dev/md0 | grep RAID
> 
> should show wether my ext4 partition is on a RAID. Well mine is, but
> doesn't provide any output. Did I forget those raid-options during
> formatting? Can this be tuned after the fact?
> 

% tune2fs -l /dev/md0

...
RAID stride:              128
RAID stripe width:        768
...

runs much faster than dumpe2fs.
The command can also adjust the values.

HTH,
Kay
