From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Date: Mon, 25 May 2009 07:26:53 +0200
Message-ID: <20090525052653.GA10812@cip.informatik.uni-erlangen.de>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de> <4A1A1094.3020903@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: David Newall <davidn@davidnewall.com>, tytso@thunk.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:33995 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbZEYF0x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2009 01:26:53 -0400
Content-Disposition: inline
In-Reply-To: <4A1A1094.3020903@davidnewall.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello David,

                        [ RESEND: CC forgotten ]

> Are you proposing to de-duplicate a live filesystem?

I do, but on the storage appliance / nfs server and not inside the VM.
But inside VM a filesystem could make the deduplication effort much
easier if it reports unused blocks to the outside world by overwriting
them with zero. I have two scenarios in the moment in my head:

        - btrfs has already checksums. I'm at the moment evaluating if
          the crc32 is good enough to find candidates for deduplication
          or if a stronger checksum is required. After that one patch
          needs to be adapted and ioctl needs to be implemented in btrfs
          which than double checks if the blocks are for real
          duplications of each other and deduplicates them

        - btrfs will be at some point be able to generate a list of
          blocks that have changed between two transactions. This list
          can be used to create an (offsite-backup).

See also: http://thread.gmane.org/gmane.comp.file-systems.btrfs/2922

                Thomas

PS: And it seems that NetApp has the above already in a product. They
have the ability to dedup blocks on WAFL and they also have a feature
that allows to have an offsite duplication of the filesystem.
