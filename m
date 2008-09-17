From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/4] ext2: Avoid printk floods in the face of directory
 corruption
Date: Wed, 17 Sep 2008 12:30:14 -0700
Message-ID: <48D15AC6.3060608@redhat.com>
References: <1221319971-29879-1-git-send-email-tytso@mit.edu>	<1221319971-29879-2-git-send-email-tytso@mit.edu>	<1221319971-29879-3-git-send-email-tytso@mit.edu> <20080917122556.bfe2ec7d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, eugeneteo@kernel.sg
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41675 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbYIQTd0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Sep 2008 15:33:26 -0400
In-Reply-To: <20080917122556.bfe2ec7d.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton wrote:
> On Sat, 13 Sep 2008 11:32:50 -0400
> "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> 
>> From: "Theodore Ts'o" <tytso@MIT.EDU>
>> To: akpm@linux-foundation.org
>> Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@MIT.EDU>, Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>
>> Subject: [PATCH 3/4] ext2: Avoid printk floods in the face of directory corruption
>> Date: Sat, 13 Sep 2008 11:32:50 -0400
>> X-Mailer: git-send-email 1.5.6.1.205.ge2c7.dirty
>>
>> Note: some people thinks this represents a security bug, since it
>> might make the system go away while it is printing a large number of
>> console messages, especially if a serial console is involved.  Hence,
>> it has been assigned CVE-2008-3528, but it requires that the attacker
>> either has physical access to your machine to insert a USB disk with a
>> corrupted filesystem image (at which point why not just hit the power
>> button), or is otherwise able to convince the system administrator to
>> mount an arbitrary filesystem image (at which point why not just
>> include a setuid shell or world-writable hard disk device file or some
>> such).  Me, I think they're just being silly.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> Cc: linux-ext4@vger.kernel.org
>> Cc: Eugene Teo <eugeneteo@kernel.sg>
> 
> This patch was purportedly authored by yourself, but I'm going to
> assume that it was authored by Eric.

It was, after some discussion w/ Ted & Andreas.

Also just FWIW I'm also in the "as a security issue this is a bit silly"
camp ;)

Thanks,
-Eric
