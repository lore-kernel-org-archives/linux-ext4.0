From: dmonakhov@openvz.org
Subject: Re: [PATCH 1/3] ext2: symlink must be handled via filesystem specific operation
Date: Mon, 29 Mar 2010 19:28:51 +0400
Message-ID: <877hovdu4s.fsf@openvz.org>
References: <1269620996-11400-1-git-send-email-dmonakhov@openvz.org>
	<20100329142135.GB5835@quack.suse.cz>
	<20100329142623.GC5835@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:9325 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab0C2P27 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 11:28:59 -0400
In-Reply-To: <20100329142623.GC5835@quack.suse.cz> (Jan Kara's message of
	"Mon, 29 Mar 2010 16:26:24 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Mon 29-03-10 16:21:35, Jan Kara wrote:
>> On Fri 26-03-10 19:29:54, Dmitry Monakhov wrote:
>> > generic setattr implementation is no longer responsible for
>> > quota transfer so synlinks must be handled via ext2_setattr.
>>   Ah, good catch. I'll merge ext2 and ext3 patch.
>   BTW, you forgot to add your signed-off-by. I'll take the liberty
> of adding it but please confirm so that we don't set a bad precedens
> (this legal stuff is sensitive...).
yes. It was me (Dmitry Monakhov). 
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>
>  							Honza
>> > ---
>> >  fs/ext2/symlink.c |    2 ++
>> >  1 files changed, 2 insertions(+), 0 deletions(-)
>> > 
>> > diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
>> > index 4e2426e..565cf81 100644
>> > --- a/fs/ext2/symlink.c
>> > +++ b/fs/ext2/symlink.c
>> > @@ -32,6 +32,7 @@ const struct inode_operations ext2_symlink_inode_operations = {
>> >  	.readlink	= generic_readlink,
>> >  	.follow_link	= page_follow_link_light,
>> >  	.put_link	= page_put_link,
>> > +	.setattr	= ext2_setattr,
>> >  #ifdef CONFIG_EXT2_FS_XATTR
>> >  	.setxattr	= generic_setxattr,
>> >  	.getxattr	= generic_getxattr,
>> > @@ -43,6 +44,7 @@ const struct inode_operations ext2_symlink_inode_operations = {
>> >  const struct inode_operations ext2_fast_symlink_inode_operations = {
>> >  	.readlink	= generic_readlink,
>> >  	.follow_link	= ext2_follow_link,
>> > +	.setattr	= ext2_setattr,
>> >  #ifdef CONFIG_EXT2_FS_XATTR
>> >  	.setxattr	= generic_setxattr,
>> >  	.getxattr	= generic_getxattr,
>> > -- 
>> > 1.6.6.1
>> > 
>> -- 
>> Jan Kara <jack@suse.cz>
>> SUSE Labs, CR
