From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: e4defrag and immutable files
Date: Wed, 02 Jun 2010 11:02:18 -0700
Message-ID: <4C069CAA.50304@oracle.com>
References: <4C002427.3010706@zytor.com> <4C05604D.2070401@oracle.com> <20100601194924.GF4426@thunk.org> <4C06083B.7050102@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Joel Becker <Joel.Becker@oracle.com>,
	Mark Fasheh <mfasheh@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:44074 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402Ab0FBSD6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2010 14:03:58 -0400
In-Reply-To: <4C06083B.7050102@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/02/2010 12:28 AM, H. Peter Anvin wrote:
> On 06/01/2010 12:49 PM, tytso@mit.edu wrote:
>> On Tue, Jun 01, 2010 at 12:32:29PM -0700, Sunil Mushran wrote:
>>>
>>> We (ocfs2) are looking to add a new attribute to denote files that
>>> have a fixed allocation on disk. But at the same time, allow writes
>>> that do not change the allocation on disk. No truncating, extending,
>>> filling holes, etc. We were thinking of calling it "Static" files.
>>
>> That's an interesting set of semantics, and it might make sense to
>> conflate that with a local disk "don't move or defrag" the file
>> option.  I'm not crazy with the name "static", since it could mean a
>> number of other things in other contexts, but I admit I can't think of
>> a better name.
>>
>
> For what it's worth, this sort of seems to be what one would expect if 
> a file is *both* "fixed" and "immutable".

"Immutable" means the contents do not change. But the file mappings
could change.

"Fixed mapping" means the mappings do not change but contents
could (as long as the ondisk mappings don't).

"Fixed metadata" means the entire inode (mappings included) cannot
change but the contents could (as long as the ondisk mappings don't).
(This does have the side effect of allowing writes without touching the
mtime. Like XFS' invisible i/o.)

What the boot loader needs is "Fixed mapping". I am sure there could be
other use cases for it too.

My suggestion would be to implement "Fixed mapping" as is and not have
it tied to "Fixed metadata". While we would like to use a chattr flag 
for this
feature, it is not a requirement.

Sunil

