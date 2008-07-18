From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup [NEW Version]
Date: Fri, 18 Jul 2008 13:35:32 +0200
Message-ID: <87r69ro263.fsf@frosties.localdomain>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<20080717154604.3fb8e084@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:35572 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbYGRLfi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 07:35:38 -0400
In-Reply-To: <20080717154604.3fb8e084@ichigo> (Jose R. Santos's message of
	"Thu, 17 Jul 2008 15:46:04 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Jose R. Santos" <jrs@us.ibm.com> writes:

> Hi folks,
>
> I'm posting a new version of the 64-bit mke2fs patch since it was broken
> in many ways (many thanks to Goswin for having a look and pointing them
> out).  This one can actually handle large fs as runs until its time to
> allocate table (where it barfs due bitmap issues).  To make 64bit fs, I
> use the following command.
>
> mke2fs -T ext4dev -O64bit /dev/my_large_disk

Just like ext2/3 default to a 4k blocksize if it exceeds 2^32 1k
blocks shouldn't ext4 default to 64bit if it exceeds 2^32 4k blocks?

> Comments welcome 
>
> -JRS

MfG
        Goswin
