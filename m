From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, E2FSPROGS] blkid: Automatically chose between ext4 and
 ext4dev as appropriate
Date: Fri, 08 Feb 2008 16:50:37 -0600
Message-ID: <47ACDCBD.8040009@redhat.com>
References: <E1JNboG-0000IP-8D@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYBHWu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2008 17:50:59 -0500
In-Reply-To: <E1JNboG-0000IP-8D@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> I plan to release this in an upcoming 1.40.6 release, along with code
> that allows "tune2fs -E test_fs" to work on ext4 filesystems.  The idea
> is that if I can get this into community distro's, it will make it
> easier for them to experiment with ext4/ext4dev, with the appropriate
> forward compatibility when sometime (hopefully 2.6.26 or 2.6.27?) we
> rename ext4dev to ext4.
> 
> Any comments before I push this change out to the maint branch?

Seems logically correct to me... although it also seems like this has
gotten fairly complex by now, what with blkid rummaging around in
modules.dep, /proc files, etc...

-Eric
