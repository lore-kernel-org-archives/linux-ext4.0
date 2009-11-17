From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] A request to reserve a "tree id" field on ext[34] inodes
Date: Wed, 18 Nov 2009 00:19:11 +0300
Message-ID: <87lji4svcg.fsf@openvz.org>
References: <4B02AD8B.2030202@openvz.org>
 <0D1BE31B-34F9-40A1-8C7F-6A9FFF18DA8E@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Pavel Emelyanov <xemul@openvz.org>, Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:49388 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbZKQVTK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Nov 2009 16:19:10 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KT900FYTVFFVG20@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Wed, 18 Nov 2009 00:23:42 +0300 (MSK)
In-reply-to: <0D1BE31B-34F9-40A1-8C7F-6A9FFF18DA8E@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger <adilger@sun.com> writes:

> On 2009-11-17, at 06:04, Pavel Emelyanov wrote:
>> We have a proposal to implement a 2-level disk quota on ext3 and ext4.
>>
>> In two words - the aim is to have directories on ext3/4 partitions
>> which are limited by its disk usage and the number of inodes. Further
>> the plan is to allow configuring uid and gid quotas within them.
>>
>> The main usage of this is containers. When two or more of them are
>> located on one disk their roots will be marked with a unique tree id
>> and thus the disk consumption of each container will be limited. While
>> achieving this goal having an id of what tree an inode belongs to is
>> a key requirement.
>
> How do you handle files with multiple links, if they are located in
> different trees?  The inode would need to have multiple tree ids.
A short answer is "NO", inode can not belongs to multiple trees.
Containers has some non obvious specific. 
Each container isolated from another as much as possible. 
Container has its own root tree. This tree is exported inside
CT by numerous possible ways (name-space, virtual-stack-fs, chroot)

So container's root are independent tree or several trees.
usually they organized like follows /ct_root/CT_${ID}/${tree_content}
There are many reasons to keep this trees separate one from another
   - inode attr: 
     If inode has links in A n B trees. And A-user call chown() for
     this inode, then B's owner will be surprised.
     The only way to overcome this is to virtualize inode atributes
     (for each tree) which is madness IMHO.
   - checkpoint/restore/online-backup:
     This is like suspend resume for VM, but in this case only
     container's process are stopped(freezed) for some time. After CT's
     process are stopped we may create backup CT's tree without freezing
     FS as a whole.
As I already say there are many way to accomplish this task. But everyone
has strong disadvantages:
Virtual block devices(qemu-like): problems with consistency and performance
ext3/4 + stack-fs(unionfs/vzfs): Bad failure resistance. It is
        impossible to support jorunalling quota file on stack-fs level.
XFS with proj quota : Lack of quota file journalling. XFS itself
        (please dont balme me, but i'm really not huge XFS fan)

So the only way to implement journalled quota for containers is to
implement it on native fs level.

"Containers directory tree-id" assumptions:
(1) Tree id is embedded inside inode
(2) Tree id is inherent from parent dir
(3) Inode can not belongs to different directory trees

Default directory tree (with id == 0) has special meaning.
directory which belongs to default tree may contains roots of
other trees. Default tree is used for subtree manipulation.

->rename restriction:
  if (S_ISDIR(old_inode->i_mode)) {
      if ((new_dir->i_tree_id == 0) || /* move to default tree */
               (new_dir->i_tree_id == old_inode->i_tree_id)) /*same tree */
             goto good;
      return -EXDEV;
  } else {
      /* If entry have more than one link then it is bad idea to allow
         rename it to different (even if it's default tree) tree,
         because this result in rule (3) violation.
      if (old_inode->i_nlink > 1) && 
                    (new_dir->i_tree_id != old_inode->i_tree_id)
            return -EXDEV;
 }
->link restriction: /* Links may  belongs to only one tree */
   if(new_dir->i_tree_id != old_inode->i_tree_id)
            return -EXDEV;

>
> You can instead just store this data in an xattr (which will normally
> be stored in the inode, so no performance impact), and then you are
> free to store multiple values per inode.
Yes xattr is possible, but struct ext4_xattr_entry is so big plus 
space for attr_name ...., But we only want 4 bytes.
In fact i've made a proof of concept patch it contains all necessary
for tree quota support. I'll post it if you interesting.

>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
