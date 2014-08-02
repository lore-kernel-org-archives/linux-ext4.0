From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH 0/4] quota: add project quota support
Date: Sat, 2 Aug 2014 09:35:58 +0800
Message-ID: <CAPTn0cDkN_aBZwOVCZjPcJD+8ArKvPmZcE7XHwkDRSjoXhVY+A@mail.gmail.com>
References: <CAPTn0cD3eZgL1FaJLrgN-c_vhsvSoifmyLah=y60ejcAEOz-Mg@mail.gmail.com>
	<20140801201756.GD7525@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53970 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaHBBf7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 21:35:59 -0400
Received: by mail-ie0-f174.google.com with SMTP id rp18so6999575iec.19
        for <linux-ext4@vger.kernel.org>; Fri, 01 Aug 2014 18:35:58 -0700 (PDT)
In-Reply-To: <20140801201756.GD7525@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2014-08-02 4:17 GMT+08:00 Jan Kara <jack@suse.cz>:
> On Fri 01-08-14 23:48:31, Li Xi wrote:
>> 2014-08-01 23:28 GMT+08:00 Li Xi <pkuelelixi@gmail.com>:
>> > 2014-08-01 20:40 GMT+08:00 Jan Kara <jack@suse.cz>:
>> >>
>> >> 1) It should have been also posted to linux-fsdevel@vger.kernel.org, Al Viro
>> >> <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org> because
>> >> you are changing core VFS inode and infrastructure as well. For quota
>> >> changes you should have also CCed me as a quota maintainer.
>> > Sure. Thanks for reminding me. I will add these addresses next time.
>> >>
>> >> 2) I'm not convinced we actually want project ID in the core inode - so far
>> >> only XFS has this. For everyone else it's just extra bloat so we could just
>> >> put it in ext4_inode_info. Granted we'd need to somewhat change quota
>> >> interface so that it sees all the ids (uid, gid, projid) but they are
>> >> really needed in two places - dquot_initalize() and dquot_transfer() and
>> >> creating variants of these functions that just take an array of ids and use
>> >> them in ext4 is simple enough.
>> > OK, agreed.
>> After searching dquot_initalize() and dquot_transfer(), I found changing these
>> two functions envolves too many file systems. Is there any good reason not to
>> add kprojid_t field in inode structure?
>   Yes. It grows struct inode which is used by *all* filesystems and only
> ext4 (and possibly xfs) would use it. That's why I suggested you create
> something like:
>
> struct inode_ids {
>         kuid_t uid;
>         kgid_t gid;
>         kprojid_t projid;
> };
>
> void dquot_initialize_ids(struct inode *inode, struct inode_ids *ids)
> {
> ...
> }
>
> and
>
> static inline void dquot_initialize(struct inode *inode)
> {
>         struct inode_ids ids = {
>                                 .uid = inode->i_uid,
>                                 .gid = inode->i_gid,
>                                 .projid = INVALID_PROJID,
>                         };
>         dquot_initialize_ids(inode, &ids);
> }
>
> Then filesystems not using project ids remain untouched and filesystems
> with project ids (i.e. ext4) can use dquot_initialize_ids() - probably you
> should create something like:
>
> static inline void ext4_dquot_initialize(struct inode *inode)
> {
>         struct inode_ids ids = {
>                                 .uid = inode->i_uid,
>                                 .gid = inode->i_gid,
>                                 .projid = EXT4_I(inode)->i_projid,
>                         };
>         dquot_initialize_ids(inode, &ids);
> }
>
> and use ext4_dquot_initialize() throughout ext4.
>
I tried to change it in this way, but there ia another problem. add_dquot_ref()
calls __dquot_initialize() for each inode in the list of super block. That means
there is no way to pass projid as an argument of __dquot_initialize(). The
solution is to add a get_projid() method (and maybe set_projid too) in the
inode_operations structure. Personally, I perfer to add projid in the inode
stucture, since projid looks like uid and gid of an inode.
get_projid()/setprojid()
looks duplicated with getattr()/setattr() or getxattr()/setxattr(). Is there any
performance impact of increasing size of inode structure, e.g. cache
line problem?  I will add get_projid() method if so.

Thanks,
Li Xi
