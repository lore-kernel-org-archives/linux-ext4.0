From: "Daniel K." <dk@uw.no>
Subject: Re: ext3: deleting files doesn't free up space
Date: Mon, 10 Jan 2011 06:10:49 +0000
Message-ID: <4D2AA2E9.9030209@uw.no>
References: <AANLkTimwDpUz9GUmx3UutYir0UuoTSAXNzphWeEX9sKh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from in.cluded.net ([195.159.98.120]:38915 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1AJGP4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jan 2011 01:15:56 -0500
In-Reply-To: <AANLkTimwDpUz9GUmx3UutYir0UuoTSAXNzphWeEX9sKh@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dan Carpenter wrote:
> I filled up my partition last night.
> I deleted 5 gigs of movies.
> The "Used" number went down to 125G.
> The "Free" number stayed at 0.
> I rebooted the system but it's still the same.
> 
> $ echo foo > foo
> bash: echo: write error: No space left on device
> 
> $ df .
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda1            136236548 130363620         0 100% /media/old_sys

Check out the -m option to tune2fs, which sets the reserved-blocks-percentage for the FS - the percentage of blocks reserved to the super user, which is 5% by default.

Presumably, root has filled the partition completely, and 5G worth of deleted user data is not enough to get under the 5% limit to allow for new data to be written by users.

As this partition is used for /home you might as well turn the feature off, as root should not need to have space reserved in that area of the filesystem.

	tune2fs -m 0 /dev/sda1

should give regular users access to the reserved blocks.


Daniel K.
