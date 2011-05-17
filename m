From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3 v2] e2image: Add support for qcow2 format
Date: Tue, 17 May 2011 10:01:21 -0600
Message-ID: <25E40602-31D9-4626-BC47-5B52C70C9380@dilger.ca>
References: <1305560604-31877-1-git-send-email-lczerner@redhat.com> <1305560604-31877-2-git-send-email-lczerner@redhat.com> <0FCF10DD-DE65-46A2-913B-531BC397DDAC@dilger.ca> <alpine.LFD.2.00.1105171254420.3449@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"sandeen@redhat.com" <sandeen@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:60362 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab1EQQBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 12:01:16 -0400
In-Reply-To: <alpine.LFD.2.00.1105171254420.3449@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-05-17, at 5:08 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Mon, 16 May 2011, Andreas Dilger wrote:
>> 
>> Because this will be linked into libext2fs, all of these functions should be converted to use the libext2 helper functions for portability reasons.
>> 
>> s/malloc(/,ext2fs_get_mem(/g
>> 
>> though in some places ext2fs_get_array() is preferable, since it does overflow checking.
> 
> I will change malloc to ext2fs_get_mem, but leave calloc as it is since
> it will zero the memory as well unliki ext2fs_get_array().

Please use ext2fs_get_mem() and memset then. I've been thinking for a while to add proper memory accounting to libext2fs for large filesystems. The current use of the system memory accounting will overflow at 32-bit values, so cannot properly account for checking very large filesystems where we already know that e2fsck is allocating more that 4GB. 

Keeping matching ext2_get_mem() and ext2fs_free_mem() is important for a number of reasons. 

Cheers, Andreas