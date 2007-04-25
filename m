From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Cannot delete a file - could it be ext3 related?
Date: Wed, 25 Apr 2007 05:26:51 -0600
Message-ID: <20070425112651.GS5967@schatzie.adilger.int>
References: <200704251154.27840.dgvirtual@akl.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Donatas G." <dgvirtual@akl.lt>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:45865 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992691AbXDYL0y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Apr 2007 07:26:54 -0400
Content-Disposition: inline
In-Reply-To: <200704251154.27840.dgvirtual@akl.lt>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 25, 2007  11:54 +0300, Donatas G. wrote:
> I have a problem with system upgrade (Kubuntu Edgy to Feisty) which is caused 
> by the systems inability to remove a corrupted file. I suspect this could be 
> filesystem related, so I am writing to this list. 
> 
> Since I am not subscribed, COULD YOU SEND ME RESPONCES DIRECTLY?
> 
> I ran fsck /dev/hda5 (my partition) to no avail - the filesystem used to 
> contain errors, but they are all corrected before this upgrade.
> 

Try "chattr -i" on the file.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
