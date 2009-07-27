From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Print extent information in debugfs
Date: Sun, 26 Jul 2009 22:18:02 -0500
Message-ID: <4A6D1C6A.1000900@redhat.com>
References: <6601abe90907231336o64cdc786r634d29be822316af@mail.gmail.com> <20090727030219.GE17272@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40399 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbZG0DSH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Jul 2009 23:18:07 -0400
In-Reply-To: <20090727030219.GE17272@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

...

> The Extents and Blocks information display redundant information, so
> what I've done is to change the patch so that if the file uses
> extent-based block maps, the Extents information is displayed instead
> of the BLOCKS information, and it is extended to include more
> information, like this:
> 
> ...
>  atime: 0x4a6d164e:82c08b38 -- Sun Jul 26 22:51:58 2009
>  mtime: 0x4a6d164e:861ee098 -- Sun Jul 26 22:51:58 2009
> crtime: 0x4a6d164e:82c08b38 -- Sun Jul 26 22:51:58 2009
> Size of extra inode fields: 28
> EXTENTS:
> (0-60 #61): 342272-342332, (61-127 #67 [uninit]): 537822-537888

Perhaps a bit late, but I find the "#<extent length>" reporting very
unintuitive.  Doesn't "#X" usually imply ordering?  How about:

(0-60 [61b]): 342272-342332, (61-127 [67b,uninit]): 537822-537888

... or maybe some other ideas.  IMHO it's all a bit hard to read anyway
unless it's printed in a table format ala the new filefrag output.

-Eric

