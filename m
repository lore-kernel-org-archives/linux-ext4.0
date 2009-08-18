From: Andreas Dilger <adilger@sun.com>
Subject: Re: Troubleshooting pendrive ext2fs
Date: Tue, 18 Aug 2009 16:32:32 -0600
Message-ID: <20090818223232.GP5931@webber.adilger.int>
References: <4A8B289E.5000701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Casimiro de Almeida Barreto <casimiro.barreto@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36227 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZHRWce (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Aug 2009 18:32:34 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7IMWZ3t026327
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 15:32:36 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KOL00J00FOR3L00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 18 Aug 2009 15:32:35 -0700 (PDT)
In-reply-to: <4A8B289E.5000701@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 18, 2009  19:18 -0300, Casimiro de Almeida Barreto wrote:
> I've trouble creating an ext2/ext3/ext4 file system in a 64GBytes pendrive.

99.99% chance this is a device or driver failure, not ext2/3/4 related.
Try writing to the raw device and seeing if that works (e.g. use
"llverdev" tool from Lustre, or just "dd" with a known pattern and
then md5sum to verify it.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

