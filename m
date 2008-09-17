From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] ext2: Avoid printk floods in the face of directory
 corruption
Date: Wed, 17 Sep 2008 12:25:56 -0700
Message-ID: <20080917122556.bfe2ec7d.akpm@linux-foundation.org>
References: <1221319971-29879-1-git-send-email-tytso@mit.edu>
	<1221319971-29879-2-git-send-email-tytso@mit.edu>
	<1221319971-29879-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, tytso@MIT.EDU, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, eugeneteo@kernel.sg
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbYIQT0t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Sep 2008 15:26:49 -0400
In-Reply-To: <1221319971-29879-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 13 Sep 2008 11:32:50 -0400
"Theodore Ts'o" <tytso@MIT.EDU> wrote:

> From: "Theodore Ts'o" <tytso@MIT.EDU>
> To: akpm@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@MIT.EDU>, Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>
> Subject: [PATCH 3/4] ext2: Avoid printk floods in the face of directory corruption
> Date: Sat, 13 Sep 2008 11:32:50 -0400
> X-Mailer: git-send-email 1.5.6.1.205.ge2c7.dirty
> 
> Note: some people thinks this represents a security bug, since it
> might make the system go away while it is printing a large number of
> console messages, especially if a serial console is involved.  Hence,
> it has been assigned CVE-2008-3528, but it requires that the attacker
> either has physical access to your machine to insert a USB disk with a
> corrupted filesystem image (at which point why not just hit the power
> button), or is otherwise able to convince the system administrator to
> mount an arbitrary filesystem image (at which point why not just
> include a setuid shell or world-writable hard disk device file or some
> such).  Me, I think they're just being silly.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Cc: Eugene Teo <eugeneteo@kernel.sg>

This patch was purportedly authored by yourself, but I'm going to
assume that it was authored by Eric.

