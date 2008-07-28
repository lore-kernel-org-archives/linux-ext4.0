From: Shehjar Tikoo <shehjart@cse.unsw.edu.au>
Subject: Re: Porting Zfs features to ext2/3
Date: Mon, 28 Jul 2008 13:42:34 +1000
Message-ID: <488D402A.2030806@cse.unsw.edu.au>
References: <18674437.post@talk.nabble.com> <20080727224958.GB7922@mit.edu> <488CFB6E.3020602@cse.unsw.edu.au> <20080727233707.GA9378@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: postrishi <postrishi@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:46557 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbYG1D7c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2008 23:59:32 -0400
In-Reply-To: <20080727233707.GA9378@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Jul 28, 2008 at 08:49:18AM +1000, Shehjar Tikoo wrote:
>> Hi Ted
>>
>> Theodore Tso wrote:
>>> The btrfs filesystem effort is an attempt to create a filesystem that 
>>> will leapfrog the ZFS feature set, but it will probably take longer to 
>>> reach production ready status than ext4.
>> Since you mention btrfs here and since I've read this earlier too, do
>> you know if btrfs will be the default Linux file system in the future,
>> like extX has been?
> 
 > ...
> What happens in the future, who can say?  At some point the ext2/3/4
> filesystem, which is based fundamentally on a BSD Fast Filesystem
> design base, may get displaced by a filesystem which uses some very
> different design as a starting point, when the advantages of starting
> with that different design outweighs the advantages of backwards
> compatibility and broad base of support which is enjoyed by ext2/3/4.

Thanks. That sums up the trade-off pretty clearly.


-Shehjar
