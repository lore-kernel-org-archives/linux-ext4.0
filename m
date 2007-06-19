From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Updated patches for journal checksums.
Date: Tue, 19 Jun 2007 12:03:10 +0400
Message-ID: <46778DBE.3090801@clusterfs.com>
References: <1182239437.3784.11.camel@dhcp7.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:59175 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbXFSIDZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2007 04:03:25 -0400
In-Reply-To: <1182239437.3784.11.camel@dhcp7.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

say, at mount time we fund transaction logged. this means part of it can be
on a disk. what do we do if transaction in the journal is found with wrong
checksum? leave partial transaction in-place?

thanks, Alex

Girish Shilamkar wrote:
> Hi,
> 	The journal checksums patches for ext4 and e2fsprogs sent on 30th May
> had run into problems on big-endian machines. I have made the required
> changes. 
> The major updates are:
> 1. Checksum was written in little endian format in the commit header,
> changed it to big-endian.
> 2. The crc32 code ported to userspace (which is used by e2fsprogs) had
> problem with #ifdef, fixed that.
> 3. The crc32 user space code used i386 assembly code for swabbing
> changed it to generic one.
> 4. Removed various #includes, which caused compilation errors on ppc
> machine.
> 
> Any comments/suggestions are always welcome.
> 
> Thanks,
> Girish.
> 
