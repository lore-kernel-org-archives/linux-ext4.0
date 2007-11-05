From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] - remove timestamps from .po files
Date: Mon, 05 Nov 2007 16:12:22 -0600
Message-ID: <472F9546.9000005@redhat.com>
References: <472F8792.6030808@redhat.com> <20071105220609.GB7480@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXKEWM2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 17:12:28 -0500
In-Reply-To: <20071105220609.GB7480@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Mon, Nov 05, 2007 at 03:13:54PM -0600, Eric Sandeen wrote:
>> Another one that's been in RH/Fedora specfiles a while.
>> Remove timestamps from .po files to avoid multilib conflicts.
>> It ain't pretty but it works.
> 
> The patch is missing remove-potcdate.sed; can you include it and
> resend it please?  Thanks!!

http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=blob;f=po/remove-potcdate.sin

:)

-Eric
