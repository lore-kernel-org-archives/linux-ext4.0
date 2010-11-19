From: Dmitry <dmonakhov@openvz.org>
Subject: Ping [PATCH 0/4] RFC: introduce extended inode owner identifier v7
Date: Fri, 19 Nov 2010 08:51:36 +0300
Message-ID: <87tyjdsvx3.fsf@dmon-lap.sw.ru>
References: <1288357420-7178-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@ZenIV.linux.org.uk, jack@suse.cz, linux-ext4@vger.kernel.org,
	Ted Ts'o <tytso@mit.edu>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1288357420-7178-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 29 Oct 2010 17:03:36 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
Ping. Please take a look at the series, it has passed through some
evolution since previous version, now it is changes mostly in ext4
without annoying ifdefs in core code. 
> *Feature description*
> 1) Inode may has a project identifier which has same meaning as uid/gid.
> 2) Id is stored in inode's xattr named "system.project_id"
> 3) Id is inherent from parent inode on creation.
> 4) This id is cached in memory fs_inode structure and may be accessible
>    via s_op->get_prjid(). This field it restricted by CONFIG_PROJECT_ID.
>    So no wasting of memory happens.
> 
> 5) Since id is cached in memory it may be used for different purposes
>    such as:
> 5A) Implement additional quota id space orthogonal to uid/gid. This is
>     useful in managing quota for some filesystem hierarchy(chroot or
>     container over bindmount)
> 5B) Export dedicated fs hierarchy (only inode which has some project_id
>     will be accessible)
> 
> *User interface *
> Project id is managed via generic xattr interface "system.project_id"
> This good because
>  1) We may use already existing interface.
>  2) xattr already supported by generic utilities tar/rsync and etc
> 
> PATCH SET TOC:
> 1) generic projectid support
> 2) generic project quota support
> 3) ext4 project support implementation
>  3A) ext4: generic project support
>  3B) ext4: project quota support
> 
> Patch against -next-20101028.
> Actually vfs part is really small, and most changes happen in ext4-tree
> 
> Changes against v6
>  - get rid of iattr stuff, current __dquot_transfer() provides sane interface
>    for quota manipulation. i_prjid can must be changed only by fs-speciffic
>    methods so only get() method is really necessery.
>  - remove #ifdef tricks from generic code.
>  - move i_prjid from vfs_inode to fs_inode, to prevent inode bloating.
>  - get rid of isolation logic, because this feature confuse most users.
> Changes against v5
>  - convert dquota_transfer to struct iattr interface. Not it is possible
>    to change i_prjid via notify_changes()
>  - some bugfixes.
> 
