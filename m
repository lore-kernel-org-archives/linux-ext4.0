From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk addressability check
Date: Thu, 12 Aug 2010 15:32:27 -0600
Message-ID: <209AEA97-E284-4ADB-8774-50C2630606B9@dilger.ca>
References: <874ofr2myq.fsf@patl.com> <20100812174215.GC6561@mail.oracle.com> <1F3EDC08-AC93-4D4D-8F83-A13C418DFC88@dilger.ca> <20100812201534.GA22777@mail.oracle.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org Patrick J. LoPresti"
	<lopresti@gmail.com>
To: Joel Becker <Joel.Becker@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:36077 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab0HLVcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Aug 2010 17:32:54 -0400
In-Reply-To: <20100812201534.GA22777@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-12, at 14:15, Joel Becker wrote:

> On Thu, Aug 12, 2010 at 12:45:41PM -0600, Andreas Dilger wrote:
>> On 2010-08-12, at 11:42, Joel Becker wrote:
>>>> +int generic_check_addressable(unsigned blocksize_bits, u64 num_blocks)
>>>> +{
>>>> +	u64 last_fs_block = num_blocks - 1;
>>>> +
>>>> +	BUG_ON(blocksize_bits < 9);
>>>> +	BUG_ON(blocksize_bits > PAGE_CACHE_SHIFT);
>> 
>> I'd rather not have a BUG_ON() for a "check" function that may be called with on-disk values by some filesystem.  Some filesystems (AFAIR) also handle blocksize > PAGE_SIZE internally, so this helper would not be useful for them.
> 
> 	Filesystems that handle their own page cache certainly wouldn't
> be interested in a generic helper anyway.  All of our pagecache assumes
> blocks between 512<->PAGE_CACHE_SIZE.
> 	If I change the BUG_ON()s to -EINVAL, does that work?  Or do you
> have some way you'd like to allow non-pagecache filesystems to use this
> as well?

That's probably fine for now.  If anyone complains, we can always change it later, since they can't possibly depend on this function yet...

Cheers, Andreas





