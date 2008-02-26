From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] allow tune2fs to set/clear resize_inode
Date: Tue, 26 Feb 2008 14:38:58 -0800
Message-ID: <47C49502.2090608@redhat.com>
References: <472F80F5.3030608@redhat.com> <20080226223423.GF8190@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765944AbYBZWjV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Feb 2008 17:39:21 -0500
In-Reply-To: <20080226223423.GF8190@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Nov 05, 2007 at 02:45:41PM -0600, Eric Sandeen wrote:
>> (this patch has been carried in Red Hat / Fedora rpms for a while, not 
>> sure why it never got sent upstream... clearing this allows for mounting 
>> filesystems with a resize_inode on older systems)
> 
> I just checked in the following into the e2fsprogs maint branch.

Hm, I had actually retracted this patch because as a COMPAT feature it
should have worked, right?  But, I suppose it's harmless. :)

Thanks,
-Eric
