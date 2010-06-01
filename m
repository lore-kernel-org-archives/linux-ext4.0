From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: e4defrag and immutable files
Date: Tue, 01 Jun 2010 14:28:08 -0700
Message-ID: <4C057B68.9040205@oracle.com>
References: <4C002427.3010706@zytor.com> <4C05604D.2070401@oracle.com> <20100601194924.GF4426@thunk.org> <4C0574DF.3030303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
	linux-ext4@vger.kernel.org, Joel Becker <Joel.Becker@oracle.com>,
	Mark Fasheh <mfasheh@suse.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:18813 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab0FAV2g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jun 2010 17:28:36 -0400
In-Reply-To: <4C0574DF.3030303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/01/2010 02:00 PM, Eric Sandeen wrote:
> tytso@mit.edu wrote:
>    
>> On Tue, Jun 01, 2010 at 12:32:29PM -0700, Sunil Mushran wrote:
>>      
>>> We (ocfs2) are looking to add a new attribute to denote files that
>>> have a fixed allocation on disk. But at the same time, allow writes
>>> that do not change the allocation on disk. No truncating, extending,
>>> filling holes, etc. We were thinking of calling it "Static" files.
>>>        
>> That's an interesting set of semantics, and it might make sense to
>> conflate that with a local disk "don't move or defrag" the file
>> option.  I'm not crazy with the name "static", since it could mean a
>> number of other things in other contexts, but I admit I can't think of
>> a better name.
>>
>> 					- Ted
>>      
> fixed-mapping files maybe?
>    

We had thought of the term static because we wanted the inode to
be frozen. Entire metadata including the mapping. Our aim is to
do away with cluster locks for such inodes. For ios, we were planning
to limit it to only odirect and not change the mtime. That also means
no links, touch. Yes, "static" does not fit it like a glove but that's the
best we could come up with.

Sunil
