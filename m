From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Ext4 developers get-together at the Collab Summit
Date: Fri, 18 Jan 2013 07:06:26 -0500
Message-ID: <20130118120626.GB2761@localhost.localdomain>
References: <nsxzk0blt27.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab3ARMGd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 07:06:33 -0500
Content-Disposition: inline
In-Reply-To: <nsxzk0blt27.fsf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I'm not sure yet if I'll be able to go to LSF (need invite), but if I go, I'd
like to attend Ext4 meeting, and I'd like to bring a discussion about a topic we
already discussed but didn't go further, about the mount options we
should/shouldn't support for each filesystem, i.e. today we have some mount
options that although are not supported for a specific filesystem, it can be
used to mount that filesystem, one example is mounting ext3 using
journal_checksum and ext2 with commit=nrsec.

Once we are mostly using ext4 driver to mount ext3 and ext2 fs, I wonder we
should handle these mount options and deny/warning a mount with
wrong/non-supported options. Also, I wonder how useful would be to start do
deprecate ext2/ext3 drivers and just add bugfix to these. Not sure if this is
already being done, but keeping ext4 as primary ext2/3/4 driver should reduce
code maintenance and duplication.



On Mon, Jan 14, 2013 at 09:48:00AM -0500, Theodore Ts'o wrote:
> Hi,
> 
> 	The Linux Foundation's Collaboration Summit is April 15-17th,
> and the Linux Storage, File System, and MM Summit is April 18-19th in
> San Francisco (at the Parc 55 hotel).
> 
> 	I'd like to organize an ext4 developer's meeting during the
> Collab Summit sometime April 15-17th, since so many of us will hopefully
> be attending LSF.  (The CFP will hopefully be coming soon for LSF.)
> 
> 	If you're interested in attending, please reply to this thread,
> and include some suggested topics that you'd be interested in
> discussing.  Based on the number of topics and the number of people who
> are planning on attending, I'll know how much time we need to reserve
> and how big of a room to request.
> 
> 	Also, if you need a invitation letter for Visa purposes, also
> please let me know.  I can arrange for the Linux Foundation to get that
> letter sent, so that folks have enough time to get a Visa.
> 
> 	Thanks!!
> 
>                                                 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
