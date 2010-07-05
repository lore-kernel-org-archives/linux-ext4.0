From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Always journal quota file modifications
Date: Mon, 05 Jul 2010 15:08:12 -0500
Message-ID: <4C323BAC.5030101@redhat.com>
References: <1275488593-7237-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab0GEUIW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jul 2010 16:08:22 -0400
In-Reply-To: <1275488593-7237-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
> When journaled quota options are not specified, we do writes
> to quota files just in data=ordered mode. This actually causes
> warnings from JBD2 about dirty journaled buffer because ext4_getblk
> unconditionally treats a block allocated by it as metadata. Since
> quota actually is filesystem metadata, the easiest way to get rid
> of the warning is to always treat quota writes as metadata...
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Where are we at on this one?  I was trawling through my old RH bugs
today, and have one that this patch will resolve.  Ted, did you
get comfortable with it?

Thanks,
-Eric
