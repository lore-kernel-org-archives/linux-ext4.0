From: Bernd Schubert <bs@q-leap.de>
Subject: Re: mballoc errors
Date: Thu, 27 Mar 2008 00:23:54 +0100
Message-ID: <20080326232354.GA19839@lanczos.q-leap.de>
References: <47EAC302.5040109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:60149 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbYCZXX4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Mar 2008 19:23:56 -0400
Content-Disposition: inline
In-Reply-To: <47EAC302.5040109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 26, 2008 at 04:41:22PM -0500, Eric Sandeen wrote:
> This report just came in on the fedora list...
> 
> EXT4-fs error (device dm-0): ext4_mb_generate_buddy: EXT4-fs: group 717:
> 23410 blocks in bitmap, 23411 in gd
> 
> EXT4-fs error (device dm-0): ext4_mb_generate_buddy: EXT4-fs: group 721:
> 19309 blocks in bitmap, 19333 in gd
> 
> has anyone else seen this problem in testing?  I guess it means
> freespace accounting got out of sync...?

We have seen this on ldiskfs, one time a hardware raid was writing data 
garbage and one time it was after a Lustre upgrade from 1.4 to 1.6 with
a filesystem that probably already had errors before the upgrade.

So maybe this message is a good indicator for generic problems?


Cheers,
Bernd
