From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] fs/ext{3,4}: fix potential race when setversion ioctl updates inode
Date: Wed, 4 Jan 2012 16:15:04 -0700
Message-ID: <6C16105A-D0EE-413E-B993-F223CFC75307@dilger.ca>
References: <20120103013152.GA26455@dztty> <20120104174609.GD28907@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Djalal Harouni <tixxdz@opendz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:50465 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2ADXPH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 18:15:07 -0500
In-Reply-To: <20120104174609.GD28907@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-04, at 10:46 AM, Jan Kara wrote:
> On Tue 03-01-12 02:31:52, Djalal Harouni wrote:
>> 
>> The EXT{3,4}_IOC_SETVERSION ioctl() updates the inode without i_mutex,
>> this can lead to a race with the other operations that update the same
>> inode.
>> 
>> Patch tested.
> 
>  OK, so I've taken the patch into my tree, just updated the changelog
> which result of our discussion in this thread. I also took the ext4 part
> since there is no risk of conflict and the patch looks obvious.

Actually, I'd like to hear more about whether this is a real problem, or
if it is just a theoretical problem found during code inspection or from
some static code analysis tool?

With the metadata checksum feature we were discussing using the inode
generation as part of the seed for the directory leaf block checksum, so
that it wasn't possible to incorrectly access stale directory blocks from
a previous incarnation of the same inode number.

We were discussing just disabling this ioctl on filesystems with metadata
checksums, and printing a deprecation warning for filesystems without that
feature enabled.  I'm not aware of any real-world use for this ioctl, since
NFS cannot use it to reconstruct handles because there's no API to allocate
an inode with a specific number, so setting the generation is pointless.

This ioctl (despite its confusing name) is completely different from the
NFSv4 inode version, which is stored in i_version (and i_version_hi).

Cheers, Andreas

>> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
>> ---
>> fs/ext3/ioctl.c |    6 +++++-
>> fs/ext4/ioctl.c |    6 +++++-
>> 2 files changed, 10 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
>> index ba1b54e..e7b2ed9 100644
>> --- a/fs/ext3/ioctl.c
>> +++ b/fs/ext3/ioctl.c
>> @@ -134,10 +134,11 @@ flags_out:
>> 			goto setversion_out;
>> 		}
>> 
>> +		mutex_lock(&inode->i_mutex);
>> 		handle = ext3_journal_start(inode, 1);
>> 		if (IS_ERR(handle)) {
>> 			err = PTR_ERR(handle);
>> -			goto setversion_out;
>> +			goto unlock_out;
>> 		}
>> 		err = ext3_reserve_inode_write(handle, inode, &iloc);
>> 		if (err == 0) {
>> @@ -146,6 +147,9 @@ flags_out:
>> 			err = ext3_mark_iloc_dirty(handle, inode, &iloc);
>> 		}
>> 		ext3_journal_stop(handle);
>> +
>> +unlock_out:
>> +		mutex_unlock(&inode->i_mutex);
>> setversion_out:
>> 		mnt_drop_write(filp->f_path.mnt);
>> 		return err;
>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>> index a567968..46a8de6 100644
>> --- a/fs/ext4/ioctl.c
>> +++ b/fs/ext4/ioctl.c
>> @@ -158,10 +158,11 @@ flags_out:
>> 			goto setversion_out;
>> 		}
>> 
>> +		mutex_lock(&inode->i_mutex);
>> 		handle = ext4_journal_start(inode, 1);
>> 		if (IS_ERR(handle)) {
>> 			err = PTR_ERR(handle);
>> -			goto setversion_out;
>> +			goto unlock_out;
>> 		}
>> 		err = ext4_reserve_inode_write(handle, inode, &iloc);
>> 		if (err == 0) {
>> @@ -170,6 +171,9 @@ flags_out:
>> 			err = ext4_mark_iloc_dirty(handle, inode, &iloc);
>> 		}
>> 		ext4_journal_stop(handle);
>> +
>> +unlock_out:
>> +		mutex_unlock(&inode->i_mutex);
>> setversion_out:
>> 		mnt_drop_write(filp->f_path.mnt);
>> 		return err;
>> -- 
>> 1.7.1
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR


Cheers, Andreas





