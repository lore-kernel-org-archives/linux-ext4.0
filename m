From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V7 03/23] ext4: Add the basic function for inline data
 support.
Date: Tue, 04 Dec 2012 00:17:04 +0800
Message-ID: <50BCD080.70702@tao.ma>
References: <1351047002-4723-1-git-send-email-tm@tao.ma> <1351047338-4963-1-git-send-email-tm@tao.ma> <1351047338-4963-3-git-send-email-tm@tao.ma> <20121203014823.GA5507@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:53217 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751758Ab2LCQRJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2012 11:17:09 -0500
In-Reply-To: <20121203014823.GA5507@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
	As in the concall, it seems that you still have some questions about
this flag, so in general if a file has inline data,
EXT4_STAT_MAY_INLINE_DATA is definitely set(in delalloc, it is used as
another indication, will be explained later) while if a file has this
flag, it can be inlined or not. And if an inode doesn't have this flag,
it is definitely not an inline file.

I will explain one by one with the result I get from 'grep'.
grep -n EXT4_STATE_MAY_INLINE_DATA fs/ext4/*.c

fs/ext4/ialloc.c:907:		ext4_set_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA);
This flag is set when we init a new inode when inline data is enabled.

fs/ext4/inline.c:155:		ext4_set_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA);
Set when we found inline data from an inode disk read. It is OK since an
inline data file should have this flag.

fs/ext4/inline.c:287:					       EXT4_STATE_MAY_INLINE_DATA);
If we can't create the inline data for this file, clear this flag.

fs/ext4/inline.c:360:	ext4_set_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA);
set this flag when we update the inline data.

fs/ext4/inline.c:376:	if (!ext4_test_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA))
In ext4_prepare_inline_data, we check this flag and if the flag is
cleared, it isn't an inline one. If it is set, go on to see whether we
need to create or update it. We can't check ext4_has_inline_data here
since the inline data region may not be initialized yet.

fs/ext4/inline.c:447:	ext4_clear_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA);
Inline data is destroyed, so clear it.

fs/ext4/inline.c:532:		ext4_clear_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA);
In conversion, if this file hasn't be inlined, just clear the flag, so
that we will treat it in the normal way.

fs/ext4/inline.c:794:		ext4_clear_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA);
The same conversion as above, but happens in the da path.

fs/ext4/inline.c:815:	ext4_clear_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA);
end of da conversion. This is *tricky*. Since this is delayed
allocation, we don't want to touch the on-disk format now. Just clear
this flag so that:
1. da_write_end will know that we should handle this like normal
file(work with fs/ext4/inode.c:2713)
2. future da_write_begin will try the normal way since this flag is
cleared(work with fs/ext4/inode.c:2574:)
3. finally in da_writepages, when we see this flag is cleared while
ext4_has_inline_data is set, destroy the inline data and prepare for the
real block allocation(work with fs/ext4/inode.c:2242)

fs/ext4/inline.c:1096:	ext4_set_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA);
inline data is re-created, so set the flag.

fs/ext4/inline.c:1850:		ext4_clear_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA);
fallocate conversion. The same as other conversion.

fs/ext4/inode.c:906:	if (ext4_test_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA)) {
In ext4_write_begin, we have no idea of whether this can be inlined or
not, so just check this flag. And if we have the possibility(the flag
hasn't be cleared), go on the inline data path.

fs/ext4/inode.c:2242:						EXT4_STATE_MAY_INLINE_DATA));
Work with fs/ext4/inline.c:794.

fs/ext4/inode.c:2574:	if (ext4_test_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA)) {
In ext4_da_write_begin, we have no idea of whether this can be inlined
or not, so just check this flag. And if we have the possibility(the flag
hasn't be cleared), go on the inline data path.

fs/ext4/inode.c:2713:	    ext4_test_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA) &&
Work with fs/ext4/inline.c:794.

fs/ext4/namei.c:2343:	if (ext4_test_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA)) {
In dir init.

Hope I have explained all of these clearly. If you still have something
unclear, please point it out.

Thanks
Tao

On 12/03/2012 09:48 AM, Theodore Ts'o wrote:
> On Wed, Oct 24, 2012 at 10:55:18AM +0800, Tao Ma wrote:
>> +	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
> 
> Can you write a paragraph or two about exactly what the semantics are
> of this state flag --- what it means, when it should be set, and when
> it should be cleared, etc.?
> 
> I'm not entirely sure I understand why you test
> EXT4_STATE_MAY_INLINE_DATA versus simply calling
> ext4_has_inline_data() in various places.
> 
> Thanks!!
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

