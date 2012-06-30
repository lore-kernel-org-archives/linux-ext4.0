From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Use s_csum_seed instead of i_csum_seed for xattr
 block csum.
Date: Sat, 30 Jun 2012 22:19:46 +0800
Message-ID: <4FEF0B02.3030501@tao.ma>
References: <1340547236-2838-1-git-send-email-tm@tao.ma> <20120626022300.GB14329@thunk.org> <20120628162726.GA2342@tux1.beaverton.ibm.com> <EFD4E943-92D1-4F51-8659-0340B11D3674@dilger.ca> <20120629181349.GA16668@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, djwong@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:39931 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754080Ab2F3OTw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 10:19:52 -0400
In-Reply-To: <20120629181349.GA16668@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/30/2012 02:13 AM, Ted Ts'o wrote:
> On Thu, Jun 28, 2012 at 08:27:06PM -0600, Andreas Dilger wrote:
>> That was my fault.  I was trying to avoid the case when some node gets
>> wrong xattr block, and there is no way to detect this.  Going from a
>> single owner (using ino as seed) to multiple owners (using block as seed)
>> is easy.  It's just the case of going from multiple owners to a single
>> one that is tricky.
>>
>> We could take the easy way out, and fall back to the block-seed checksum
>> if the inode seed checksum fails.  In the most common cases (no shared
>> block checksum, or many inodes sharing a checksum) this works fine, and
>> in the uncommon case (formerly shared block only used by one inode) it
>> would need to compute the checksum twice.  This means there are only a
>> small number of xattr blocks for which two checksums work, instead of
>> all xattr blocks which can be incorrectly referenced by any inode since
>> if the inode is pointing at that block it will also compute the right
>> checksum using the block seed.
>>
>> Note that I'm not dead set on this, but wanted to explain the reasoning
>> about how this decision got made.
> 
> I thought about proposing adding a flag to the xattr header to
> indicate whether the superblock seed or the per-inode seed should be
> used; I ultimately decided it wasn't worth the complexity that it
> would add, so I didn't bring it up.
yeah, it is type of *too much complicated* for a xattr block csum
calculation. And what's more, the case will be that csum is controlled
by the field it checksums. ;) So consider if these of 2 fields don't
meet with each other, we should trust the field and recalc the csum or
trust the csum and change the field? It will add too much complexity to
the code, both the kernel and the e2fsprogs.

Thanks
Tao
> 
> It seems to me that in the vast majority of the cases, the xattr will
> fit in the inode, especially in the SElinux and ACL case.  So the
> question is how often will we have really large xattrs.  It *should*
> be rare, since if it is happening all the time for ACL's and SElinux
> cases, performance will be disastrous.  If we do have lots of xattr
> blocks, it would make sense to be worried about per-inode seeds, but
> is it worth the extra complexity?
> 
> Eh.....  In the end it's kind of on the line as I see it.  I don't
> feel strongly enough to engineer it myself, but if someone were to
> send me the patch, I'd probably accept it.
> 
> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


