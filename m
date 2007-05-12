From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Sat, 12 May 2007 12:33:25 +0400
Message-ID: <46457BD5.8040301@clusterfs.com>
References: <20070512020248.GQ6375@schatzie.adilger.int> <1178957506.20145.41.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:58259 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbXELIds (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 May 2007 04:33:48 -0400
In-Reply-To: <1178957506.20145.41.camel@eric-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Eric wrote:
> The concept is really tempting. RAID is good, and not asking the user
> for information that the system can find out for itself is good too.
> 
> In the unlikely event that the RAID stride were to change, I think the
> autodetect-each-time method would be superior to the store-in-superblock
> method. Doubly so if the code to detect MD and LVM stride is lean and
> clean.

true, but in some cases (hardware raid, SAN, etc) there is no easy way
to learn that other than asking user.

thanks, Alex
