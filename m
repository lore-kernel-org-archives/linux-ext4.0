From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: e4defrag and immutable files
Date: Tue, 01 Jun 2010 15:51:29 -0700
Message-ID: <4C058EF1.2000406@oracle.com>
References: <4C002427.3010706@zytor.com> <4C05604D.2070401@oracle.com> <20100601194924.GF4426@thunk.org> <4C0574DF.3030303@redhat.com> <4C057B68.9040205@oracle.com> <20100601222643.GI4426@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-ext4@vger.kernel.org,
	Joel Becker <Joel.Becker@oracle.com>,
	Mark Fasheh <mfasheh@suse.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:65281 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab0FAWxL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jun 2010 18:53:11 -0400
In-Reply-To: <20100601222643.GI4426@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/01/2010 03:26 PM, tytso@mit.edu wrote:
> On Tue, Jun 01, 2010 at 02:28:08PM -0700, Sunil Mushran wrote:
>    
>> We had thought of the term static because we wanted the inode to
>> be frozen. Entire metadata including the mapping. Our aim is to
>> do away with cluster locks for such inodes. For ios, we were planning
>> to limit it to only odirect and not change the mtime. That also means
>> no links, touch. Yes, "static" does not fit it like a glove but that's the
>> best we could come up with.
>>      
> Hmm, maybe "fixed_metadata"?  The one thing that worries a bit is not
> touching mtime is definitely icky.  I suppose it would improve
> performance even on local-disk file systems if we don't update mtime,
> ctime, or atime.  So maybe that would be useful for folks who are
> trying to extract the last bit of performance out of their enterprise
> database.
>
> One thing I do like about fixed_metadata is that as far as chattr and
> lsattr is concerned 's' and 'S' are already taken.  But 'f' and 'F'
> aren't allocated yet.  :-)
>
>    

Fixed Metadata sounds good to me.

The mtime restriction is icky. But for us it is a requirement
considering we cannot safely update it without cluster locks.
I am ok if we can make that file system specific.
