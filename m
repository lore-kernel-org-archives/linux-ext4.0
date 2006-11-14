From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext2 readdir/lookup/check_page behavior
Date: Tue, 14 Nov 2006 13:38:04 -0600
Message-ID: <455A1B1C.4070705@redhat.com>
References: <4559DFDF.30504@redhat.com> <20061114192102.GR6012@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58348 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S966300AbWKNTiJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Nov 2006 14:38:09 -0500
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061114192102.GR6012@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Nov 14, 2006  09:25 -0600, Eric Sandeen wrote:
>> has an image with a corrupt directory inode - despite having only 4 blocks, 
>> it has an extremely large i_size.
>>
>> It seems odd to me that readdir bails out with an error on the first bad 
>> page, while lookup keeps trying.  Shouldn't these be consistent?  And if 
>> so, which is the desired behavior?
> 
> I'd prefer that readdir _should_ return all of the valid directory blocks
> it can find.  Otherwise, it makes on average 1/2 of the files in that dir
> inaccessible.

in the very rare case of corruption, yes... although if ext2 is mounted
with anything other than errors=continue the fs is going to turn
somewhat useless shortly thereafter anyway.

>> Or, perhaps a check high up that says if i_size doesn't correlate to 
>> i_blocks, this inode is corrupt, and bail out early.
> 
> We did that for ext3, no?  

Yes, this is similar.  In that case we kept trying bad pages until we
had exceeded the block count, IIRC.  I was considering the possibility
of checking blocks vs. size right at the top (ext3_readdir or lookup)
and if they don't correspond, don't even bother because the information
we're starting with is known to be bad.

Looking at this one I wonder if the ext3 fix was too specific/targeted -
I'll double check it.

> It would make sense to fix ext2 in the same way.
> I'd suggest bailing out "early" == min(i_size >> blocksize, i_blocks).
> The i_blocks count is an upper limit, because it includes the overhead of
> indirect blocks.  Directories cannot be sparse.

so we could either a) keep processing pages based on i_size, until we
have passed i_blocks, or b) if i_size & i_blocks don't match,
immediately bail out because we know we have found a corrupted inode
(vs. a "normal" unreadable block...)

-Eric
