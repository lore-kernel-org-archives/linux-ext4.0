From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Fri, 27 Aug 2010 12:57:47 -0600
Message-ID: <608119C2-BE41-4BC1-AAA3-A215C06720FE@dilger.ca>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com> <20100824131735.GD3713@quack.suse.cz> <20100825090551.DEB3.61FB500B@jp.fujitsu.com> <20100825230442.GH2738@quack.suse.cz> <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca> <20100826122754.GI3294@quack.suse.cz> <771B1868-889A-4DD1-A247-9E183395E627@dilger.ca> <20100827135838.GC3274@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:45379 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0H0S5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Aug 2010 14:57:50 -0400
In-Reply-To: <20100827135838.GC3274@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-27, at 07:58, Jan Kara wrote:
>  first let me explain one thing: I definitely agree that the issue
> spotted by Masayoshi MIZUMA is more serious than some possible problem
> with ancient e2fsprogs. What I was discussing about is, whether we should
> fix the issue with the original patch (removing the workaround from
> ext3_iget) or with my patch (putting the same logic into ext3_new_inode so
> that it does not create xattrs which ext3_iget will just ignore).

I agree that this is a safe fix, but it will propagate the workaround far into the future instead of actually fixing it.

>  The disadvantage of my fix is that xattrs for inos <= EXT3_FIRST_INO will
> be always stored out of inode, the disadvantage of the original patch is
> the remote possibility of problems with ancient e2fsprogs.

I don't think there are realistic chances of problems with older filesystems running newer kernels.  I think the workaround that was suggested below is also totally safe - instead of silently erasing the xattr (as kernels do today), or returning an error with a bad i_extra_isize (as would happen with the originally proposed patch) it will "know" that this bad value on low-numbered inodes was caused by mke2fs and just reset it instead of returning the error.

There cannot possibly be xattrs stored in-inode for ext3 due to the existing bug, and in the case of inode #11 (normally lost+found) being reallocated, the ext3_new_inode() code will correctly initialize i_extra_isize the way it does for any other new inode.

That leaves the only potential inode with a bad (but not completely invalid) i_extra_isize as root, and in (65535-127)/65535 of the cases, any bogus value would be zeroed.  The remaining 127/65536 chance would leave less space in the inode for xattrs, but have no other ill effect (the i_extra_isize space is not used for anything in ext3).

>  So do you disagree with my way of fixing things or is that fine with you
> and we just misunderstood?
>  BTW, I've attached my fix for reference again.
> 
> On Thu 26-08-10 17:59:31, Andreas Dilger wrote:
>> On 2010-08-26, at 06:27, Jan Kara wrote:
>>> On Wed 25-08-10 17:39:11, Andreas Dilger wrote:
>>>> The fix to e2fsck for this issue has been around for a long time, AFAIK.
>>>> It was only needed in the kernel while the broken mke2fs was in wide use,
>>>> and before a fixed e2fsck was available.
>>> 
>>> I agree but rather old e2fsprogs are still in use and if a filesystem
>>> created by these e2fsprogs would be (possibly on a different machine)
>>> accessed by the new kernel it would see corrupted xattrs.
>> 
>> The kernel should detect if there is the xattr magic before accessing
>> this space.  I think the only fallout of an uninitialized i_extra_isize
>> is that it might waste some space in the inode, or more likely it will
>> detect that i_extra_isize is invalid.
>> 
>> In that case, ext3 could be more friendly for (i_ino ==
>> EXT3_FIRST_INO(inode->i_sb)) it makes sense to just set i_extra_isize = 0
>> instead of returning -EIO and marking it a bad inode:
>> 
>>       if (EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
>>                ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
>>                if (EXT3_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
>>                    EXT3_INODE_SIZE(inode->i_sb)) {
>>                        /*
>>                         * Old mke2fs <= 1.37 didn't zero i_extra_isize for large
>>                         * reserved inodes.  Instead of assuming corruption and
>>                         * returning an error, just reset i_extra_isize for them.
>>                         * Remove this in 2013 (RHEL3 EOL).
>>                         */
>>                        if (inode->i_ino <= EXT3_FIRST_INO(inode->i_sb)) {
>>                                ei->i_extra_isize = 0;
>>                        } else {
>>                                brelse (bh);
>>                                ret = -EIO;
>>                                goto bad_inode;
>>                        }
>>                }
>  Ah, right I didn't know about the XATTR magic. So with the above
> workaround I'd feel safe also with the original solution.
> 
>>> I've looked at our
>>> supported products (the oldest is currently SLES9 SP3) and it has e2fsprogs
>>> 1.38. This should be new enough. But RHEL3 which is also still supported
>>> for another three years has e2fsprogs 1.32 so these are buggy. So I'd
>>> rather be on the safe side and fix the bug by consistently refusing to
>>> store extented attributes in inode for inodes <= EXT3_FIRST_INO + 1 as I
>>> don't think that really costs us much...
>> 
>> The question is what problem are you trying to prevent?  Do people run an
>> ancient RHEL3 userspace with a spanking-new 2.6.37 kernel?  Won't there
>> be all sorts of other problems there, because RHEL3 was released with a
>> 2.4.x kernel that would prevent this from happening?  It may even be that
>> Eric back-ported this fix to RHEL4 at the time...
>> 
>> Generally, either people leave their software alone, because they need
>> stability, or the people who upgrade a lot will tend to also upgrade
>> everything at the same time.  The only realistic scenario is hardware
>> failure that forces a new kernel install to support the new hardware, but
>> applications that depend on the old distro.
>> 
>> The question is whether RHEL3 has a realistic chance to work with such a
>> new kernel?  Secondly, they would have had to format their filesystem
>> with 256-byte inodes, which was almost unheard of at that time.  Finally,
>> they would have to delete lost+found and re-use that inode.  I don't
>> think the chances of this happening are very high.
>  I agree that a combination of new kernel + ancient e2fsprogs is highly
> unlikely for a single machine. But a situation where you format your
> portable USB drive on an ancient server and then attach it to your laptop
> isn't so remote, although the chance that you specify inode size 256 puts
> it in the realm of almost-fiction as well.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> <0001-ext3-Fix-lost-extented-attributes-for-inode-with-ino.patch>

