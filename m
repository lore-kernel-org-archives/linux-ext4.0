From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: sync the directory inode in ext4_sync_parent()
Date: Tue, 5 Apr 2011 12:43:51 -0700
Message-ID: <BANLkTin2VdByS23f0Gg-m77wUr3RVYgkiQ@mail.gmail.com>
References: <1302031663-13547-1-git-send-email-curtw@google.com>
	<4D9B6F0A.5080705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:61405 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1DETny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 15:43:54 -0400
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com [172.25.149.11])
	by smtp-out.google.com with ESMTP id p35JhrnY015440
	for <linux-ext4@vger.kernel.org>; Tue, 5 Apr 2011 12:43:53 -0700
Received: from qyk10 (qyk10.prod.google.com [10.241.83.138])
	by hpaq11.eem.corp.google.com with ESMTP id p35JgtUg025375
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 5 Apr 2011 12:43:52 -0700
Received: by qyk10 with SMTP id 10so618333qyk.11
        for <linux-ext4@vger.kernel.org>; Tue, 05 Apr 2011 12:43:51 -0700 (PDT)
In-Reply-To: <4D9B6F0A.5080705@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric:

On Tue, Apr 5, 2011 at 12:35 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> On 4/5/11 12:27 PM, Curt Wohlgemuth wrote:
>> ext4 has taken the stance that, in the absence of a journal,
>> when an fsync/fdatasync of an inode is done, the parent
>> directory should be sync'ed if this inode entry is new.
>> ext4_sync_parent(), which implements this, does indeed sync
>> the dirent pages for parent directories, but it does not
>> sync the directory *inode*. =A0This patch fixes this.
>>
>> I tested this using a power fail test, which panics a
>> machine running a file server getting requests from a
>> client. =A0Without this patch, on about every other test run,
>> the server is missing many, many files that had been synced.
>> With this patch, on > 6 runs, I see zero files being lost.
>>
>> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>> ---
>> =A0fs/ext4/fsync.c | =A0 11 ++++++++++-
>> =A01 files changed, 10 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
>> index 7f74019..a276348 100644
>> --- a/fs/ext4/fsync.c
>> +++ b/fs/ext4/fsync.c
>> @@ -128,6 +128,7 @@ extern int ext4_flush_completed_IO(struct inode =
*inode)
>> =A0static void ext4_sync_parent(struct inode *inode)
>> =A0{
>> =A0 =A0 =A0 struct dentry *dentry =3D NULL;
>> + =A0 =A0 int ret;
>>
>> =A0 =A0 =A0 while (inode && ext4_test_inode_state(inode, EXT4_STATE_=
NEWENTRY)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_clear_inode_state(inode, EXT4_STATE=
_NEWENTRY);
>> @@ -136,7 +137,15 @@ static void ext4_sync_parent(struct inode *inod=
e)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!dentry || !dentry->d_parent || !den=
try->d_parent->d_inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode =3D dentry->d_parent->d_inode;
>> - =A0 =A0 =A0 =A0 =A0 =A0 sync_mapping_buffers(inode->i_mapping);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sync_mapping_buffers(inode->i_mapp=
ing);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (! ret) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct writeback_control w=
bc =3D {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .sync_mode=
 =3D WB_SYNC_ALL,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .nr_to_wri=
te =3D 0, /* metadata-only; caller
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0takes care of data */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 };
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void)sync_inode(inode, &w=
bc);
>
> I know ext4_sync_parent was a void already, but why don't we send err=
ors back up through ext4_sync_file?

Well, you could argue that a failure to sync the parent shouldn't
cause the inode's fsync() to fail, but I probably wouldn't :-) .  I'll
resend a patch that implements this.

Thanks,
Curt

>
> -Eric
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> =A0}
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
