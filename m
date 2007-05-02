From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Wed, 2 May 2007 09:23:38 +0100
Message-ID: <03C89173-3AD1-421F-B7A0-64C999BD9DAB@cam.ac.uk>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <20070501223040.GL5722@schatzie.adilger.int>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:51119 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbXEBIZF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2007 04:25:05 -0400
In-Reply-To: <20070501223040.GL5722@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 1 May 2007, at 23:30, Andreas Dilger wrote:

> On May 01, 2007  14:22 +1000, David Chinner wrote:
>> On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
>>> Hmm, I'd thought "offline" would migrate to EXTENT_UNKNOWN, but I  
>>> didn't
>>
>> I disagree - why would you want to indicate the state is unknown  
>> when we know
>> very well that it is offline?
>
> If you don't like "UNKNOWN", what about "UNMAPPED"?  I just want a
> catch-all flag that indicates "this extent contains data but there is
> nothing sensible to be returned for the extent mapping."

I like UNMAPPED.  I even use it in NTFS internally for extents maps  
that have not been read into memory yet.  (-:

On a different issue, do you think it would be worth adding an option  
flags like FIEMAP_DONT_RELOCATE or something similar that would be a  
compulsory flag and if set the FS is not allowed to move the file  
around/change the block allocation of the file.

My thinking is that the extent map is not terribly useful if the FS  
goes and relocates the file to somewhere else just after you have  
done the ioctl.  For example HFS on OSX automatically defragments  
files whilst it is running...  Linux file systems may one day do  
similar things.

Or alternatively a flag like FIEMAP_MAKE_DIRECT or something to tell  
the FS we want to access the actual raw blocks so the FS can make  
sure the data is on block aligned boundaries and if the FS does not  
support this (e.g. ZFS or a compressed or encrypted NTFS file) then  
it can return -ENOTSUP.

Perhaps this is totally the wrong interface and such a "prepare file  
for direct access" API should be a different ioctl() or syscall or  
whatever.  It just seems very simple and appropriate to combine it  
here as people who use FIEMAP are at least sometimes going to be  
wanting to access those blocks directly as well and it feels right to  
be able to communicate this to the FS in the same call, kind of like  
an "open intent" of "I want to use the data directly on disk"...

What do you think?

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
