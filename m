From: Denys Fedoryschenko <denys@visp.net.lb>
Subject: Re: btrfs BUG() & panic in __btrfs_reserve_extent(), 2.6.30-rc6
Date: Tue, 26 May 2009 13:05:42 +0300
Message-ID: <200905261305.42204.denys@visp.net.lb>
References: <200905241347.31054.denys@visp.net.lb> <20090526100540.GB25835@think>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Josef Bacik <jbacik@redhat.com>
To: Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hosting.visp.net.lb ([194.146.153.11]:54688 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbZEZKOR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 May 2009 06:14:17 -0400
In-Reply-To: <20090526100540.GB25835@think>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 26 May 2009 13:05:40 Mason wrote:
>
> Josef, it looks like the tracking code is losing some bytes ;)  The
> total bytes in the space info doesn't add up to the other numbers in
> this data.  It is worth mentioning that he's doing nodatacow.
>
> Definitely a btrfs bug, so we can trim ext4 off the list from now on,
> full quote below for Josef.
>
> -chris
>
I'm still keeping two partitions with btrfs with such failure(i have 9 HDD's, 
others i use now ext4, they do job fine for my squid, except lacking dynamic 
inode allocation), do you want me to keep partitions as is more time?
